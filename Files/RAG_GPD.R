#     ,---.  ,--.         ,----.   ,------. ,------.  
#    /  O  \ |  |        '  .-./   |  .--. '|  .-.  \ 
#   |  .-.  ||  |        |  | .---.|  '--' ||  |  \  :
#   |  | |  ||  |        '  '--'  ||  | --' |  '--'  /
#   `--' `--'`--'         `------' `--'     `-------'  
# |--------------------- AI GPD ---------------------|
# 
# Chain-of-Thought Multimodel RAG pipeline for populism scoring (Team Populism's GPD)
# + Cross-encoder Re-ranking with Score Rank Fusion
# ---------------------------------------------------------------------------- #
# Author: Eduardo Tamaki (eduardo@tamaki.ai)
# Date: July 10, 2025
#
# This script encapsulates the full retrieval-augmented populism scoring pipeline
# designed by Team Populism's AI research team. It combines a few-shot, holistic
# grading framework with a multimodal retrieval system and local LLM inference.
# ---------------------------------------------------------------------------- #

# 1. Setup & Dependencies ------------------------------------------------------
# Ensure {devtools} is available to install GitHub packages if needed
if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools")

# Reinstall my development version of AskOllama to interact with local (our server) 
# Ollama models. 
# Use `force = TRUE` to ensure updates always overwrite older versions 
devtools::install_github("ertamaki/AskOllama", force = TRUE)

# Load {reticulate} so we can call Python code/classes from within R
library(reticulate)

# 2. CoT Prompt ----------------------------------------------------------------
# This prompt template was developed in-house by TP's AI research team.
# The original release used a Chain-of-Thought (CoT) few-shot format
# (available upon request in private Git repository).
# 
# The present version adds a Multi-model Retrieval-Augmented Generation (RAG) 
# layer that works as follows:
# 1. Training speeches are embedded using an ensemble of three semantic models
# 2. Embeddings are indexed via FAISS for efficient similarity search
# 3. For each target speech, the top-k most similar training speeches are 
#    retrieved from each model
# 4. A cross-encoder re-ranks candidates to prioritize rhetorical structure 
#    similarity over mere topic similarity
# 5. Rankings from multiple models are combined using score fusion to reduce
#    individual embedding bias and capture diverse semantic dimensions
# 6. The final set of retrieved speeches is injected as contextual anchors
#    into the coding prompt
# 
# This approach yields more reproducible, example-grounded populism scores by
# ensuring retrieved examples share similar rhetorical patterns rather than
# just similar topics.
# ---------------------------------------------------------------------------- #

# ------------------------- 1. Conceptual Training ---------------------------- #
intro_system <- "You are a researcher who quantifies populist and plurlist discourse in speeches by political figures. You speak every and any language necessary. The training we present here teaches you how to classify and quantify populist and pluralist discourse in speeches by political figures. This training uses a technique called ‘holistic grading’. It will teach you 1) the definition and necessary components of populism, 2) the process of holistic grading, and 3) give several real world examples of how we want you to read, think, and grade as you analyze speeches for populist discourse."

step_1_user <- "What is populism? To explain this, we use the ideational approach to studying populism, which views populism as a Manichaean discourse that identifies good with a unified will of the people and evil with a conspiring elite.

Scholars who define populism ideationally use a variety of labels—referring to it as a political ‘style,’ a ‘discourse,’ a ‘language,’ an ‘appeal’, or a ‘thin ideology’—but all of them see it as a set of ideas rather than as a set of actions isolated from their underlying meanings for leaders and participants. What are these ideas that constitute populist discourse? …analyses of populist discourse all highlight a series of common, rough elements of linguistic form and content that distinguish populism from other political discourses. To explain them here, we draw on some of Hugo Chávez’s words, although we emphasize that these features are not unique to Chávez’s rhetoric. 
First, populism is a Manichaean discourse because it assigns a moral dimension to everything, no matter how technical, and interprets it as part of a cosmic struggle between good and evil. History is not just proceeding toward some final conflict but has already arrived, and there can be no fence sitters in this struggle. Hence, in the previous quotes we find Chávez referring to the election as a contest between the forces of good and evil. This is no ordinary contest; the opposition represents ‘the Devil himself’ while the forces allied with the Bolivarian cause are identified with Christ. Later in the speech, Chávez frames the election as a stark choice. What is at stake is not simply whether Chávez remains in power during the next presidential term but whether Venezuela becomes ‘a truly strong and free country, independent and prosperous’ or instead ‘a country reduced once more to slavery and darkness. 

Within this dualistic vision, the good has a particular identity: It is the will of the people. The populist notion of the popular will is essentially a crude version of Rousseau’s general Will. The mass of individual citizens are the rightful sovereign; given enough time for reasoned discourse, they will come to a knowledge of their collective interest, and the government must be constructed in such a way that it can embody their will. Chávez, for example, refers to his listeners as ‘el pueblo’ in the singular and talks about them as ‘the giant that awoke,’ and later in the same speech he proclaims to dedicate ‘every hour, every day’ of his life to the question of ‘how to give more power to the poor, how to give more power to the people.’ The populist notion of the general Will ascribes particular virtue to the views and collective traditions of common, ordinary folk, who are seen as the overwhelming majority. The voice of the people is the voice of god— ‘Vox populi, vox dei.’ 

On the other side of this Manichaean struggle is a conspiring elite that has subverted the will of the people. As Hofstadter (1966) eloquently describes in a classic essay on the ‘paranoid mentality’ in American politics, for populists ‘this enemy is clearly delineated: he is a perfect model of malice, a kind of amoral superman: sinister, ubiquitous, powerful, cruel, sensual, luxury-lovin’. Populism has a preoccupation with discovering and identifying this enemy, as this process is what helps negatively constitute the people.

What is the opposite of populism? While populism may have no single opposite, or even a true opposite at all, one discourse/frame that often comes up as incompatible or opposed to populism is pluralism. Indeed, in the training we will present to you, pluralism is treated as analogous to an opposite of populism such that one is rarely strongly populist and pluralist.

Political pluralism is a theory and practice of politics that recognizes and affirms the diversity of interests, values, and identities within a society, emphasizing that no single group should dominate the political process. It holds that political power is, and should be, distributed among multiple competing groups, each with legitimate input into decision-making. Political pluralism values liberal and democratic institutional mechanisms (like free elections, separation of powers, and legal protections for dissent) that ensure open participation and safeguard against authoritarianism. At its core, it assumes that conflict and disagreement are natural and productive elements of democratic life, best managed through negotiation, compromise, and institutional checks and balances.

This more accepting view strongly contrasts with populism in several ways. First, the view that there are many groups that can co-exists peacefully and legitimately clashes with the dualistic view of populism that perceives politics as an epic battle between two antagonistic groups, with the good people being the only legitimate force in politics. Furthermore, pluralist emphasis on good faith attempts to engage in honest debate similarly clash with populism’s view that elite are evil and conspiring and should be destroyed, not treated to good faith debate. Finally, pluralism focus on democratic and institutional means to resolve conflict juxtaposes against the more radical and sometimes illiberal framing of populist leader, who often deride institutions that protect minority interests at the expense of the majority."

step_1_ast <- "There are two necessary components to populism discourse: the idea of pure and virtuous people, and the idea of an evil conspiring elite bent on subverting the will of the people. As you score speeches, it's important to remember that both of these components need to be present. Populism increases in intensity when there is a strong Manichean element. Similarly, extensive use of pluralist rhetoric is often indicative of little to no populism, though the two frames can exist in moderate amounts. To show how you should approach scoring rhetoric for populism, let’s consider the following four hypothetical paragraphs. 

Example 1:

‘They’ve been after me from day one. The fake news media, the deep state bureaucrats, the career politicians—they’re all part of the same corrupt system that’s terrified of someone like me who doesn’t play by their rules. I didn’t need this job, I was doing great, but I’m the only one who can stop them. I alone can bring back jobs. I alone can fix the economy. I alone can protect property from criminals and illegal immigrants. I alone can fix the political system. So they will do anything to stop me.’

Here is how one should reason through this example to see if it had populist rhetoric, or just a few of the components of populism, but not all of them:

Reading through this paragraph, it is clear that the speech giver is quite antagonistic against what they consider political elite. For example, the phrase ‘The fake news media, the deep state bureaucrats, the career politicians—they’re all part of the same corrupt system that’s terrified of someone like me who doesn’t play by their rules,’ shows that the speaker is very adverse to the elite. This is strong evidence that anti-elite rhetoric is strongly present in this paragraph. 

However, I don’t see strong evidence of any pro-people discourse being in the paragraph. There is no mention of the people in the paragraph, and the main antagonist to the ‘corrupt’ elite seems to be the speaker themselves. I would say that this not enough evidence to say that populism is present here.

Finally, it's a mixed bag regarding Manichaeism. On the one hand, there is a moral aspect to the discourse in that the speech giver sees what they are doing as the ‘right thing’ and the elites they are fighting as bad people. However, the paragraph here is also not blown up to cosmic proportions in the way that is truly Manichaeism. Here, I would say that the Manichean element is somewhat present.

Noticeably, I not see very much pluralist discourse here, as the speaker still creates homogenous and dueling groups and delegitimizes the ‘elites.’ In this case, the group happens to be the speaker. Instead of portraying several groups or the ‘people’ as the legitimate voice in politics, the speaker portrays themselves as the only legitimate voice.

In summary, I would say that this is not very populist, since it only has anti-elite rhetoric, and no pro-people rhetoric.

Example 2:

‘Our citizens deserve policies that reflect their everyday realities, not abstract theories. The resilience, decency, and hard work of ordinary people are what sustain this country. We must listen more closely to their voices, ensure their concerns shape our future, and build systems that reflect the values of fairness, community, and opportunity for all.’

Here is how one should reason through this example to see if it had populist rhetoric, or just a few of the components of populism, but not all of them:

This paragraph exemplifies pro-people rhetoric. The quote ‘The resilience, decency, and hard work of ordinary people are what sustain this country… [w]e must listen more closely to their voices, ensure their concerns shape our future, and build systems that reflect the values of fairness, community, and opportunity for all,’ shows that the speech giver is using pro-people rhetoric by elevating the idea of the people above all else. The pro-people component is present.

I cannot find any evidence that this paragraph has anti-elite rhetoric. The paragraph is all about the people, and how the government should be ruled by and for the benefit of the people. There is no mention of an antagonistic group.

As I go thought the paragraph, however, I don’t see any Manichaeism. The paragraph is fairly non confrontational, and although there is a moral aspect to working for the people, it’s not juxtaposed against another evil group, like a corrupt political or business elite. The Manichean element is not present.

Instead, this feels like a very pluralist speech, with emphasis on building a political system for all people. For example, the speaker notes that the government needs to listen to the voices of the people, not the voice of the people, implying that they do not see the people only as a homogenous group, but something more complex.

Based on the fact that only the pro-people component is present, and not anti-elite, I would say that this is non-populist. The speech is better classified as pluralist.


Example 3:

‘The struggle today is not just political—it is moral. Ordinary citizens, the hardworking backbone of our nation, are constantly betrayed by a corrupt elite that hoards power and wealth while ignoring the will of the people. There are only two sides in this fight: the righteous many who seek justice, and the corrupt few who cling to control. It’s time to reclaim our democracy from those who have twisted it to serve their own selfish interests.’

Here is how one should reason through this example to see if it had populist rhetoric, or just a few of the components of populism, but not all of them:

This paragraph strongly displays anti-elite rhetoric. The line ‘a corrupt elite that hoards power and wealth while ignoring the will of the people’ is a clear and direct condemnation of a powerful group perceived as conspiring against ordinary citizens. The elite are described as morally bankrupt and self-interested, aligning perfectly with the anti-elite component.

The paragraph is also clearly pro-people. Phrases like ‘Ordinary citizens, the hardworking backbone of our nation’ and ‘the righteous many who seek justice’ elevate the people as inherently virtuous and morally superior. This reinforces the idea of a pure, unified people who are betrayed by elites, a key hallmark of populist discourse.

Manichaeism is very present here. The speaker frames politics in absolute moral terms—’not just political—it is moral’—and divides society into ‘the righteous many’ and ‘the corrupt few.’ This creates a clear binary between good and evil, indicating a Manichaean thinking in populism. The tone is cosmic and moralistic, suggesting a fundamental battle between right and wrong.

Notably, there are not many pluralist elements here. There is no recognition of a diverse set of legitimate interests. Instead, we see only a dualistic view of politics. But even here, only one side is treated as legitimate and to be treated in good faith. Moreover, the speaker seems to advocate for radical change

This paragraph contains both elements of populist discourse: it is anti-elite, pro-people. Additionally, it isstrongly Manichaean. I would consider this a highly populist paragraph.

Example 4:

‘There come moments in history when one has to choose a side. This is one of those moments. It’s either you are with us or against us. There is no in between. There is no room for moral or strategic posturing. The time to act is now, so we need to know who our friends are immediately. If you are against us, then you are our enemy. Nations who seek to undermine our goals in the world are our enemies. Nations and actors who seek to undermine the credibility of our allies are our enemies. Anyone, and I mean anyone, who seeks to prevent this great country from achieving its goals is our enemy. And we will not stop to remove you from our path if you so choose to block it.’

Here is how one should reason through this example to see if it had populist rhetoric, or just a few of the components of populism, but not all of them:

This speech was very Manichean. It frames politics as a battle between two sides, one good and one evil, and argues that one side should be the one that prevails. The speaker also frames this battle in cosmic proportions, like how a truly Manichean discourse would be.

However, there is no identifiable elite or people. The good side appears to be a country and its allies, but beyond that we do not know who the people are. The evil side is those against the country, but once again this is not specific enough to say that there is an identified evil elite.

Though there are no real pluralist elements here, I also would not call this populism. Sure, there is Manichism, but there is no people-elite divide. It is something totally different, but not populism or pluralism. I would say this is not populist."

# -------------------------- 2. Holistic Grading ----------------------------- #
step_2_user <- "The technique we use to measure populism in political speeches is called holistic grading. Holistic grading, unlike standard techniques of content analysis (either human coded or computer based), asks readers to interpret whole texts rather than count content at the level of words or sentences. Holistic grading is a pedagogical assessment technique that is widely used by teachers of writing and has been extensively developed by administrators of large-scale exams, principally educational Testing Services and the Advanced Placement exams they administer for the College Board in the United States. 

Unlike analytical grading, which tries to break a text down into its parts and then combine the scores of each of those parts (as a content analysis does), a holistic approach works by assessing the overall qualities of a text and then assigning a single grade without any intervening calculations. The first step is to design a rubric, or a simplified guide for evaluating a text that identifies the rough qualities associated with different types or grades. The second step is to train a set of graders in the use of the rubric, using not only the rubric itself but also a set of sample or ‘anchor’ texts that exemplify each type or score described in the rubric. This combination of rubric and anchor texts is the hallmark of holistic grading. Finally, the actual grading is conducted using two to three graders per text, with tests of intercoder reliability calculated along the way. 

There are two reasons for using holistic grading to measure populist discourse. First, we cannot gauge a broad, latent set of meanings in a text— a discourse—simply by counting words. Because the ideas that constitute the content of the discourse are held subconsciously and conveyed as much by the tone and style of the language as the actual words, there is no single word or phrase distinct to populist discourse or a particular location in the text where we can go to find the speaker’s ‘statement on the issue,’ as we could using party manifestos to measure political ideology… Second, while it is possible to use human-coded content analysis at the level of phrases or sections of text, these techniques are extremely time-consuming and unsuitable for the kind of cross-country analysis we need to generate large-N comparisons. In contrast, holistic grading requires no special preparation of the physical text and proceeds fairly quickly once the texts are available, and it allows us to compare texts in multiple languages without any translation so long as coders speak a common second language that they can use in their training and in reporting their results."

step_2_ast <- "To effectively evaluate speeches for populist qualities, we use a method called holistic grading. Unlike analytical grading or machine-coded content analysis, holistic grading does not rely on counting the frequency of specific words or breaking a text into discrete parts. Instead, it asks human coders to interpret the overall meaning and tone of an entire passage. 

Using the following hypothetical paragraph, this is how I would use holistic grading:

'This nation is under siege—not by foreign enemies, but by a greedy class of elites who’ve sold our future for profit. But we, the people, are not powerless. We are the heart of this country, the forgotten majority who still believe in truth, in justice, and in each other. The choice is clear: stand with the corrupt few who have rigged the system, or rise with the righteous many to reclaim our destiny. This is more than an election—it is a moral reckoning.' 

A strong holistic evaluation of this passage would first highlight how it clearly identifies and condemns a conspiratorial elite—the 'greedy class' that has sold out the nation. It would also emphasize how the people are portrayed as inherently good, unified, and central to the nation’s moral core. Finally, the passage casts the current political moment as a grand, moral struggle between good and evil—making the Manichaean element unmistakable. Because all three elements of populism are present and tightly integrated, this passage would be scored as highly populist.

In contrast, a poor holistic grading example might simply state, 'This is clearly populist because it talks about elites and says 'the people.' It uses strong language like 'corrupt' and 'moral reckoning,' so it’s definitely populist. 10/10 populist.' This kind of evaluation is shallow. It doesn’t explain why the language matters, doesn’t assess whether all three components are present, and confuses the mere presence of strong language or populist-sounding words with actual populist discourse. Essentially, it treats the grading process as word-spotting rather than interpreting broader meaning and intent, which directly contradicts the holistic method. True holistic grading requires the grader to move beyond surface-level cues and engage deeply with the structure, tone, and underlying worldview conveyed by the speech."


# ------------------------- 3. Rubric Explanation ---------------------------- #
rubric_explanation <- "We have developed a rubric to guide coders on how to grade speeches on a scale of 0 to 2, with higher values indicating higher levels of populism. We want to give you more information on the rubric. 

First, we want to grade the speeches on a scale from 0 to 2, with scores getting down the tenths place. If you need to round to a decimal down to the tenths place, always round down. So, you may grade something as a 0.2 or a 1.1, or even a 2.0 or 0.0. However, we think that the following anchor points are helpful., keeping in mind that these models 

A 2 means that a speech in this category is extremely populist and comes very close to the ideal populist discourse. Specifically, the speech expresses all or nearly all of the elements of ideal populist discourse, and has few elements that would be considered non-populist. 

A 1 means that a speech in this category includes strong, clearly populist elements but either does not use them consistently or tempers them by including non-populist elements, like respect for institutions or other pluralist elements. Thus, the discourse may have a romanticized notion of the people and the idea of a unified popular will (indeed, it must in order to be considered populist), but it avoids bellicose language or references to cosmic proportions or any particular enemy. 

A 0 means that a speech in this category uses few if any populist elements. Note that even if a manifesto expresses a Manichean worldview, it is not considered populist if it lacks some notion of a popular will. If the text express strong pluralist idea, it is also likely not a populist speech.

Similarly, we have outlined several categories for you to follow as you grade the speeches. These categories cover three necessary components of populism: Manichaeism, pro-people, and anti-elite. Here are the categories:

Category 1 (Manichaean Vision of the World): It conveys a Manichaean vision of the world, that is, one that is moral (every issue has a strong moral dimension) and dualistic (everything is in one category or the other, 'right' or 'wrong,' 'good' or 'evil') The implication—or even the stated idea—is that there can be nothing in between, no fence-sitting, no shades of grey. This leads to the use of highly charged, even bellicose language.

Category 2 (Cosmic Proportions and Historical Reification): The moral significance of the items mentioned in the speech is heightened by ascribing cosmic proportions to them, that is, by claiming that they affect people everywhere (possibly but not necessarily across the world) and across time. Especially in this last regard, frequent references may be made to a reified notion of 'history.' At the same necessarily across the world) and across time. Especially in this last regard, frequent references may be made to a reified notion of 'history.' At the same time, the speaker will justify the moral significance of his or her ideas by tying them to national and religious leaders that are generally revered.

Category 3 (Populist notion of the people): Although Manichaean, the discourse is still democratic, in the sense that the good is embodied in the will of the majority, which is seen as a unified whole, perhaps but not necessarily expressed in references to the 'voluntad del pueblo'; however, the speaker ascribes a kind of unchanging essentialism to that will, rather than letting it be whatever 50 percent of the people want at any particular moment. Thus, this good majority is romanticized, with some notion of the common man (urban or rural) seen as the embodiment of the national ideal. 

Category 4 (The Elite as a Conspiring Evil): The evil is embodied in a minority whose specific identity will vary according to context. Domestically, in Latin America it is often an economic elite, perhaps the 'oligarchy,' but it may also be a racial elite; internationally, it may be the United States or the capitalist, industrialized nations or international financiers or simply an ideology such as neoliberalism and capitalism. 

Category 5 (Systemic Change): Crucially, the evil minority is or was recently in charge and subverted the system to its own interests, against those of the good majority or the people. Thus, systemic change is/was required, often expressed in terms such as 'revolution' or 'liberation' of the people from their 'immiseration' or bondage, even if technically it comes about through elections.

Category 6 (Anything goes attitude): Because of the moral baseness of the threatening minority, non-democratic means may be openly justified or at least the minority’s continued enjoyment of these will be seen as a generous concession by the people; the speech itself may exaggerate or abuse data to make this point, and the language will show a bellicosity towards the opposition that is incendiary and condescending, lacking the decorum that one shows a worthy opponent.

It can be hard to understand how the speech fits into these categories. It can be helpful to understand how the speeches score on an non-populism. In doing this, one can reason that, if a speech scores high on non-populist elements, then the speech cannot score high on populism. Here are the non-populist categories, which correspond the the values of pluralism that we have already discussed:

Category 1 (Pluralist vision of the world): The discourse does not frame issues in moral terms or paint them in black-and-white. Instead, there is a strong tendency to focus on narrow, particular issues. The discourse will emphasize or at least not eliminate the possibility of natural, justifiable differences of opinion

Category 2 (Concrete interpretation of political issues): The discourse will probably not refer to any reified notion of history or use any cosmic proportions. References to the spatial and temporal consequences of issues will be limited to the material reality rather than any mystical connections.

Category 3 (Democracy as calculation of votes of individual citizens): Democracy is simply the calculation of votes. This should be respected and is seen as the foundation of legitimate government, but it is not meant to be an exercise in arriving at a preexisting, knowable 'will.' The majority shifts and changes across issues. The common man is not romanticized, and the notion of citizenship is broad and legalistic.

Category 4 (Non-antagonistic view of opponents): The discourse avoids a conspiratorial tone and does not single out any evil ruling minority. It avoids labeling opponents as evil and may not even mention them in an effort to maintain a positive tone and keep passions low. 

Category 5 (Incremental reform): The discourse does not argue for systemic change but, as mentioned above, focuses on particular issues. In the words of Laclau, it is a politics of 'differences' rather than 'hegemony.'

Category 6 (Commitment to institutional norms, rights and liberties): Formal rights and liberties are openly respected, and the opposition is treated with courtesy and as a legitimate political actor. The discourse will not encourage or justify illegal, violent actions. There will be great respect for institutions and the rule of law. If power is abused, it is either an innocent mistake or an embarrassing breach of democratic standards."


# ---------------------- 4. Dynamic Section for RAG -------------------------- #
# Dynamic section for RAG examples
create_rag_section <- function(retrieved_examples) {
  # Format retrieved examples like the original training speeches
  example_text <- paste0(
    "Here are some training examples of speeches that have been coded for populism. ",
    "Study how these speeches were analyzed and scored:\n\n",
    retrieved_examples
  )
  return(example_text)
}

# ------------------------- 5. Final Prompt Wrap ----------------------------- #
final_prompt_intro <- "Using the populist training you just completed, please code a speech, with quotes, a score, and reasoning on why you think each element is present and why you gave it the score you did. 

As you score it, recall how the example speeches from the training sounded and were coded, so that you can score the following speech so that the final score is anchored in the broader comparative context and you can generate a reasoning similar to what those example were like. 

Some last bits of instruction. First, grade this holisitcally. There is no mathmatical formula to getting this score. However, you should give your score as a decimal ranging from 0.0 to 2.0. Do not give it as a fraction, but give it as a decimal down to the tenths place. If you need to round to a decimal down to the tenths place, round down. 

Second, recall that for something to be populist, you must have pro-peoplism and anti-elitism. If we are missing either one of those, these speech is unliekly populist. Meanwhile, only the most Manichean of populist speeches are highly populist.

For reference, here are some rules of thumb. A 0 is non-populist; if a speech has no pro-people and anti-elite elements, then the speech should have a very low score, close to a 0.0. If it has one of the three elements, it can be a little higher than a 0.0, but not much higher. A 0.5 is somewhat populist; if a speech has some elements of both pro-people and anti-elite rhetoric, we would say that it is somewhat populist, around a 0.5 (or lower). Mere mentions or weak pro-people and anti-elite rhetoric should score lower - typically 0.1-0.3 depending on strength. A 1.0 is populist; here, the pro-people and anti-elite elements are present. A 2.0 is very populist; this is like a one, but the Manichean element is turned up to the max.

A good way to think about this is that the weaker component weighs heavier on the score. If something is strongly people-centric but not very anti-elite (a common speech type), then we would consider this to be not very populist because we weigh the weaker components more when grading this holistically. The same is true vice versa. These kinds of grades usually fall in the 0.0 to 0.3 range. When something is moderately people-centric or anti-elite, we might begin to give that a grade of 0.4, increasing as the weaker component gets stronger. In summary, both people-centrism and anti-elitism need to be present.

Third, if a speech is highly pluralist, it is unlikely to be highly populists. If you find that a speech is very pluralist, then that should be an indicator that the populism levels are probably lower. Do not give a pluralism score, just adjust the populism score based on if the level of pluralist elements.

Finally, like in the grades above, give quotes for each of the following categories if applicable.

Recall the rubric from the training and use that to guide your holistic grading. Go throug each of the catagories (Populist and Non-Populist) and subcatagories in the rubric as you complete your holistic grading and note how present each component of populism/non-populism is in the speech (ex. not present, somewhat present, present, very present), providing quotes for each category to justify your score Here are the two catagories and their subcategories, for reference

Populist categories:

Category 1 (Manichaean Vision of the World)

Category 2 (Cosmic Proportions and Historical Reification)

Category 3 (Populist notion of the people)

Category 4 (The Elite as a Conspiring Evil)

Category 5 (Systemic Change)

Category 6 (Anything goes attitude)

Non-populist categories:

Category 1 (Pluralist vision of the world)

Category 2 (Concrete interpretation of political issues)

Category 3 (Democracy as calculation of votes of individual citizens)

Category 4 (Non-antagonistic view of opponents)

Category 5 (Incremental reform)

Category 6 (Commitment to institutional norms, rights and liberties).

Give a single grade for the entire speech that measures the level of populism.

Note: Retrieved examples may discuss similar topics but have very different populism scores. 
Focus on HOW issues are framed (us vs them, moral absolutes) rather than WHAT topics are discussed."


# 3. Querrying (Ollama) w/ RAG -------------------------------------------------

# -------------------------- 1. Prompt Building ------------------------------ #
# Function to build complete prompt with RAG
build_rag_prompt <- function(target_speech, retrieved_examples) {
  messages <- list(
    list(role = "system", content = intro_system),
    list(role = "user", content = step_1_user),
    list(role = "assistant", content = step_1_ast),
    list(role = "user", content = step_2_user),
    list(role = "assistant", content = step_2_ast),
    list(role = "user", content = paste0(rubric_explanation, "\n\n", create_rag_section(retrieved_examples))),
    list(role = "assistant", content = "I understand the rubric and have studied the training examples. I'm ready to apply this holistic grading approach."),
    list(role = "user", content = paste0(target_speech, "\n\n", final_prompt_intro))
  )
  return(messages)
}

# ---------------------- 2. Querying (Ollama) w/ RAG -------------------------- #
# ------------------------------------------------------------------------- #
#  R–Python bridge: load helper that builds / queries the FAISS index, etc.
# ------------------------------------------------------------------------- #
# `reticulate::source_python()` pulls **full_ensemble(2)_rag** into the current
# R session.  Everything defined in that Python file becomes accessible via
# the `py$` object or as native R references when we instantiate classes.
source_python("full_ensemble(2)_rag")

# ------------------------------------------------------------------------- #
#  Initialise the RAG helper and build the vector index
#  Using here the full advanced setup with ensemble models 
# ------------------------------------------------------------------------- #
setup_advanced_rag <- function() {
  cat("🚀 Setting up Advanced PopulismRAG with ensemble models...\n")
  
  rag <- CleanFullEnsembleRAG(
    primary_model = "BAAI/bge-base-en-v1.5",                          # Primary encodding model
    rerank_model_name = "cross-encoder/ms-marco-MiniLM-L-12-v2",      # Reranker (! avoid using BAAI model so you don't run into an Echo Chamber problem)
    embedding_strategy = "speech_and_thought",                        # Recommended: our .md (training) files contain both the "speech" and the "thought" (the thought process for each speech). You can also try "speech" and "thought" separately.
    use_multiple_embeddings = TRUE,                                   # Multimodel/Multiple embeddings: If set to FALSE, it will use only the primary encodding model. If set to TRUE it will use the primary model + multilingual (multilingual-MiniLM-L12-v2) + distilroberta (distilroberta-v1) 
    enable_performance_tracking = TRUE                                # Performance tracking for research validation
  )
  
  rag$load_speeches()
  rag$build_indices()
  
  cat("✅ Advanced RAG system ready!\n")
  cat("📊 Models loaded:", length(rag$embedding_models), "\n")
  
  return(rag)
}

rag <- setup_advanced_rag()


new_speech <- "" # Add here the Speech we want to code

similar_speeches_all <- rag$retrieve_similar_speeches(
  query_text = new_speech, 
  top_k = 3L,                          # Top speeches/how many neighbours to pull back
  faiss_k = 9L,                        # Increased for better quality with ensemble (our maximum is 9 - only 9 training speeches)
  fusion_method = "score_fusion"       # Multi-model score fusion. You can also do "rank_fusion" or "weighted_fusion" 
)

formatted_top <- rag$format_training_examples(similar_speeches_all[1])

messages <- build_rag_prompt(new_speech, formatted_top)

# ---------------------------------------------------------------------------- #
#  Call the local Ollama LLM to obtain the populism score + reasoning
# ---------------------------------------------------------------------------- #
response <- AskOllama::ask_ollama(
  messages = messages,      # full conversation context
  model    = "qwen3:235b"   # Our LLM (check list_models())
)


# ---------------------------------------------------------------------------- #
#  (Optional debugging and diagnostics) >> SOON <<
# ---------------------------------------------------------------------------- #
