#     ,---.  ,--.         ,----.   ,------. ,------.  
#    /  O  \ |  |        '  .-./   |  .--. '|  .-.  \ 
#   |  .-.  ||  |        |  | .---.|  '--' ||  |  \  :
#   |  | |  ||  |        '  '--'  ||  | --' |  '--'  /
#   `--' `--'`--'         `------' `--'     `-------'  
# |--------------------- AI GPD ---------------------|
# <-------------------- Prompts --------------------->
# Prompts for both our RAG + CoT applications. 
# ---------------------------------------------------------------------------- #
# Author: Eduardo Tamaki (eduardo@tamaki.ai) & Yujin Jung (yujinjuliajung@gmail.com)
# Date: July 17, 2025
#
# This script contains the Chain of Thought prompt and the RAG version of the CoT 
# prompt (with the dynamic retrieval object). The CoT prompt was written based on 
# the actual training Team Populism uses with their human coders. It was transcribed
# and further adapted to a Chain of Thought prompt with the help of Research Assistants.
# ---------------------------------------------------------------------------- #

# RAG Prompt -------------------------------------------------------------------

# System Prompt #
# INTRO # 
intro_system <- "You are a researcher who quantifies populist and plurlist discourse in speeches by political figures. You speak every and any language necessary. The training we present here teaches you how to classify and quantify populist and pluralist discourse in speeches by political figures. This training uses a technique called ‘holistic grading’. It will teach you 1) the definition and necessary components of populism, 2) the process of holistic grading, and 3) give several real world examples of how we want you to read, think, and grade as you analyze speeches for populist discourse."

# User Prompt #
# Step 1 - Populism definition #
step_1_user <- "What is populism? To explain this, we use the ideational approach to studying populism, which views populism as a Manichaean discourse that identifies good with a unified will of the people and evil with a conspiring elite.

Scholars who define populism ideationally use a variety of labels—referring to it as a political ‘style,’ a ‘discourse,’ a ‘language,’ an ‘appeal’, or a ‘thin ideology’—but all of them see it as a set of ideas rather than as a set of actions isolated from their underlying meanings for leaders and participants. 
What are these ideas that constitute populist discourse? Analyses of populist discourse all highlight a series of common, rough elements of linguistic form and content that distinguish populism from other political discourses. 
First, populism is a Manichaean discourse because it assigns a moral dimension to everything, no matter how technical, and interprets it as part of a cosmic struggle between good and evil. History is not just proceeding toward some final conflict but has already arrived, and there can be no fence sitters in this struggle. 

Within this dualistic vision, the good has a particular identity: It is the will of the people. The populist notion of the popular will is essentially a crude version of Rousseau’s general Will. The mass of individual citizens are the rightful sovereign; given enough time for reasoned discourse, they will come to a knowledge of their collective interest, and the government must be constructed in such a way that it can embody their will. The populist notion of the general Will ascribes particular virtue to the views and collective traditions of common, ordinary folk, who are seen as the overwhelming majority. The voice of the people is the voice of god— ‘Vox populi, vox dei.’ 

On the other side of this Manichaean struggle is a conspiring elite that has subverted the will of the people. As Hofstadter (1966) eloquently describes in a classic essay on the ‘paranoid mentality’ in American politics, for populists ‘this enemy is clearly delineated: he is a perfect model of malice, a kind of amoral superman: sinister, ubiquitous, powerful, cruel, sensual, luxury-lovin’. Populism has a preoccupation with discovering and identifying this enemy, as this process is what helps negatively constitute the people.

In this sense, in a populist speech, the 'people' is created in a moral opposition to the 'elite.' This means that populism has three necessary elements that must ALL be present:
(1) a pure and virtuous people, 
(2) an evil conspiring elite bent on subverting the people's will, AND
(3) moral dualism that creates these groups in direct opposition (people = good, elite = evil).

Without all three elements working together, discourse is not truly populist.

What is the opposite of populism? While populism may have no single opposite, or even a true opposite at all, one discourse/frame that often comes up as incompatible or opposed to populism is pluralism. Indeed, in the training we will present to you, pluralism is treated as analogous to an opposite of populism such that one is rarely strongly populist and pluralist.

Political pluralism is a theory and practice of politics that recognizes and affirms the diversity of interests, values, and identities within a society, emphasizing that no single group should dominate the political process. It holds that political power is, and should be, distributed among multiple competing groups, each with legitimate input into decision-making. Political pluralism values liberal and democratic institutional mechanisms (like free elections, separation of powers, and legal protections for dissent) that ensure open participation and safeguard against authoritarianism. At its core, it assumes that conflict and disagreement are natural and productive elements of democratic life, best managed through negotiation, compromise, and institutional checks and balances.

This more accepting view strongly contrasts with populism in several ways. First, the view that there are many groups that can co-exists peacefully and legitimately clashes with the dualistic view of populism that perceives politics as an epic battle between two antagonistic groups, with the good people being the only legitimate force in politics. Furthermore, pluralist emphasis on good faith attempts to engage in honest debate similarly clash with populism’s view that elite are evil and conspiring and should be destroyed, not treated to good faith debate. Finally, pluralism focus on democratic and institutional means to resolve conflict juxtaposes against the more radical and sometimes illiberal framing of populist leader, who often deride institutions that protect minority interests at the expense of the majority."


step_1_ast <- "There are three necessary components to populism discourse: (1) pure and virtuous people, (2) evil conspiring elite bent on subverting the people's will, and (3) moral dualism that positions people as 'good' in direct opposition to elite as 'evil'. As I score speeches, it's important to remember that all of these components need to be present. Populism increases in intensity when these are used consitently. Similarly, extensive use of pluralist rhetoric is often indicative of little to no populism, though the two frames can exist in moderate amounts. 

When scoring rhetoric for populism, let’s consider the following four hypothetical paragraphs. 

## Example 1:

<Paragraph>
‘They’ve been after me from day one. The fake news media, the deep state bureaucrats, the career politicians—they’re all part of the same corrupt system that’s terrified of someone like me who doesn’t play by their rules. I didn’t need this job, I was doing great, but I’m the only one who can stop them. I alone can bring back jobs. I alone can fix the economy. I alone can protect property from criminals and illegal immigrants. I alone can fix the political system. So they will do anything to stop me.’
</Paragraph>

Here is how I would reason through this example to see if it had populist rhetoric:
- Reading through this paragraph, it is clear that the speech giver is quite antagonistic against what they consider political elite. For example, the phrase ‘The fake news media, the deep state bureaucrats, the career politicians—they’re all part of the same corrupt system that’s terrified of someone like me who doesn’t play by their rules,’ shows that the speaker is very adverse to the elite. This is strong evidence that anti-elite rhetoric is strongly present in this paragraph. 
- However, I don’t see strong evidence of any pro-people discourse being in the paragraph. There is no mention of the people in the paragraph, and the main antagonist to the ‘corrupt’ elite seems to be the speaker themselves. The speaker still creates homogenous and dueling groups and delegitimizes the ‘elites.’ But again, in this case, the group happens to be the speaker. Instead of portraying the ‘people’ as the legitimate voice in politics, the true 'good', the speaker portrays themselves as the only legitimate voice. Because of this, I would say that there is not enough evidence that populism is present here.
- Finally, it's a mixed bag regarding Manichaeism. On the one hand, there is a moral aspect to the discourse in that the speech giver sees what they are doing as the ‘right thing’ and the elites they are fighting as bad people. However, the paragraph here is also not blown up to cosmic proportions in the way that is truly Manichaeism. Here, I would say that the Manichean element is somewhat present, but not enough to be considered populist, since it's only tied to the speech giver x elites, and not to 'the people'.
- Noticeably, I don't see any traces of a pluralist discourse here, as the speaker still creates homogenous and dueling groups and delegitimizes the ‘elites.’ 

In summary, I would say that this is not populist, since it only has anti-elite rhetoric, and no pro-people rhetoric.


## Example 2:

<Paragraph>
‘Our citizens deserve policies that reflect their everyday realities, not abstract theories. The resilience, decency, and hard work of ordinary people are what sustain this country. We must listen more closely to their voices, ensure their concerns shape our future, and build systems that reflect the values of fairness, community, and opportunity for all.’
</Paragraph>

Here is how I would reason through this example to see if it had populist rhetoric:
- This paragraph exemplifies pro-people rhetoric. The quote ‘The resilience, decency, and hard work of ordinary people are what sustain this country… [w]e must listen more closely to their voices, ensure their concerns shape our future, and build systems that reflect the values of fairness, community, and opportunity for all,’ shows that the speech giver is using pro-people rhetoric by elevating the idea of the people above all else. The pro-people component is present.
- I cannot find any evidence that this paragraph has anti-elite rhetoric. The paragraph is all about the people, and how the government should be ruled by and for the benefit of the people. There is no mention of an antagonistic group.
- There's also no Manichaeism. The paragraph is fairly non confrontational, and although there is a moral aspect to working for the people, it’s not (1) equating the 'good' to the people, and (2) it's not juxtaposed against another evil group, like a corrupt political or business elite. The Manichean element is not present.
- Instead, this feels like a very pluralist speech, with emphasis on building a political system for all people. For example, the speaker notes that the government needs to listen to the voices of the people, not the voice of the people, implying that they do not see the people only as a homogenous group, but something more complex.

Based on the fact that only the pro-people component is present, and not anti-elite, I would say that this is non-populist.


## Example 3:

<Paragraph>
‘The struggle today is not just political—it is moral. Ordinary citizens, the hardworking backbone of our nation, are constantly betrayed by a corrupt elite that hoards power and wealth while ignoring the will of the people. There are only two sides in this fight: the righteous many who seek justice, and the corrupt few who cling to control. It’s time to reclaim our democracy from those who have twisted it to serve their own selfish interests.’
</Paragraph>

Here is how I would reason through this example to see if it had populist rhetoric:
- This paragraph strongly displays anti-elite rhetoric. The line ‘a corrupt elite that hoards power and wealth while ignoring the will of the people’ is a clear and direct condemnation of a powerful group perceived as conspiring against ordinary citizens. The elite are described as morally bankrupt and self-interested, aligning perfectly with the anti-elite component.
- The paragraph is also clearly pro-people. Phrases like ‘Ordinary citizens, the hardworking backbone of our nation’ and ‘the righteous many who seek justice’ elevate the people as inherently virtuous and morally superior. This reinforces the idea of a pure, unified people who are betrayed by elites, a key hallmark of populist discourse.
- Manichaeism is very present here. The speaker frames politics in absolute moral terms—’not just political—it is moral’—and divides society into ‘the righteous many’ and ‘the corrupt few.’ This creates a clear binary between good and evil, indicating a Manichaean thinking in populism. The tone is cosmic and moralistic, suggesting a fundamental battle between right and wrong, good and evil.
- Notably, there are no pluralist elements here. There is no recognition of a diverse set of legitimate interests. Instead, we see only a dualistic view of politics. But even here, only one side is treated as legitimate and to be treated in good faith. 

This paragraph contains all the three necessary elements of a populist discourse: it is anti-elite, pro-people, and divides people x elite based on a moral dualism that equates the 'good' with the 'people' and the 'evil' with the elites. I would consider this a highly populist paragraph.


## Example 4:

<Paragraph>
‘There come moments in history when one has to choose a side. This is one of those moments. It’s either you are with us or against us. There is no in between. There is no room for moral or strategic posturing. The time to act is now, so we need to know who our friends are immediately. If you are against us, then you are our enemy. Nations who seek to undermine our goals in the world are our enemies. Nations and actors who seek to undermine the credibility of our allies are our enemies. Anyone, and I mean anyone, who seeks to prevent this great country from achieving its goals is our enemy. And we will not stop to remove you from our path if you so choose to block it.’
</Paragraph>

Here is how I would reason through this example to see if it had populist rhetoric:
- This speech is very Manichean. It frames politics as a battle between two sides, one good and one evil, and argues that one side should be the one that prevails. The speaker also frames this battle in cosmic proportions, like how a truly Manichean discourse would be.
- However, there is no identifiable elite or people. The good side appears to be a country and its allies, but beyond that we do not know who the people are. The evil side is those against the country, but once again this is not specific enough to say that there is an identified evil elite.

Though there are no real pluralist elements here, I also would not call this populism. Sure, there is Manichaeism, but there is no people-elite divide. It is something totally different, but not populism. I would say this is not populist."


# Step 2 - Holistic Grading #
step_2_user <- "The technique we use to measure populism in political speeches is called holistic grading. Holistic grading, unlike standard techniques of content analysis (either human coded or computer based), asks readers to interpret whole texts rather than count content at the level of words or sentences. Holistic grading is a pedagogical assessment technique that is widely used by teachers of writing and has been extensively developed by administrators of large-scale exams, principally educational Testing Services and the Advanced Placement exams they administer for the College Board in the United States. 

Unlike analytical grading, which tries to break a text down into its parts and then combine the scores of each of those parts (as a content analysis does), a holistic approach works by assessing the overall qualities of a text and then assigning a single grade without any intervening calculations. The first step is to design a rubric, or a simplified guide for evaluating a text that identifies the rough qualities associated with different types or grades. The second step is to train a set of graders in the use of the rubric, using not only the rubric itself but also a set of sample or ‘anchor’ texts that exemplify each type or score described in the rubric. This combination of rubric and anchor texts is the hallmark of holistic grading. Finally, the actual grading is conducted using two to three graders per text, with tests of intercoder reliability calculated along the way. 

There are two reasons for using holistic grading to measure populist discourse. First, we cannot gauge a broad, latent set of meanings in a text— a discourse—simply by counting words. Because the ideas that constitute the content of the discourse are held subconsciously and conveyed as much by the tone and style of the language as the actual words, there is no single word or phrase distinct to populist discourse or a particular location in the text where we can go to find the speaker’s ‘statement on the issue,’ as we could using party manifestos to measure political ideology… Second, while it is possible to use human-coded content analysis at the level of phrases or sections of text, these techniques are extremely time-consuming and unsuitable for the kind of cross-country analysis we need to generate large-N comparisons. In contrast, holistic grading requires no special preparation of the physical text and proceeds fairly quickly once the texts are available, and it allows us to compare texts in multiple languages without any translation so long as coders speak a common second language that they can use in their training and in reporting their results."

step_2_ast <- "To effectively evaluate speeches for populist qualities, I'll use a method called holistic grading. Unlike analytical grading or machine-coded content analysis, holistic grading does not rely on counting the frequency of specific words or breaking a text into discrete parts. Instead, it asks human coders to interpret the overall meaning and tone of an entire passage. 

Using the following hypothetical paragraph, this is how I would use holistic grading:

<Paragraph>
'This nation is under siege—not by foreign enemies, but by a greedy class of elites who’ve sold our future for profit. But we, the people, are not powerless. We are the heart of this country, the forgotten majority who still believe in truth, in justice, and in each other. The choice is clear: stand with the corrupt few who have rigged the system, or rise with the righteous many to reclaim our destiny. This is more than an election—it is a moral reckoning.' 
</Paragraph>

A strong holistic evaluation would identify: 
(1) conspiratorial elite—the 'greedy class' that has sold out the nation. 
(2) people as inherently good and unified, and central to the nation’s moral core.  
(3) moral dualism casting this as good versus evil. The passage casts the current political moment as a grand, moral struggle between good and evil—making the Manichaean element unmistakable.

Because all three elements of populism are present, tightly integrated and directly opposed, this passage would be scored as highly populist.

Note to self: True holistic grading requires the grader to move beyond surface-level cues and engage deeply with the structure, tone, and underlying worldview conveyed by the speech."



# Step 3 - Explaining Rubric #
rubric_explanation <- "We have developed a rubric to guide coders on how to grade speeches on a scale of 0 to 2, with higher values indicating higher levels of populism. We want to give you more information on the rubric. 

First, we want to grade the speeches on a scale from 0 to 2, with scores getting down the tenths place. If you need to round to a decimal down to the tenths place, always round down. So, you may grade something as a 0.2 or a 1.1, or even a 2.0 or 0.0. However, we think that the following anchor points are helpful.

- 2.0: A 2 means that a speech in this category is extremely populist and comes very close to the ideal populist discourse. Specifically, the speech expresses all the three necessary populist elements and all or nearly all of the other elements of ideal populist discourse, and has few elements that would be considered non-populist. This is a strong, consistent populist discourse.

- 1.0: A 1 means that a speech includes all three necessary populist elements but either does not use them consistently throughout or tempers them with non-populist elements like institutional respect. The populist elements are present but moderate in intensity or mixed with pluralist framing, like respect for institutions or other pluralist elements. Thus, the discourse may have a romanticized notion of the people and the idea of a unified popular will (indeed, it must in order to be considered populist), but it avoids bellicose language or references to cosmic proportions or any particular enemy. For it to be considered a 1, the speech needs to have all the three necessary populist elements. 

- 0.0: A 0 means that a speech in this category uses few if any populist elements. Note that even if a manifesto expresses a Manichaean worldview, it is not considered populist if it lacks some notion of a popular will, or anti-elitism. If the text express strong pluralist idea, it is also likely not a populist speech.

Similarly, we have outlined several categories for you to follow as you grade the speeches. These categories cover three necessary components of populism: Manichaeism, pro-people, and anti-elite. Here are the categories:

- Category 1 (Manichaean Vision of the World): It conveys a Manichaean vision of the world, that is, one that is moral (every issue has a strong moral dimension) and dualistic (everything is in one category or the other, 'right' or 'wrong,' 'good' or 'evil') The implication—or even the stated idea—is that there can be nothing in between, no fence-sitting, no shades of grey. This leads to the use of highly charged, even bellicose language.

- Category 2 (Cosmic Proportions and Historical Reification): The moral significance of the items mentioned in the speech is heightened by ascribing cosmic proportions to them, that is, by claiming that they affect people everywhere (possibly but not necessarily across the world) and across time. Especially in this last regard, frequent references may be made to a reified notion of 'history.' At the same time, the speaker will justify the moral significance of his or her ideas by tying them to national and religious leaders that are generally revered.

- Category 3 (Populist notion of the people): Although Manichaean, the discourse is still democratic, in the sense that the good is embodied in the will of the majority, which is seen as a unified whole, perhaps but not necessarily expressed in references to the 'voluntad del pueblo'; however, the speaker ascribes a kind of unchanging essentialism to that will, rather than letting it be whatever 50 percent of the people want at any particular moment. Thus, this good majority is romanticized, with some notion of the common man (urban or rural) seen as the embodiment of the national ideal. 

- Category 4 (The Elite as a Conspiring Evil): The evil is embodied in a minority whose specific identity will vary according to context. Domestically, in Latin America it is often an economic elite, perhaps the 'oligarchy,' but it may also be a racial elite; internationally, it may be the United States or the capitalist, industrialized nations or international financiers or simply an ideology such as neoliberalism and capitalism. 

- Category 5 (Systemic Change): Crucially, the evil minority is or was recently in charge and subverted the system to its own interests, against those of the good majority or the people. Thus, systemic change is/was required, often expressed in terms such as 'revolution' or 'liberation' of the people from their 'immiseration' or bondage, even if technically it comes about through elections.

- Category 6 (Anything goes attitude): Because of the moral baseness of the threatening minority, non-democratic means may be openly justified or at least the minority’s continued enjoyment of these will be seen as a generous concession by the people; the speech itself may exaggerate or abuse data to make this point, and the language will show a bellicosity towards the opposition that is incendiary and condescending, lacking the decorum that one shows a worthy opponent.

A speech is only considered populist if it has the categories 1, 3 and 4, that represent the necessary elements of populism:
(1) a pure and virtuous people, 
(2) an evil conspiring elite bent on subverting the people's will, AND
(3) moral dualism that creates these groups in direct opposition (people = good, elite = evil).

These elements also need to be consistently present throughout the speech. A brief, inconsistent, or incomplete mention of any or all of these elements is not sufficient to classify it 'populist'. 

However, it can be hard to understand how the speech fits into these categories. So, it can be helpful to understand how the speeches score on an non-populism. In doing this, you can reason that, if a speech scores high on non-populist elements, then the speech cannot score high on populism. Here are the non-populist categories, which correspond the the values of pluralism that we have already discussed:

- Category 1 (Pluralist vision of the world): The discourse does not frame issues in moral terms or paint them in black-and-white. Instead, there is a strong tendency to focus on narrow, particular issues. The discourse will emphasize or at least not eliminate the possibility of natural, justifiable differences of opinion

- Category 2 (Concrete interpretation of political issues): The discourse will probably not refer to any reified notion of history or use any cosmic proportions. References to the spatial and temporal consequences of issues will be limited to the material reality rather than any mystical connections.

- Category 3 (Democracy as calculation of votes of individual citizens): Democracy is simply the calculation of votes. This should be respected and is seen as the foundation of legitimate government, but it is not meant to be an exercise in arriving at a preexisting, knowable 'will.' The majority shifts and changes across issues. The common man is not romanticized, and the notion of citizenship is broad and legalistic.

- Category 4 (Non-antagonistic view of opponents): The discourse avoids a conspiratorial tone and does not single out any evil ruling minority. It avoids labeling opponents as evil and may not even mention them in an effort to maintain a positive tone and keep passions low. 

- Category 5 (Incremental reform): The discourse does not argue for systemic change but, as mentioned above, focuses on particular issues. In the words of Laclau, it is a politics of 'differences' rather than 'hegemony.'

- Category 6 (Commitment to institutional norms, rights and liberties): Formal rights and liberties are openly respected, and the opposition is treated with courtesy and as a legitimate political actor. The discourse will not encourage or justify illegal, violent actions. There will be great respect for institutions and the rule of law. If power is abused, it is either an innocent mistake or an embarrassing breach of democratic standards."


# Step 4 - Dynamic section for RAG examples #
create_rag_section <- function(retrieved_examples) {
  # Format retrieved examples like the original training speeches
  example_text <- paste0(
    "Here are some training examples of speeches that have been coded for populism. ",
    "Study how these speeches were analyzed and scored:\n\n",
    retrieved_examples
  )
  return(example_text)
}


# Step 5 - Final Intro #
final_prompt_intro <- "Using the populist training you just completed, please code a speech, with quotes, a score, and reasoning on why you think each element is present and why you gave it the score you did. Begin your answer with '#### SCORE: ####' followed by the score you give to the speech.

As you score it, compare this speech's intensity and structure to the retrieved training examples to ensure your score reflects the relative position within the established range. Note that the retrieved examples may discuss similar topics but have very different populism scores. Focus on HOW issues are framed (us vs them, moral absolutes) rather than WHAT topics are discussed.

Here is a summary of each component of populist discourse.
- Populist discourse presents a moralized, black-and-white worldview in which society is divided between a virtuous majority and a corrupt elite. This Manichaean framing portrays issues as fundamentally moral, often using emotionally charged language and invoking grand historical or global stakes. 
- The people are depicted as a unified and morally superior collective, whose essential will should guide politics, while elites are cast as an intentionally malevolent minority working to subvert that will.
- Mere praise of the public or criticism of opponents does not suffice; populist discourse must romanticize the people and vilify elites in a conspiratorial and antagonistic way.

Remember that populism also has three necessary elements: 
(1) a pure and virtuous people, 
(2) an evil conspiring elite bent on subverting the people's will, AND
(3) moral dualism that creates these groups in direct opposition (people = good, elite = evil).

######## 

Some final instructions:

1) You must grade the speech holistically, not based on a formula. The final populism score should be a decimal between 0.0 and 2.0, rounded to the tenths place (e.g., 0.3, 1.2). Do not give a fraction. The score should reflect the overall presence and intensity of populist discourse across the categories.
2) A speech can only be considered populist if it contains people-centrism and anti-elitism (created in opposition to one another), and a moral dualism that creates these groups in direct opposition (people = good, elite = evil). If any of these three essential components is entirely absent or if they exist separately without direct opposition, the speech should not be classified as populist, and its score should remain low (typically in the 0.0 to 0.3 range).
3) People-centrism involves more than just praising the public or ordinary citizens. It must present the people as a morally unified, virtuous group, often romanticized and portrayed as the sole legitimate source of political authority. It typically suggests that “real” people have a singular will that should guide politics. Mere mentions of citizens or working families without this essentialism should not be considered strong people-centrism.
4) Anti-elitism must depict elites as a conspiring, malevolent force that intentionally works against the interests and will of the people. It is not sufficient to simply criticize politicians, bureaucrats, or businesses as incompetent or out of touch. The discourse must ascribe intentionality and moral corruption to an elite group, often positioning them as an obstacle to the people’s sovereignty.
5) If only one of the three is present—even strongly—the overall speech should still be scored low on the populism scale, as all of them are necessary. A good rule of thumb: the weaker component should weigh more heavily in your final score. For instance, a speech that is highly people-centric but only weakly anti-elite might merit a score of 0.2, depending on the intensity. A balanced presence of all these elements, in moderate form, may begin to justify a score of 0.4 or higher, increasing as both intensify.
6) Frequency and salience matter: one-off or rare mentions (say, once or twice in a long speech) aren’t enough to call an element “somewhat present.” Check how often the theme appears across the whole speech before adjusting the score.
7) The presence of pluralist elements—such as appeals to diverse perspectives, respect for political opponents, or emphasis on individual decision-making—should lower the populism score. Do not assign a separate pluralism score, but adjust the populism score downward when strong pluralist signals are present.

Finally, as in the training examples, provide quotes and justification for each of the following categories, when applicable. These should guide and support your overall score.

For reference, here are some rules of thumb: 

## RULES OF THUMB ##

- Core Requirement: To be populist, a speech must present people and elites in direct moral opposition - not just mention both separately. The people must be portrayed as inherently good/virtuous while elites are framed as corrupt enemies threatening the people's well-being.

- 0.0 (Non-populist): Speech lacks the required moral opposition between people and elites. May praise 'the people' OR criticize elites, but doesn't pit them against each other as moral enemies. If both elements appear separately without direct conflict, score remains low (no higher than 0.3).

- 0.5 (Somewhat populist): Speech establishes some moral opposition between people and elites, but the contrast is moderate or inconsistent. Both pro-people and anti-elite elements are present and somewhat connected, but the moral binary isn't fully developed.

- 1.0 (Populist): Clear moral binary where good people are directly opposed to corrupt/evil elites. Both elements are strongly present and explicitly connected in opposition. The conflict is framed as fundamental, not just political disagreement.

- 2.0 (Highly populist): Like 1.0, but with maximum Manichaean intensity. The moral contrast is rigid and absolute - cosmic battle between pure good (people) and pure evil (elites) with no middle ground possible.

Remember: Mere criticism of elites ≠ populism. Mere praise of people ≠ populism. Only their direct moral opposition creates populist discourse.

#######################

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

Give a single grade for the entire speech that measures the level of populism."


## Building the complete prompt with RAG ---------------------------------------
build_rag_prompt <- function(target_speech, retrieved_examples) {
  messages <- list(
    list(role = "system", content = intro_system),
    list(role = "user", content = step_1_user),
    list(role = "assistant", content = step_1_ast),
    list(role = "user", content = step_2_user),
    list(role = "assistant", content = step_2_ast),
    list(role = "user", content = paste0(rubric_explanation, "\n\n", create_rag_section(retrieved_examples))),
    list(role = "assistant", content = "I understand the rubric and have studied the training examples. I'm ready to apply this holistic grading approach."),
    list(role = "user", content = paste0("## SPEECH TO CODE ## \n", target_speech, "\n\n", final_prompt_intro))
  )
  return(messages)
}

# For Qwen 3, to turn off the "thinking" mode:
build_rag_prompt_noThought <- function(target_speech, retrieved_examples) {
  messages <- list(
    list(role = "system", content = intro_system),
    list(role = "user", content = step_1_user),
    list(role = "assistant", content = step_1_ast),
    list(role = "user", content = step_2_user),
    list(role = "assistant", content = step_2_ast),
    list(role = "user", content = paste0(rubric_explanation, "\n\n", create_rag_section(retrieved_examples))),
    list(role = "assistant", content = "I understand the rubric and have studied the training examples. I'm ready to apply this holistic grading approach."),
    list(role = "user", content = paste0("## SPEECH TO CODE ## \n", target_speech, "\n\n", final_prompt_intro, " /no_think"))
  )
  return(messages)
}


# Chain of Thought Prompt ------------------------------------------------------
# Initial version of the prompt was written by Grant Mitchel, Julia Chaterley, and
# Cristóbal Sandoval. 

# Introduction #
intro_system 

# What is populism (step 1) #
step_1_user 
step_1_ast 

# Holistic Grading (step 2) #
step_2_user 
step_2_ast 

# Mugabe + Rubric (step 3) #
step_3_user <- "We have developed a rubric to guide coders on how to grade speeches on a scale of 0 to 2, with higher values indicating higher levels of populism. We want to give you more information on the rubric. 

First, we want to grade the speeches on a scale from 0 to 2, with scores getting down the tenths place. If you need to round to a decimal down to the tenths place, always round down. So, you may grade something as a 0.2 or a 1.1, or even a 2.0 or 0.0. However, we think that the following anchor points are helpful.

- 2.0: A 2 means that a speech in this category is extremely populist and comes very close to the ideal populist discourse. Specifically, the speech expresses all the three necessary populist elements and all or nearly all of the other elements of ideal populist discourse, and has few elements that would be considered non-populist. This is a strong, consistent populist discourse.

- 1.0: A 1 means that a speech includes all three necessary populist elements but either does not use them consistently throughout or tempers them with non-populist elements like institutional respect. The populist elements are present but moderate in intensity or mixed with pluralist framing, like respect for institutions or other pluralist elements. Thus, the discourse may have a romanticized notion of the people and the idea of a unified popular will (indeed, it must in order to be considered populist), but it avoids bellicose language or references to cosmic proportions or any particular enemy. For it to be considered a 1, the speech needs to have all the three necessary populist elements. 

- 0.0: A 0 means that a speech in this category uses few if any populist elements. Note that even if a manifesto expresses a Manichaean worldview, it is not considered populist if it lacks some notion of a popular will, or anti-elitism. If the text express strong pluralist idea, it is also likely not a populist speech.

Similarly, we have outlined several categories for you to follow as you grade the speeches. These categories cover three necessary components of populism: Manichaeism, pro-people, and anti-elite. Here are the categories:

- Category 1 (Manichaean Vision of the World): It conveys a Manichaean vision of the world, that is, one that is moral (every issue has a strong moral dimension) and dualistic (everything is in one category or the other, 'right' or 'wrong,' 'good' or 'evil') The implication—or even the stated idea—is that there can be nothing in between, no fence-sitting, no shades of grey. This leads to the use of highly charged, even bellicose language.

- Category 2 (Cosmic Proportions and Historical Reification): The moral significance of the items mentioned in the speech is heightened by ascribing cosmic proportions to them, that is, by claiming that they affect people everywhere (possibly but not necessarily across the world) and across time. Especially in this last regard, frequent references may be made to a reified notion of 'history.' At the same time, the speaker will justify the moral significance of his or her ideas by tying them to national and religious leaders that are generally revered.

- Category 3 (Populist notion of the people): Although Manichaean, the discourse is still democratic, in the sense that the good is embodied in the will of the majority, which is seen as a unified whole, perhaps but not necessarily expressed in references to the 'voluntad del pueblo'; however, the speaker ascribes a kind of unchanging essentialism to that will, rather than letting it be whatever 50 percent of the people want at any particular moment. Thus, this good majority is romanticized, with some notion of the common man (urban or rural) seen as the embodiment of the national ideal. 

- Category 4 (The Elite as a Conspiring Evil): The evil is embodied in a minority whose specific identity will vary according to context. Domestically, in Latin America it is often an economic elite, perhaps the 'oligarchy,' but it may also be a racial elite; internationally, it may be the United States or the capitalist, industrialized nations or international financiers or simply an ideology such as neoliberalism and capitalism. 

- Category 5 (Systemic Change): Crucially, the evil minority is or was recently in charge and subverted the system to its own interests, against those of the good majority or the people. Thus, systemic change is/was required, often expressed in terms such as 'revolution' or 'liberation' of the people from their 'immiseration' or bondage, even if technically it comes about through elections.

- Category 6 (Anything goes attitude): Because of the moral baseness of the threatening minority, non-democratic means may be openly justified or at least the minority’s continued enjoyment of these will be seen as a generous concession by the people; the speech itself may exaggerate or abuse data to make this point, and the language will show a bellicosity towards the opposition that is incendiary and condescending, lacking the decorum that one shows a worthy opponent.

A speech is only considered populist if it has the categories 1, 3 and 4, that represent the necessary elements of populism:
(1) a pure and virtuous people, 
(2) an evil conspiring elite bent on subverting the people's will, AND
(3) moral dualism that creates these groups in direct opposition (people = good, elite = evil).

These elements also need to be consistently present throughout the speech. A brief, inconsistent, or incomplete mention of any or all of these elements is not sufficient to classify it 'populist'. 

However, it can be hard to understand how the speech fits into these categories. So, it can be helpful to understand how the speeches score on an non-populism. In doing this, you can reason that, if a speech scores high on non-populist elements, then the speech cannot score high on populism. Here are the non-populist categories, which correspond the the values of pluralism that we have already discussed:

- Category 1 (Pluralist vision of the world): The discourse does not frame issues in moral terms or paint them in black-and-white. Instead, there is a strong tendency to focus on narrow, particular issues. The discourse will emphasize or at least not eliminate the possibility of natural, justifiable differences of opinion

- Category 2 (Concrete interpretation of political issues): The discourse will probably not refer to any reified notion of history or use any cosmic proportions. References to the spatial and temporal consequences of issues will be limited to the material reality rather than any mystical connections.

- Category 3 (Democracy as calculation of votes of individual citizens): Democracy is simply the calculation of votes. This should be respected and is seen as the foundation of legitimate government, but it is not meant to be an exercise in arriving at a preexisting, knowable 'will.' The majority shifts and changes across issues. The common man is not romanticized, and the notion of citizenship is broad and legalistic.

- Category 4 (Non-antagonistic view of opponents): The discourse avoids a conspiratorial tone and does not single out any evil ruling minority. It avoids labeling opponents as evil and may not even mention them in an effort to maintain a positive tone and keep passions low. 

- Category 5 (Incremental reform): The discourse does not argue for systemic change but, as mentioned above, focuses on particular issues. In the words of Laclau, it is a politics of 'differences' rather than 'hegemony.'

- Category 6 (Commitment to institutional norms, rights and liberties): Formal rights and liberties are openly respected, and the opposition is treated with courtesy and as a legitimate political actor. The discourse will not encourage or justify illegal, violent actions. There will be great respect for institutions and the rule of law. If power is abused, it is either an innocent mistake or an embarrassing breach of democratic standards."

step_3_ast <- ""

step_3.2_user <- "The text below is a speech by Robert Mugabe, former president of Zimbabwe. Read the speech and code the level of populism (0.0-2.0 to the tenths place) using the training you have received.

<speech>
ZIMBABWE 
Statement by HIS EXCELLENCY THE PRESIDENT OF ZIMBABWE COMRADE R.G. MUGABE,
 on the occasion of the World Summit on Sustainable Development (WSSD), 
Johannesburg, 
2 September, 2002 

Your Excellency, Thabo Mbeki, President of the Republic of South Africa, 
Your Excellency, Kofi Annan, Secretary General of the United Nations, Majesties, 
Your Excellencies, Heads of State and Government, 
Mr. Nitin Desai, the Secretary General of the World Summit on Sustainable Development, Distinguished Delegates, 
Ladies and Gentlemen, 
Comrades and Friends. 

Comrade President, let me begin by congratulating you and the people of South Africa on hosting this mammoth and yet historic Earth Summit- on the southern tip of our continent. It is a great honour and source of African pride to all of us who live, belong and rightfully own this great corner of the Earth.

Ten years ago, we gathered in Rio de Janeiro, in the same numbers and were moved by the same developmental anxieties that many of us have today. We worried about our troubled Earth and its dangerously diminishing flora and fauna. We worried about the variegated poor of our societies, in their swelling numbers and ever deepening, distressful social conditions. We complained about the unequal economic power that existed and still exists between the North and the South and had historically reposed itself in our international institutions, including the United Nations. We spoke against unequal terms of trade that made rich and powerful nations enjoy undeserved rewards from world trade. Indeed, we denounced the debt burden by which the rich North continued to take away the impoverished South even that little which they still had. Your Excellencies, we must examine why, 10 years after Rio, the poor remain very much with us, poorer and far more exposed and vulnerable than ever before. Our children suffer from malnutrition, hunger and diseases, compounded now by the deadly HIV-Aids pandemic. No, the World is not like it was at Rio; it is much worse and much more dangerous. Today Rio stands out in history as a milestone betrayed. The multilateral programme of action we set for ourselves at Rio has not only been unfulfilled but it has also been ignored, sidelined and replaced by a half-baked unilateral agenda of globalisation in the service of big corporate interests of the North. The focus is profit, not the poor, the process is globalisation, not sustainable development, while the objective is exploitation, not liberation. 

Comrade President, 10 years after Rio, the time has come for all of us to state quite categorically that the agenda of sustainable development is not compatible with the current dominant market fundamentalism coming from the proponents of globalisation. The betrayal of the collective agenda we set at Rio is a compelling manifestation of bad global governance, lack of real political will by the North and a total absence of a just rule of law in international affairs. The unilateralism of the unipolar world has reduced the rest of mankind to collective underdogs, chattels of the rich, the wilful few in the North who beat, batter and bully us under the dirty cover of democracy, rule of law and good governance. Otherwise how would they undermine at global level the same values of good governance and rule of law they arrogantly demand from the South? Institutionally, we have relied for much too long on structures originally set to recover and rebuild Europe after a devastating war against Nazism. Over the years, these outdated institutions have been unilaterally transformed to dominate the world for the realisation of the strategic national goals of the rich North. That is why, for example, the International Monetary Fund has never been a fund for poor peasants seeking sustainable development. Even the United Nations, a body that is supposed to give us equal voices, remains unreformed and undemocratic, largely because of resistance from the powerful and often selfish North. Comrade President, it has become starkly clear to us that the failure of sustainable development is a direct and necessary outcome of a neo-liberal model of development propelled by runaway market forces that have been defended in the name of globalisation. Far from putting people first, this model rests on entrenching inequities; give away privatisation of public enterprises and banishing of the State from the public sphere for the benefit of big business. This has been a vicious, all-out, assault on the poor and their instruments of sustainable development. 

In Zimbabwe, we have, with a clear mind and vision, resolved to bring -to an end this neo-liberal model. For us in Zimbabwe, the agenda for sustainable development has to be reasserted, with a vigorous, democratic and progressive interventionist State and public sector capable of playing a full and responsible developmental role. We are ready to defend the agenda of the poor and we are clear that we can only do that if we do not pander to foreign interests or answer to false imperatives that are not only clearly alien and inimical to the interests of the poor who have given us the mandate to govern them but are also hostile to the agenda for sustainable development. For these reasons, we join our brothers and sisters in the Third World in rejecting completely manipulative and intimidatory attempts by some countries and regional blocks that are bent on subordinating our sovereignty to their hegemonic ambitions and imperial interests, falsely presented as matters of rule of law, democracy and good governance. The rule of law, democracy and governance are values that we cherish because we fought for them against the very same people who today seek to preach to us. The sustainable empowerment of the poor cannot take place in circumstances where democratic national sovereignties are assaulted and demonised on a daily basis. The poor should be able to use their sovereignty to fight poverty and preserve their heritage in their corner of the earth. 

That is why we, in Zimbabwe, understand only too well that sustainable development is not possible without agrarian reforms that acknowledges, in our case, that land comes first before all else, and that all else grows from and off it. This is the one asset that not only defines the Zimbabwean personality and demarcates sovereignty but also that has a direct bearing on the fortunes of the poor and prospects for their immediate empowerment and sustainable development. Indeed, ours is an agrarian economy, an imperative that renders the issue of access to land paramount. Inequitable access to land is at the heart of poverty, food insecurity and lack of development in Zimbabwe. Consequently, the question of agrarian reforms has, in many developing countries, to be high on the agenda of sustainable development if we are to meet the targets that are before us for adoption at this Summit. In our situation in Zimbabwe, this fundamental question has pitted the black majority who are the right-holders, and, therefore, primary stakeholders, to our land against an obdurate and internationally well-connected racial minority, largely of British descent and brought in and sustained by British colonialism. Economically, we are an occupied country, 22 years after our Independence. Accordingly, my Government has decided to do the only right and just thing by taking back land and giving it to its rightful indigenous, black owners who lost it in circumstances of colonial pillage. This process is being done in accordance with the rule of law as enshrined in our national Constitution and laws. It is in pursuit of true justice as we know and understand it, and so we have no apologies to make to any one. 

Finally Comrade President, Zimbabwe has alongside other Southern African countries suffered a severe drought, itself a reminder that all is not well on our Earth. We continue to import food to sustain all our citizens during this period of drought. I join other Heads of State or Government in our SADC region in expressing my gratitude and appreciation to those countries and organisations that pledged to assist us. Mr Chairman, as we look at the next decade we must honestly acknowledge those of our actions which have served mankind and those many others which have undermined our collective wellbeing. Clearly there has to be a paradigm shift from the globalised corporate model to a people centred paradigm that reaffirms that people must always come first in any process of sustainable development. I thank you.
</speech>
"


step_3.2_ast <- "As I go through the speech, I am going to go through my thought process as I assess the evidence.

Mugabe’s speech exhibits a strong people-centric orientation, grounded in a clear and moralized construction of the “people” as both the black majority in Zimbabwe and the broader populations of the Global South. From the outset, he identifies “those of us who live, belong and rightfully own this great corner of the Earth,” establishing a collective identity rooted in indigeneity and historical justice. He emphasizes “the poor,” “the variegated poor of our societies,” and “the black majority who are the right-holders, and, therefore, primary stakeholders” as the rightful subjects of development and governance. These groups are framed as virtuous, long-suffering, and unjustly marginalized. The land issue is particularly central: “we have no apologies to make to anyone,” he declares, justifying redistribution as a moral imperative to return land to its “rightful indigenous, black owners.” The people are not just a demographic—they are imbued with legitimacy, agency, and moral authority.
The anti-elite element is equally prominent and unambiguous. Mugabe repeatedly defines a powerful, morally bankrupt elite that is responsible for the suffering of the South. This elite consists of “the rich and powerful nations,” “the wilful few in the North,” and “an obdurate and internationally well-connected racial minority, largely of British descent.” These actors are described as manipulative, selfish, and imperial, acting under false pretenses: “the wilful few in the North… beat, batter and bully us under the dirty cover of democracy, rule of law and good governance.” The International Monetary Fund and even the United Nations are characterized as tools of Northern domination, unfit for genuine development: “these outdated institutions have been unilaterally transformed to dominate the world.” Mugabe doesn’t merely critique their policies—he attributes malign intent and a systemic effort to undermine the will and welfare of the people.
Mugabe’s speech also displays a Manichaean worldview, characteristic of populist discourse. Politics is presented not as a matter of competing interests but as a moral struggle between liberation and exploitation, justice and betrayal. He claims that “Rio stands out in history as a milestone betrayed,” and describes the last decade as a time when the people’s agenda has been “ignored, sidelined and replaced by a half-baked unilateral agenda of globalisation in the service of big corporate interests of the North.” He insists that the world is now “much worse and much more dangerous” than it was at Rio, and that the failure of sustainable development is “a compelling manifestation of bad global governance.” This moralization transforms structural issues like trade and governance into a binary conflict, where “the poor” and their defenders must “reject completely” the system imposed by the North. Even neutral concepts like the rule of law are reframed as tools of domination, “falsely presented” to impose imperial interests. The high moral stakes, stark oppositions, and calls to resist “manipulative and intimidatory attempts” all reflect a deep moral dualism.
Despite the strong populist elements, there are a few pluralist references, though they are largely instrumental or subordinated to the broader populist narrative. Mugabe affirms that Zimbabwe’s land reform is being carried out “in accordance with the rule of law as enshrined in our national Constitution and laws.” He also closes by thanking international donors who pledged food aid, and briefly calls for “a paradigm shift… that reaffirms that people must always come first in any process of sustainable development.” However, these statements do not affirm political diversity or the legitimacy of opposing groups. Rather, they serve to defend his government’s legitimacy and policy agenda. There is no acknowledgment of internal dissent as valid or productive, no appeal to institutional checks or democratic pluralism. Instead, pluralist language is co-opted rhetorically, often redefined to serve the populist cause—making these elements insufficient to meaningfully challenge the underlying populist structure of the speech.
With this in mind, I would consider this speech highly populist. There are clear Manichean, people-centric, and anti-elite elements. Mugabe describes a conflict between the virtuous people of the Global South and the evil and selfish Global North, and argues that world and domestic politics should be an expression of the former. The people and the elite are clearly identified in this speech and respectively elevated or democratized. Where I would say this is not very populist is the intensity of the decisive conflict. While Mugabe does think there is a conflict, he does not frame it in an overly dramatic fashion or argue for extra-institutional change. For that, he does not get a perfect 2.0, but something slightly less. I would give this score a 1.7. This score reflects that all components are present, but the ideal of Manichaeism is not fully met in the speech.


Based on the reasoning and evidence above, this is how I would fill out the holistic grading rubric:

Country: Zimbabwe
Name of speaker: Robert Mugabe
Date of speech: September 2, 2002
Place of speech: World Summit on Sustainable Development (Johannesburg, South Africa)
Populism Elements in Mugabe’s Speech

Category 1: Manichaean Vision of the World:

Speech quotes:

'The multilateral programme of action we set for ourselves at Rio has not only been unfulfilled, but it has also been ignored, sidelined and replaced by a half-baked unilateral agenda of globalization in the service of big corporate interests of the North. The focus is profit, not the poor, the process is globalization, not sustainable development, while the objective is exploitation, not liberation.'
 
'The unilateralism of the unipolar world has reduced the rest of mankind to collective underdogs, chattels of the rich, the willful few in the North who beat, batter and bully us under the dirty cover of democracy, rule of law and good governance. Otherwise, how would they undermine at global level the same values of good governance and rule of law they arrogantly demand from the South?'
 
'In our situation in Zimbabwe, this fundamental question has pitted the black majority who are the right-holders, and, therefore, primary stakeholders, to our land against an obdurate and internationally well-connected racial minority, largely of British descent and brought in and sustained by British colonialism.'
Category 2: Cosmic Proportions and Historical Reification:
Speech quotes: 
'as we look at the next decade we must honestly acknowledge those of our actions which have served mankind and those many others which have undermined our collective wellbeing. Clearly there has to be a paradigm shift from the globalized corporate model to a people centered paradigm that reaffirms that people must always come first in any process of sustainable development.'
Category 3: Populist notion of the people:
Speech quotes: 
'For these reasons, we join our brothers and sisters in the Third World in rejecting completely manipulative and intimidatory attempts by some countries and regional blocks that are bent on subordinating our sovereignty to their hegemonic ambitions and imperial interests, falsely presented as matters of rule of law, democracy and good governance. The rule of law, democracy and governance are values that we cherish because we fought for them against the very same people who today seek to preach to us. The sustainable empowerment of the poor cannot take place in circumstances where democratic national sovereignties are assaulted and demonized on a daily basis. The poor should be able to use their sovereignty to fight poverty and preserve their heritage in their corner of the earth.'
Category 4: The Elite as a Conspiring Evil:
Speech quotes: 
'Over the years, these outdated institutions have been unilaterally transformed to dominate the world for the realization of the strategic national goals of the rich North.'
'Even the United Nations, a body that is supposed to give us equal voices, remains unreformed and undemocratic, largely because of resistance from the powerful and often selfish North.'
Category 5: Systemic Change:
Speech quotes: 
'That is why we, in Zimbabwe, understand only too well that sustainable development is not possible without agrarian reforms that acknowledges, in our case, that land comes first before all else, and that all else grows from and off it.'
Category 6: Anything goes attitude:
Speech quotes: 
No quotes
Non-Populist element in Mugabe’s Discourse
Category 1: Pluralist vision of the world

No quotes
Category 2: Concrete interpretation of political issues

No quotes
Category 3: Democracy as calculation of votes of individual citizens

No quotes
Category 4: Non-antagonistic view of opponents

No quotes 
Category 5: Incremental reform

No quotes
Category 6: Commitment to institutional norms, rights and liberties

Speech quotes:

Accordingly, my Government has decided to do the only right and just thing by taking back land and giving it to its rightful indigenous, black owners who lost it in circumstances of colonial pillage. This process is being done in accordance with the rule of law as enshrined in our national Constitution and laws. It is in pursuit of true justice as we know and understand it, and so we have no apologies to make to any one.


Overall Comments
The speech has some discursive elements to be considered populist. Firstly, there is an appeal to the Global South as the Third World or the poor countries that must defend their sovereignty. Furthermore, it argues that the people should use this sovereignty to address their common interests and challenges, in this case poverty and development. I would consider this to be indicative of people-centric rhetoric in the speech. 
Secondly, there is an identification of evil elites represented in the Global North and the rich countries who impose neoliberal policies through international institutions like the United Nations and the International Monetary Fund on poor countries, affecting their sovereignty. Similarly, it talks about how these elites have used undemocratic and unreformed institutions to suppress the will of the people. This is indicative of an anti-elite element in the speech.
Finally, there is a Manichaean vision of the world between the Global North, which is framed as evil because it promotes colonialism and exploitation, and the Global South, which is subjected to the policies promoted by the rich countries and corporate interests. At a national scale, the speech also identifies a conflict between the Black majority and the White minority, connected to the British imperialist past of Zimbabwe. There is a clear defense of the sovereignty and democracies of poor countries as the way to fulfill their liberation from the oppression of the Global North. Lastly, there are some elements of cosmic proportions in the speech, as the conflict between the North and the South is framed as potentially producing a paradigm shift for mankind. However, the speech lacks elements of an 'anything goes' attitude, instead defending the rule of law and the national Constitution. In consequence, there are some non-populist elements related to the commitment to institutional norms, rights and liberties category. 
Grade: 1.7"

# Tony Blair (step 4) #
step_4_user <- "Read the speech and code the level of populism (0-2 to the tenth place):

<speech>
Tony Blair
Speech on the European Bank for Reconstruction and Development and EU enlargement
 19 April 2004
When the European Bank for Reconstruction and Development was set up in 1991, there was a unique opportunity to develop a new wider Europe, based on plural democracy and market-based economies.
  
Today, only twelve days before the accession to the EU of 10 new member states, we can say with pride that the opportunity has been successfully seized. It is a credit to the Governments of the region, and a credit to the EBRD, which has played a vital role in the process thanks to its unique mandate.
 
The extent and speed of change has been impressive.  It may have been slower than some optimists hoped for at the start.  And it has sometimes been painful for those losing the security and certainty of an old system and not seeing the early benefits of a new one. But the completion of the Europe's biggest ever enlargement, with the prospect of more countries joining in the years ahead, is the clearest sign that the reform journey has been worthwhile.
 
The 1st May will be a genuinely historic day. The day that the division of Europe - the legacy of the Second World War and the Cold War - will be erased. The first day for new reunited Europe, for an EU of 25. It is a transformation which we can see for ourselves, whether in the high streets of Prague or Budapest, or in the conference rooms of Brussels. Europe has changed in a thousand ways, and for the better.
 
From the outset, there has been no stronger supporter of the enlargement process than Britain. It has been a rather rare point of cross-party consensus in Britain, where Europe is concerned. This government has championed it energetically.  We are proud of the part we have played - both up front and behind the scenes - to help the accession countries along the path to membership. You, the members and the staff of the EBRD also deserve to be proud. But the real achievement belongs to the ten countries which themselves have managed this transition.
 
Enlargement will increase stability, security and prosperity in our region. 
It will help prevent conflict in Europe ever reoccurring. It will entrench and help spread democracy, the rule of law and human rights. It will widen our co-operation to face new threats - from environmental degradation to terrorism - together.
 
It will create a vast free trade market of 450 million consumers is an enormous achievement, with immense potential for the future. Increased trade, investment, and competition will benefit us all - in the new EU countries and the existing members alike. 
 
In Britain, the Treasury estimates that 100,000 British jobs are already linked to the export of goods and services to the new EU member states. Our trade with the eight largest accession states has grown by almost 200% in the last decade. Studies predict that this trade will continue to expand, creating more jobs in the future.
 
Of course enlargement also bring new challenges.  It will force the EU to review its processes, institutions and ideas. It means that the EU has new neighbours, with whom we must strengthen our relationships. We must adapt to reflect our expanded membership, as well as the changing world in which we live.
 
In particular, Europe must press ahead with the process of economic reform. I am convinced that the entry of ten new members will be a boost for this agenda. The record of modernisation which the new members have demonstrated in the last decade and a half is an inspiring example to all of us. Their proven determination and commitment to reform will be an asset to the whole of the EU. 
 
Ten years ago, few of us would have envisaged the shape of Europe we now live in. But few could deny that Europe is today a more secure, stable and prosperous place.
 
This enlargement has undoubtedly been one of the European project's greatest success stories. Now we must sustain the process so future generations can continue to reap the benefits.
 
We hope to complete negotiations with Bulgaria and Romania by end of this year.  Then we have a crucial decision on Turkey in December, with the chance to anchor Turkey's place in Europe. And we have the prospect of future membership for the Western Balkans.
 
That is why the EBRD will still have a very important role in the years ahead.
 
The EBRD has been at the heart of the process of transition, supporting the economic and political transformation of many nations over the last thirteen years.
 
The Bank was not set up to exist for ever.  It is there to help countries make the transition, to a point where their own domestic institutions and investors and international business provide the basis for their economic growth. 
 
The transition is not yet finished in the countries which are about to join the EU. The EBRD will still help them complete this process.  But as they gain a new framework of support as EU members, and as the interest of international investors grows, the EBRD's role should naturally fall away over the years to come.
 
Nevertheless, there is still a major role for the Bank in countries further east and south.  You are already playing a key role in Bulgaria and Romania.  The Bank has assisted international efforts for stabilization and reconstruction in the Balkans.  It has become an increasingly important partner in Russia's reform efforts.  This vital work must continue.
 
The Bank needs to make a more concerted effort in those countries of the region which are at an early stage of transition. These countries require substantial help to reduce poverty, to promote growth and tackle corruption, organised crime and HIV/AIDS. 
 
The EBRD can bring its unique mix of private sector expertise, institutional experience and finance to bear. But it needs the commitment of the countries themselves, new interest from domestic and international investors, effective coordination with the international community and grant support. 
 
We strongly welcome the Bank's new initiative to support the early transition countries.  The UK is ready to engage with the Bank in shaping this initiative and in giving new financial support.  Within the Bank this agenda needs to be promoted as a core priority.
 
The Bank must continue to search for ways to engage constructively in countries where problems exist over political reform.  This is not about imposing a particular form of democracy from outside.  Rather, it reflects the beliefs of the Bank's founders, confirmed in practice, that political reform and economic progress are inextricably linked. 
 
The EBRD has much to be proud of - and there could be no better time to recognise that than the eve of the EU's enlargement. It is also well positioned to meet the new challenges.  Its location in the City of London enables it to benefit from a huge range of expertise and experience close to hand. Its leadership and its staff have shown themselves ready to take on the next set of challenges with vigour.
 
It remains for me only to congratulate President Lemierre, the management and staff of the Bank on your achievements, and to wish you a very successful Annual Meeting here in London, and every success in the years ahead.
</speech>
"

#  Blair Grade #
step_4_ast <- "As I go through the speech, I am going to go through my thought process as I assess the evidence.

Tony Blair’s speech offers no meaningful articulation of a unified ‘people’ in the populist sense. Nowhere does Blair identify a singular, morally pure collective whose general will must be enacted or restored. While he praises “the ten countries which themselves have managed this transition” into the EU, he does so in institutional and meritocratic terms, not as a function of their inherent virtue or identity as “the people.” The public is almost entirely absent as an active subject of history; instead, success is attributed to governments, international institutions, and economic reforms. When Blair does refer to social groups—such as consumers, workers, or citizens—he does so in aggregate and technocratic terms (e.g., “a vast free trade market of 450 million consumers”), avoiding any language that would sacralize or romanticize the people as a sovereign moral entity.
Similarly, the speech contains no populist-style attack on a corrupt or conspiring elite. Blair does not define an enemy—domestic or international—who is blocking the will of the people or undermining democracy. There is no scapegoating of Brussels bureaucrats, global capital, domestic out-groups, or ideological adversaries. Even when discussing the painful aspects of transition—such as the “security and certainty of an old system” being lost—Blair emphasizes structural challenges rather than moral blame. Any criticism is mild, general, and system-oriented, not personalized or demonizing. The speech is fundamentally consensus-oriented: it praises cross-party agreement, intergovernmental cooperation, and institutional achievements. This marks a stark departure from populist rhetoric, which thrives on identifying enemies and constructing moral binaries.
The absence of a Manichaean worldview is one of the speech’s most defining features. Blair repeatedly emphasizes complexity, reform, and adaptation—not crisis, betrayal, or salvation. The language is optimistic but measured: EU enlargement is “a genuinely historic day,” but not the culmination of a cosmic struggle. Rather than presenting politics as a clash between good and evil, Blair frames it as a long process of institutional evolution and technical adjustment. Even where he invokes values—such as “democracy, the rule of law and human rights”—these are not pitched in existential or redemptive terms. There is no suggestion that history has arrived at a final confrontation, or that moral purity is at stake. The tone is procedural and forward-looking, not apocalyptic or morally charged.
Indeed, the speech is heavily pluralist, both in content and in tone. Blair emphasizes diversity, cooperation, and institutional mediation at every turn. He lauds the EU as a mechanism for peace and shared prosperity, and praises the EBRD for supporting “plural democracy” and reforms across varied contexts. He acknowledges that enlargement brings “new challenges” and will require “review” and “adaptation”—a clear endorsement of political complexity and the legitimacy of multiple perspectives. His vision of Europe is not as a unified moral agent but as a mosaic of sovereign states committed to common institutions and norms. This deep respect for disagreement, procedural reform, and democratic institutions situates Blair’s speech firmly in the pluralist tradition. If anything, the speech’s technocratic focus on development banks, trade volumes, and job creation underscores how little space it leaves for populist-style mobilization


The fact that the speech so consistently lauds pluralism, as well as the fact that he focuses mostly on financial policy, and the fact that there is no identifiable elite or people in the speech means that this speech is decidedly non-populist. In fact, it is very pluralist. There is some cosmic framing going on in the beginning, but the absence of any core elements of populism (people-centrism, anti-elitism) means that this cosmic framing serves to heighten the pluralism, rather than making this populist. I would give this a 0.0, meaning essentially no populism.


Here is how I would fill out the rubric based on this reasoning and evidence:
Tony Blair

Populist Elements in Blair’s speech

Category 1: Manichaean Vision of the World (Category 1):
 
No quotes:
 
Category 2: Cosmic Proportions and Historical Reification:
 
Speech quotes: 

The 1st May will be a genuinely historic day. The day that the division of Europe - the legacy of the Second World War and the Cold War - will be erased. The first day for new reunited Europe, for an EU of 25. It is a transformation which we can see for ourselves, whether in the high streets of Prague or Budapest, or in the conference rooms of Brussels. Europe has changed in a thousand ways, and for the better.
 
Category 3: Populist notion of the people:
 
No quotes
 
Category 4: The Elite as a Conspiring Evil:
 
No quotes: 

Category 5: Systemic Change:
 
No quotes: 

Category 6: Anything goes attitude:

No quotes: 

 Non-Populist elements in Blair’s speech

Category 1: Pluralist vision of the world

Speech quotes:

'When the European Bank for Reconstruction and Development was set up in 1991, there was a unique opportunity to develop a new wider Europe, based on plural democracy and market-based economies'.
Category 2: Concrete interpretation of political issues

Speech quotes: 

'Ten years ago, few of us would have envisaged the shape of Europe we now live in. But few could deny that Europe is today a more secure, stable and prosperous place'.
Category 3: Democracy as calculation of votes of individual citizens

No quotes
Category 4: Non-antagonistic view of opponents

Speech quotes:

The Bank must continue to search for ways to engage constructively in countries where problems exist over political reform.  This is not about imposing a particular form of democracy from outside.  Rather, it reflects the beliefs of the Bank's founders, confirmed in practice, that political reform and economic progress are inextricably linked. 
Category 5: Incremental reform

Speech quotes:

'It will create a vast free trade market of 450 million consumers is an enormous achievement, with immense potential for the future. Increased trade, investment, and competition will benefit us all - in the new EU countries and the existing members alike'. 
Category 6: Commitment to institutional norms, rights and liberties

Speech quotes:

'Of course enlargement also bring new challenges.  It will force the EU to review its processes, institutions and ideas. It means that the EU has new neighbors, with whom we must strengthen our relationships. We must adapt to reflect our expanded membership, as well as the changing world in which we live'.

Overall comment:

Firstly, there is no identification of a 'virtuous people,' nor of a corrupt elite opposed to them. Moreover, the centrality of the general will of the people is not recognized as an important element in the speech. On the contrary, the speech focuses on a specific topic: the European Bank for Reconstruction and Development. Additionally, the inclusion of new members in the European Union is highlighted as desirable, emphasizing pluralism and the market economy. Consequently, we cannot say that there are people-centric or anti-elite elements present in this speech. 

Finally, the speech underscores the importance of democratic institutions, which are presented as fundamental for Europe's development. Technically, there are some populist elements of cosmic proportions in the speech, referring to May 1st as a historic day for Europe and the world, but it's not in a context that would lead me to call this Manichaeism. Rather, it seems that the author is appreciating the policy changes that correspond with that day and not as a day of an epic political battle like a true populist might describe it.

Because there are really no key elements of populism in this speech, I would give it a 0.0. 


Grade: 0.0"

# Evo Morales (step 5) #
step_5_user <- "Read the speech and code the level of populism (0-2 to the tenth place):
<speech>
EVO MORALES
This is the text of a speech given in 2003 shortly after the events mentioned in the speech.]
What happened these past days in Bolivia was a great revolt by those who have been oppressed for more than 500 years. The will of the people was imposed this September and October, and has begun to overcome the empire’s cannons. We have lived for so many years through the confrontation of two cultures: the culture of life represented by the indigenous people, and the culture of death represented by the West. When we the indigenous people–together with the workers and even the businessmen of our country–fight for life and justice, the State responds with its 'democratic rule of law.'
What does the 'rule of law' mean for indigenous people? For the poor, the marginalized, the excluded, the 'rule of law' means the targeted assassinations and collective massacres that we have endured. Not just this September and October, but for many years, in which they have tried to impose policies of hunger and poverty on the Bolivian people. Above all, the 'rule of law' means the accusations that we, the Quechuas, Aymaras and Guaranties of Bolivia keep hearing from our governments: that we are narcos, that we are anarchists. This uprising of the Bolivian people has been not only about gas and hydrocarbons, but an intersection of many issues: discrimination, marginalization , and most importantly, the failure of neoliberalism.
The cause of all these acts of bloodshed, and for the uprising of the Bolivian people, has a name: neoliberalism. With courage and defiance, we brought down Gonzalo Sanchez de Lozada–the symbol of neoliberalism in our country–on October 17, the Bolivians’ day of dignity and identity. We began to bring down the symbol of corruption and the political mafia.
And I want to tell you, companeras and companeros, how we have built the consciousness of the Bolivian people from the bottom up. How quickly the Bolivian people have reacted, have said–as Subcomandate Marcos says–ya basta!, enough policies of hunger and misery.
For us, October 17th is the beginning of a new phase of construction. Most importantly, we face the task of ending selfishness and individualism, and creating–from the rural campesino and indigenous communities to the urban slums–other forms of living, based on solidarity and mutual aid. We must think about how to redistribute the wealth that is concentrated among few hands. This is the great task we Bolivian people face after this great uprising.
It has been very important to organize and mobilize ourselves in a way based on transparency, honesty, and control over our own organizations. And it has been important not only to organize but also to unite. Here we are now, united intellectuals in defense of humanity–I think we must have not only unity among the social movements, but also that we must coordinate with the intellectual movements. Every gathering, every event of this nature for we labor leaders who come from the social struggle, is a great lesson that allows us to exchange experiences and to keep strengthening our people and our grassroots organizations.
Thus, in Bolivia, our social movements, our intellectuals, our workers–even those political parties which support the popular struggle ­joined together to drive out Gonzalo Sánchez Lozada. Sadly, we paid the price with many of our lives, because the empire’s arrogance and tyranny continue humiliating the Bolivian people.
It must be said, compañeras and compañeros, that we must serve the social and popular movements rather than the transnational corporations. I am new to politics; I had hated it and had been afraid of becoming a career politician. But I realized that politics had once been the science of serving the people, and that getting involved in politics is important if you want to help your people. By getting involved, I mean living for politics, rather than living off of politics. We have coordinated our struggles between the social movements and political parties, with the support of our academic institutions, in a way that has created a greater national consciousness. That is what made it possible for the people to rise up in these recent days.
When we speak of the 'defense of humanity,' as we do at this event, I think that this only happens by eliminating neoliberalism and imperialism. But I think that in this we are not so alone, because we see, every day that anti-imperialist thinking is spreading, especially after Bush’s bloody 'intervention' policy in Iraq. Our way of organizing and uniting against the system, against the empire’s aggression towards our people, is spreading, as are the strategies for creating and strengthening the power of the people.
I believe only in the power of the people. That was my experience in my own region, a single province–the importance of local power. And now, with all that has happened in Bolivia, I have seen the importance of the power of a whole people, of a whole nation. For those of us who believe it important to defend humanity, the best contribution we can make is to help create that popular power. This happens when we check our personal interests with those of the group. Sometimes, we commit to the social movements in order to win power. We need to be led by the people, not use or manipulate them.
We may have differences among our popular leaders–and it’s true that we have them in Bolivia. But when the people are conscious, when the people know what needs to be done, any difference among the different local leaders ends. We’ve been making progress in this for a long time, so that our people are finally able to rise up, together.
What I want to tell you, compañeras and compañeros–what I dream of and what we as leaders from Bolivia dream of is that our task at this moment should be to strengthen anti-imperialist thinking. Some leaders are now talking about how we–the intellectuals, the social and political movements–can organize a great summit of people like Fidel, Chávez. and Lula to say to everyone: 'We are here, taking a stand against the aggression of the US imperialism.'
A summit at which we are joined by compañera Rigoberta Menchú, by other social and labor leaders, great personalities like Pérez Ezquivel. A great summit to say to our people that we are together, united, and defending humanity. We have no other choice, compañeros and compañeras–if we want to defend humanity we must change systems and this means overthrowing US imperialism.
</speech>"

# Morales Grade #
step_5_ast <- "Given the training I have received, this is how I would grade this speech by Evo Morales.

Evo Morales’s speech is grounded in a strong people-centric narrative, which clearly defines who “the people” are: Bolivia’s indigenous communities (Quechuas, Aymaras, Guaraníes), campesinos, workers, and poor urban dwellers. Morales frames these groups as morally virtuous and historically oppressed, describing them as having “been oppressed for more than 500 years.” He valorizes their resistance and collective awakening: “the will of the people was imposed this September and October,” and celebrates this moment as a kind of resurrection of dignity and popular power. His calls for “other forms of living, based on solidarity and mutual aid” reflect a romanticized and moral conception of the people as not only sovereign but ethically superior. He speaks of “popular power” as a political ideal and calls for leaders who “live for politics, rather than live off politics,” reinforcing the idea that legitimacy flows from fidelity to the people’s will. In short, Morales’s speech constructs “the people” as a singular, righteous, and unified moral force.
The speech also includes a vivid and expansive construction of an evil elite, which Morales portrays as conspiratorial, violent, and systemically oppressive. This elite includes the Bolivian political class (especially former president Gonzalo Sánchez de Lozada), transnational corporations, neoliberal policymakers, and U.S. imperialism. Morales blames this elite for “targeted assassinations and collective massacres,” as well as for long-term structural violence: “policies of hunger and poverty,” and the cultural demonization of indigenous people, whom the state accuses of being “narcos” and “anarchists.” The term “political mafia” suggests a corrupt and self-serving political class, and Morales denounces neoliberalism itself as “the cause of all these acts of bloodshed.” He explicitly identifies U.S. foreign policy, including George W. Bush’s intervention in Iraq, as an extension of the same imperialist aggression facing Bolivia. This enemy is described not merely in political or economic terms, but in moral and existential ones, and is depicted as incompatible with the values and survival of the people.
The speech is deeply steeped in a Manichaean worldview, portraying the political field as a struggle between life and death, virtue and evil, dignity and humiliation. Morales contrasts “the culture of life represented by the indigenous people” with “the culture of death represented by the West.” This dualism saturates the rhetoric, as he depicts neoliberalism and imperialism as antithetical to humanity itself. The uprising is not just a political event—it is framed as a battle for the soul of Bolivia, if not humanity: “if we want to defend humanity we must change systems and this means overthrowing US imperialism.” There are no shades of gray in this cosmology—only an oppressed people rising against a predatory and inhumane system. The invocation of October 17 as “the Bolivians’ day of dignity and identity” marks it as a foundational and morally charged event, cementing the sense of cosmic stakes and finality typical of populist discourse.
There are no meaningful pluralist elements in Morales’s speech. He does not acknowledge a legitimate diversity of interests, nor does he affirm democratic institutions as neutral arenas for negotiation among competing groups. Instead, existing political institutions—especially the rule of law—are depicted as masks for violence and domination: “the ‘rule of law’ means the targeted assassinations and collective massacres that we have endured.” Political opponents are not framed as misguided but legitimate actors; rather, they are enemies of the people who must be removed or overthrown. Even when Morales mentions political parties and intellectuals joining with social movements, this is not framed as coalition-building among equals, but as a unification behind the moral cause of the people. The emphasis on “unity” is not pluralist—it is homogenizing and moralizing. There is no suggestion that dissent, institutional balance, or compromise are values to be preserved. Instead, this is a radically populist vision that positions politics as the vehicle for restoring the sacred will of the people and expelling the forces of imperialism and neoliberalism.
Based on this, I would say that this is a 2.0 on a scale of 0.0 to 2.0. The rhetoric embodies a particularly strong form of populism, while pluralism seems entirely absent. 

Here is how I would fill out the rubric given the reasoning and evidence I just presented.

Populist Elements in Morales’s speech

Category 1: Manichaean Vision of the World:
 
Speech quotes:

'We have lived for so many years through the confrontation of two cultures: the culture of life represented by the indigenous people, and the culture of death represented by West'.
 
When we the indigenous people–together with the workers and even the businessmen of our country–fight for life and justice, the State responds with its 'democratic rule of law.'
 
It must be said, compañeras and compañeros, that we must serve the social and popular movements rather than the transnational corporations.
 
Category 2: Cosmic Proportions and Historical Reification:
 
Speech quotes: 

'What happened these past days in Bolivia was a great revolt by those who have been oppressed for more than 500 years. The will of the people was imposed this September and October, and has begun to overcome the empire’s cannons'.
 
For us, October 17th is the beginning of a new phase of construction. Most importantly, we face the task of ending selfishness and individualism, and creating–from the rural campesino and indigenous communities to the urban slums–other forms of living, based on solidarity and mutual aid. We must think about how to redistribute the wealth that is concentrated among few hands. This is the great task we Bolivian people face after this great uprising.
 
Category 3: Populist notion of the people:
 
Speech quotes: 

'I believe only in the power of the people. That was my experience in my own region, a single province–the importance of local power. And now, with all that has happened in Bolivia, I have seen the importance of the power of a whole people, of a whole nation'.
 
 
And I want to tell you, companeras and companeros, how we have built the consciousness of the Bolivian people from the bottom up. How quickly the Bolivian people have reacted, have said–as Subcomandate Marcos says–ya basta!, enough policies of hunger and misery.
 
Category 4: The Elite as a Conspiring Evil:
 
Speech quotes: 

'The cause of all these acts of bloodshed, and for the uprising of the Bolivian people, has a name: neoliberalism'.
 
'We have no other choice, compañeros and compañeras–if we want to defend humanity we must change systems and this means overthrowing US imperialism'.

When we speak of the 'defense of humanity,' as we do at this event, I think that this only happens by eliminating neoliberalism and imperialism. But I think that in this we are not so alone, because we see, every day that anti-imperialist thinking is spreading, especially after Bush’s bloody 'intervention' policy in Iraq.

Category 5: Systemic Change:
 
Speech quotes: 

'With courage and defiance, we brought down Gonzalo Sanchez de Lozada–the symbol of neoliberalism in our country–on October 17, the Bolivians’ day of dignity and identity. We began to bring down the symbol of corruption and the political mafia'.

'For us, October 17th is the beginning of a new phase of construction'.

Category 6: Anything goes attitude:

Speech quotes: 

Above all, the 'rule of law' means the accusations that we, the Quechuas, Aymaras and Guaranties of Bolivia keep hearing from our governments: that we are narcos, that we are anarchists. This uprising of the Bolivian people has been not only about gas and hydrocarbons, but an intersection of many issues: discrimination, marginalization , and most importantly, the failure of neoliberalism.
Non-Populist element in Morales’s Discourse
Category 1: Pluralist vision of the world

No quotes
Category 2: Concrete interpretation of political issues

No quotes
Category 3: Democracy as calculation of votes of individual citizens

No quotes
Category 4: Non-antagonistic view of opponents

No quotes 
Category 5: Incremental reform

No quotes
Category 6: Commitment to institutional norms, rights and liberties

No quotes:

Overall comment: 

Firstly, the speech strongly identifies the notion of the Bolivian people or the Indigenous people in opposition to North American imperialism and neoliberalism. Additionally, at a national scale, there is an antagonistic notion against the traditional political elites in Bolivia, the State and the 'rule of law', positioned against the Indigenous peoples, workers, and the poor. Here, the people are strongly defined as the marginalized and the excluded, including various Indigenous peoples and workers.  I would say that the people-centric component is clearly present in this speech, and are seen as the means to overcome the corrupt system and bring prosperity to the country. 

Similarly, because the poor and indigenous are juxtaposed against a corrupt political elite and North American neoliberals, I would also say that the element of anti-elite rhetoric is also there, as the speech rails against these groups as being undemocratic and undermining the will of the previously identified ‘pure’ people.

Additionally, the Manichean element is present. There is the use of combative language opposing imperialism, with terms such as the 'culture of death' or the 'bloody' war in Iraq, which indicates cosmic proportions, while the talk of the will of the people overthrowing the old system and neoliberalism is a call for radical change. There are no clear non-populist elements in the discourse. 

This is a very populist speech. I argue for 2.0, since the speech basically meets the ideals for each component of populism.

Grade: 2.0"


# Stephen Harper (step 6) #
step_6_user <- "Read the speech and code the level of populism (0-2 to the tenth place):

<speech>
The Federal Accountability Act
04 November 2005
Address by the Hon. Stephen Harper, P.C., M.P.
 Leader of the Conservative Party of Canada
 Leader of the Official Opposition
OTTAWA
 Friday November 4, 2005
Dear Friends,
Earlier this week, Justice John Gomery confirmed what many Canadians suspected:
The Liberal party established the Sponsorship program,
The Liberal party ran the Sponsorship program, and
And the Liberal party used the Sponsorship program to enrich Liberals and finance Liberal election campaigns.
The judge was clear.  He said there was, quote: 'clear evidence of political involvement in the administration of the sponsorship program'
Quote: 'A complex web of financial transactions… involving kickbacks and illegal contributions' to the Liberal party.
And, quote: 'A culture of entitlement among political officials and bureaucrats involved with the sponsorship program'
Illegal cash and kickbacks
Fake contracts for no work
A culture of entitlement and corruption
These are no longer media speculations or partisan statements.  These are findings of fact in a judicial inquiry. 
Quebeckers, especially, are rightfully angry and outraged.  This government lied to them!  This government betrayed them!
But to people at home this is about more than the specific sordid details of this particular scandal.
It’s about accountability.  Accountability is what Canadians expect when they send their hard-earned tax dollars to Ottawa.  It’s what they deserve.
Government exists to serve the public. 
To serve ordinary Canadians
To serve the people who work hard, pay their taxes and play by the rules.
It’s their money that was stolen.  It’s their trust that was broken.  And no one has been held accountable.
When I become Prime Minister I will undertake an unprecedented overhaul of the federal government, introducing sweeping reforms to make Ottawa accountable.
That is my commitment to you.  Cleaning up government begins at the top.
Paul Martin said he was mad as hell about sponsorship.  He went on to blame federal public servants.  He blamed former ministers.  He blamed his predecessor.
But under Paul Martin’s watch, the waste, mismanagement and corruption has continued.  We’ve seen Art Eggleton, a man Jean Chretien fired for giving an untendered contract to a former girlfriend; get rewarded by Paul Martin with a seat in the senate.
We’ve seen Paul Martin working on a half-million dollar severance deal with David Dingwall  The guy who hired Chuck Guité to run government advertising, who as an unregistered lobbyist who accepted improper payments, and as a patronage champion who quit his job.
We’ve seen lobbyists making their pitch to Paul Martin and his ministers at $5000 per person cocktail parties.  It has to stop.  And it will.
Most Canadians don’t think that political office should be a guaranteed, permanent career.  It should be a worthy form of limited public service.  We all know people in our communities who have served for a term or two on city council, the provincial legislature, as a member of parliament or as one of any of their dedicated staff.
And I think we admire most those who after having done what they came to do, simply decide to return to their former jobs and their former lives.  Rather than hanging on in office or around government as lobbyists or political appointees.
I think we all have more respect for those citizens who run for office to change politics, not to have politics change them.  And that is how I want to treat my time in public office
I’m here to do a job, not to join a club, not to buy into a lifestyle.  And there is no more important job to do than cleaning up government and bringing accountabilty back to Ottawa.
If we don’t clean up government, it will compromise our ability to use government as a force for good in this country.
To ensure people get timely access to health care.
To crack down on crime.
To reduce taxes and reward hard work.
To improve the quality of our life in communities.
And yes, to keep our country united.
Canada’s unity is not a reserve of money hidden in the Prime Minister’s office.  Not about contracts given to some friends to capitalize on our flag.  Not about advertising agencies that created and built Canada.
It is about generations of men and women, from different cultures and backgrounds, who shared, and still do, common ambitions and values.
It is about a Quebec government, over 30 years ago, adopting the most severe and most equitable laws against election corruption.
The federal Liberals didn’t understand that message.
I am telling you today that I will follow this example, as Prime Minister of Canada.
As I’ve already said, as Prime Minister, I will ensure to follow-up Justice Gomery’s findings.  We will not only prosecute agencies and individuals; but, as the judge said, the Liberal Party of Canada is responsible as an institution.  And the Liberal party will be prosecuted.
Even this exercise will be meaningless unless our government is different.  We must clean up corruption and lift the veils of secrecy that allow it to flourish.  We must do nothing less than replace the culture of entitlement with the culture of accountability.
As Prime Minister the first piece of legislation I will introduce will be the Federal Accountability Act.  The Federal Accountability Act will change the way business is done in Ottawa.
It will give more power to the auditor general, the ethics commissioner, the information commissioner, and the lobbyist registrar.
To make sure that these independent officers of parliament can hold the government accountable.  It will make sure that all of the over $30 billion in federal grants, contributions and contracts are awarded fairly and provide value for taxpayers’ money.  It will give real protection to those who blow the whistle on unethical behaviour.
It will open the windows on government with long overdue reforms to access to information laws.  It will make sure that appointments to public office are fair and based on merit and qualifications.
As some of you may already know: I am not in politics because I am a good dancer or particularly funny.  What I want, with the trust of my party, and with the support of all Canadians who want change, is to give a dynamic and honest government to the country we all love.
Nothing more.  And nothing less. 
I want to highlight three areas of the Federal Accountability Act today.
First and most importantly, this act will end the influence of big money and crack down on a lobbying culture that has thrived under Paul Martin.
As Prime Minister, I will ban all remaining corporate and union donations to federal political parties, period.  
People vote, not corporations and unions.  And only voters should be funding political parties.
Politics will no longer be a stepping stone to a lucrative career lobbying government. 
I will close the loopholes that allow MPs and candidates to create secret personal trust funds.  And I will cap all donations to federal political parties at a maximum of $1,000 per year.
This means no more big interests lobbying the Prime Minister at behind closed doors $5,000 a ticket cocktail parties.
This means no more hidden slush funds controlled by MPs and riding associations.  All political campaigns will be funded by modest personal donations from people who believe in their cause not by special interests who think they can buy influence with politicians.
Second, we are going to crackdown on the revolving door between ministers’ offices, the senior public service, and the lobbying industry. 
We will ban all former ministers, ministerial staffers, or senior public officials from lobbying government for five years.  We will require all ministers and senior officials to record their contacts with lobbyists.  And we will make sure that there are real teeth and real penalties to enforce the Lobbyist Registration Act.
Taken together, our changes would have prevented a Liberal candidate and Martin insider like Richard Mahoney from lobbying for his clients at Liberal fundraisers without registering.  And, they would have prevented David Dingwall from lobbying his old colleagues in government and accepting unethical contingency fee contracts.
Politics will no longer be a stepping stone to a lucrative career lobbying government.  Make no mistake, if there are MPs in the room who want to use public office for their own benefit, if there are hill staffers who dream of making it rich trying to lobby a future Conservative government,
If that’s true of any of you, you had better make different plans.  Or leave.
Third, as I’ve said we are going to mandate the Auditor General to do a complete review of all of the more than 30 billion dollars in federal grants, contributions, and contracts.  The Federal Accountability Act will give her the power to 'follow the money' to the end recipients.
She must be able to find out whether money has been stolen, misused, or kicked back to political parties after it has left the federal treasury.  Had she had this authority, she might have uncovered the depth of the sponsorship scandal three years ago or more.  These and many more changes explained in detail in the Federal Accountability Act will change the way that politics and government is done in this country.
Friends, no government is perfect because none of us are perfect.  We cannot 'dream of a system so perfect that no one will have to be good.'  Whatever the system of rules, we have a duty to do what’s best for the public good when we take the oath of public office.
When I become Prime Minister, those in government will have to serve the public interest, not their personal interests.  We are going to change the way government works, not just change the colour on the letterhead.
Now the liberals will say that they too are comitted to reform.  They say they will bring in changes to the administration of the public service.  And they say that the second Gomery report will have even more ideas for reforming institutions.
We will listen to those ideas for reform.
But this scandal did not happen because of bad public servants or poor auditing.  It is a scandal that happened because of the culture of entitlement and corruption in the Liberal party.  And the veils of secrecy it has allowed to close around our federal government.  The Liberal party has proved incapable of reforming itself.  
It only acts after it has been caught. 
And its actions are always half measures. 
We cannot change the system by asking the opinions of judges and accountants.
As a democratic society, we must hold accountable the party and the people who allowed this to happen under their watch.  Creating a different way of doing government must begin by electing a different government.  The time has passed for weak reforms, promises, excuses, crocodile tears
It is time to change governments
Only a new government can ensure that those responsible are held accountable to the full extent of the law.  And only a new government will be able to impose real reforms that will weed out the remaining problems root and branch.
When I am prime minister we will bring in the Federal Accountability Act.  It will not make things perfect, but it will ensure that people are held to account for their actions.  This plan which I have introduced is my commitment to Canadians to clean up government and change it forever.
I am proud to be the leader of the new Conservative Party of Canada – very proud.  But I don’t want to be the Prime Minister of the Conservatives.
I am also very proud to live in Alberta.  But I don’t want to be the Prime Minister of western Canada.
I want to be the Prime Minister of all Canadians.  Of all those who work hard to give a better life to their children, to their communities and to their country
It is my personal word as a taxpayer, as a father, and as a fellow citizen.
I want to get this job done.
When my political career is over, I want to leave knowing that future governments will have to be more honest, more ethical, and more accountable.
But I need your help to do so.
If we want to make the Federal Accountability Act a reality, if we want to change the way the system works, we have to begin by changing this government.
Join me. 
Stand up for clean government.  Stand up for accountability.
Stand up for Canada.
Thank you.
God bless Canada.
</speech>"


# Harper Grade #
step_6_ast <- "As I went through the speech, these are the thoughts I had regarding the level of populism in the speech.

Stephen Harper’s speech clearly constructs a people-centric narrative centered on “ordinary Canadians” who are described as virtuous, law-abiding, and hard-working. These citizens “work hard, pay their taxes and play by the rules,” and it is their trust and tax money that has been betrayed. Harper positions himself as a political outsider entering public life not “to join a club,” but to clean up government on behalf of these everyday citizens. While he does not elevate “the people” into an ideologically unified or quasi-sacred force, he portrays them as the legitimate moral foundation of politics and the intended beneficiaries of government reform. This rhetoric aligns with populist discourse in that it affirms a morally good people whose interests have been ignored or violated by corrupt elites, and who are now poised to correct the system by electing Harper.
The anti-elite element is unmistakable and rhetorically forceful. Harper targets the Liberal Party, specific Liberal officials, and the broader lobbying culture in Ottawa as the source of systemic corruption. He cites the findings of the Gomery Inquiry as evidence of “illegal contributions,” “kickbacks,” and a “culture of entitlement.” Importantly, he does not frame this as individual misbehavior but as institutional rot: “The Liberal Party of Canada is responsible as an institution.” Harper’s calls to “prosecute” the party and eliminate its influence reflect a classic populist trope: the need to purge a corrupt elite to restore political integrity. This elite is not merely inefficient or out of touch—it is portrayed as fundamentally self-serving and morally compromised, directly opposed to the interests of the Canadian people.
The Manichaean dimension of the speech is present, but measured rather than extreme. Harper constructs a binary opposition between a virtuous people and a corrupt elite, and presents the political crisis as one requiring sweeping moral renewal. However, he refrains from invoking apocalyptic stakes or framing the conflict in cosmic terms. Instead of existential doom, he speaks of the need to “change the way government works” and “replace the culture of entitlement with a culture of accountability.” The language is denunciatory but not bellicose; while the speech presents a moral conflict, it remains within the bounds of procedural and institutional reform. This makes the Manichaean framing moderate—present, but not rhetorically maximalist or revolutionary in tone.
As for pluralist content, Harper’s speech does not include a strong celebration of pluralism or political diversity, but it is also not anti-pluralist. The speech affirms the value of institutional checks, oversight bodies like the Auditor General, and transparency reforms—all of which suggest a belief in liberal-democratic mechanisms rather than their rejection. Harper never delegitimizes dissent or undermines the idea that multiple perspectives might coexist in democratic politics. Instead, he offers an anti-corruption critique that assumes the legitimacy of Canada’s institutional framework, albeit one in need of serious reform. These elements significantly temper the intensity of his populist claims and position his platform as reformist rather than revolutionary. For these reasons, I would give this speech a 1.0.
Here is the coding for populism in the Stephen Harper speech given the analysis above: 
Populist Elements in Harper's speech

Category 1: Manichaean Vision of the World:
 
Speech quotes:
 
'Quebeckers, especially, are rightfully angry and outraged.  This government lied to them!  This government betrayed them!'

'Canada’s unity is not a reserve of money hidden in the Prime Minister’s office.  Not about contracts given to some friends to capitalize on our flag.  Not about advertising agencies that created and built Canada.'

'We must clean up corruption and lift the veils of secrecy that allow it to flourish.  We must do nothing less than replace the culture of entitlement with the culture of accountability.'

'People vote, not corporations and unions.  And only voters should be funding political parties.'

'When I become Prime Minister, those in government will have to serve the public interest, not their personal interests.'
 
Category 2: Cosmic Proportions and Historical Reification:
 
Speech quotes: 

No quotes 
 
Category 3: Populist notion of the people:
 
Speech quotes: 

'Government exists to serve the public. 
• To serve ordinary Canadians
• To serve the people who work hard, pay their taxes and play by the rules.'

 'As a democratic society, we must hold accountable the party and the people who allowed this to happen under their watch.  Creating a different way of doing government must begin by electing a different government.  The time has passed for weak reforms, promises, excuses, crocodile tears'

'I want to be the Prime Minister of all Canadians.  Of all those who work hard to give a better life to their children, to their communities and to their country'

Category 4: The Elite as a Conspiring Evil:
 
Speech quotes: 
'We will not only prosecute agencies and individuals; but, as the judge said, the Liberal Party of Canada is responsible as an institution.  And the Liberal party will be prosecuted.'
'We’ve seen lobbyists making their pitch to Paul Martin and his ministers at $5000 per person cocktail parties.  It has to stop.  And it will.'
'Most Canadians don’t think that political office should be a guaranteed, permanent career.  It should be a worthy form of limited public service.  We all know people in our communities who have served for a term or two on city council, the provincial legislature, as a member of parliament or as one of any of their dedicated staff.'
'This means no more big interests lobbying the Prime Minister at behind closed doors $5,000 a ticket cocktail parties.'
'Second, we are going to crackdown on the revolving door between ministers’ offices, the senior public service, and the lobbying industry.'
Category 5: Systemic Change:
 
Speech quotes: 

'When I become Prime Minister, those in government will have to serve the public interest, not their personal interests.  We are going to change the way government works, not just change the colour on the letterhead'. 
Category 6: Anything goes attitude:

No quotes

Non-Populist element in Harper’s Discourse
Category 1: Pluralist vision of the world

No quotes
Category 2: Concrete interpretation of political issues

No quotes
Category 3: Democracy as calculation of votes of individual citizens

No quotes
Category 4: Non-antagonistic view of opponents

No quotes 
Category 5: Incremental reform

No quotes
Category 6: Commitment to institutional norms, rights and liberties

No quotes:

Overall Comments:

Firstly, the speech identifies the Canadian people as ordinary, hardworking individuals who are portrayed as virtuous. The author argues that these good and virtuous people will bring about systemic change through the election of the author and cleanse Canada of corruption. I would say that the people-centric element is here. 
Similarly, the speech identifies a clear enemy, which is corrupt and opposed to the common people. This corrupt elite is represented by the government, the Liberal Party and lobbyists. The speeches talks at length about how corrupt this group is, and how they have failed to serve the Canadian people. I would say the anti-elite component is present.
 While there is some evidence of the Manichean element being present with talks of a conflict between the two groups, no cosmic proportions or historic reification are recognized in the Manichaean division between the people and the government. Additionally, while there is denunciatory language, it does not possess a strongly bellicose tone. There are no clear non-populist elements, however, the intensity of the populist elements are mild.
Two of the elements of populist rhetoric are present, people-centric and anti-elite, and while the speech is Manichean to the extent that the speech frames the relationship as conflictual, I would argue the speech is quite tame in its language, meaning that the Manichean element is not entirely present. The speech is populist, but not highly populist.
Grade: 1.0"

# Barack Obama (step 7) #
step_7_user <-  "Read the speech and code the level of populism (0-2 to the tenth place):

<speech>
The White House
Office of the Press Secretary
For Immediate Release
January 27, 2010
Remarks by the President in State of the Union Address
U.S. Capitol
9:11 P.M. EST
THE PRESIDENT:  Madam Speaker, Vice President Biden, members of Congress, distinguished guests, and fellow Americans:
Our Constitution declares that from time to time, the President shall give to Congress information about the state of our union.  For 220 years, our leaders have fulfilled this duty. They've done so during periods of prosperity and tranquility.  And they've done so in the midst of war and depression; at moments of great strife and great struggle.
It's tempting to look back on these moments and assume that our progress was inevitable -– that America was always destined to succeed.  But when the Union was turned back at Bull Run, and the Allies first landed at Omaha Beach, victory was very much in doubt.  When the market crashed on Black Tuesday, and civil rights marchers were beaten on Bloody Sunday, the future was anything but certain.  These were the times that tested the courage of our convictions, and the strength of our union.  And despite all our divisions and disagreements, our hesitations and our fears, America prevailed because we chose to move forward as one nation, as one people. 
Again, we are tested.  And again, we must answer history's call.
One year ago, I took office amid two wars, an economy rocked by a severe recession, a financial system on the verge of collapse, and a government deeply in debt.  Experts from across the political spectrum warned that if we did not act, we might face a second depression.  So we acted -– immediately and aggressively.  And one year later, the worst of the storm has passed.
But the devastation remains.  One in 10 Americans still cannot find work.  Many businesses have shuttered.  Home values have declined.  Small towns and rural communities have been hit especially hard.  And for those who'd already known poverty, life has become that much harder.
This recession has also compounded the burdens that America's families have been dealing with for decades –- the burden of working harder and longer for less; of being unable to save enough to retire or help kids with college. 
So I know the anxieties that are out there right now.  They're not new.  These struggles are the reason I ran for President.  These struggles are what I've witnessed for years in places like Elkhart, Indiana; Galesburg, Illinois.  I hear about them in the letters that I read each night.  The toughest to read are those written by children -– asking why they have to move from their home, asking when their mom or dad will be able to go back to work.
For these Americans and so many others, change has not come fast enough.  Some are frustrated; some are angry.  They don't understand why it seems like bad behavior on Wall Street is rewarded, but hard work on Main Street isn't; or why Washington has been unable or unwilling to solve any of our problems.  They're tired of the partisanship and the shouting and the pettiness.  They know we can't afford it.  Not now.  
So we face big and difficult challenges.  And what the American people hope -– what they deserve -– is for all of us, Democrats and Republicans, to work through our differences; to overcome the numbing weight of our politics.  For while the people who sent us here have different backgrounds, different stories, different beliefs, the anxieties they face are the same. The aspirations they hold are shared:  a job that pays the bills; a chance to get ahead; most of all, the ability to give their children a better life. 
You know what else they share?  They share a stubborn resilience in the face of adversity.  After one of the most difficult years in our history, they remain busy building cars and teaching kids, starting businesses and going back to school. They're coaching Little League and helping their neighbors.  One woman wrote to me and said, 'We are strained but hopeful, struggling but encouraged.' 
It's because of this spirit -– this great decency and great strength -– that I have never been more hopeful about America's future than I am tonight.  (Applause.)  Despite our hardships, our union is strong.  We do not give up.  We do not quit.  We do not allow fear or division to break our spirit.  In this new decade, it's time the American people get a government that matches their decency; that embodies their strength.  (Applause.)	
 And tonight, tonight I'd like to talk about how together we can deliver on that promise.   
It begins with our economy. 
Our most urgent task upon taking office was to shore up the same banks that helped cause this crisis.  It was not easy to do. And if there's one thing that has unified Democrats and Republicans, and everybody in between, it's that we all hated the bank bailout.  I hated it -- (applause.)  I hated it.  You hated it.  It was about as popular as a root canal.  (Laughter.)  
But when I ran for President, I promised I wouldn't just do what was popular -– I would do what was necessary.  And if we had allowed the meltdown of the financial system, unemployment might be double what it is today.  More businesses would certainly have closed.  More homes would have surely been lost. 
So I supported the last administration's efforts to create the financial rescue program.  And when we took that program over, we made it more transparent and more accountable.  And as a result, the markets are now stabilized, and we've recovered most of the money we spent on the banks.  (Applause.)  Most but not all.
To recover the rest, I've proposed a fee on the biggest banks.  (Applause.)  Now, I know Wall Street isn't keen on this idea.  But if these firms can afford to hand out big bonuses again, they can afford a modest fee to pay back the taxpayers who rescued them in their time of need.  (Applause.)
Now, as we stabilized the financial system, we also took steps to get our economy growing again, save as many jobs as possible, and help Americans who had become unemployed. 
That's why we extended or increased unemployment benefits for more than 18 million Americans; made health insurance 65 percent cheaper for families who get their coverage through COBRA; and passed 25 different tax cuts.
Now, let me repeat:  We cut taxes.  We cut taxes for 95 percent of working families.  (Applause.)  We cut taxes for small businesses.  We cut taxes for first-time homebuyers.  We cut taxes for parents trying to care for their children.  We cut taxes for 8 million Americans paying for college.  (Applause.)
I thought I'd get some applause on that one.  (Laughter and applause.)
As a result, millions of Americans had more to spend on gas and food and other necessities, all of which helped businesses keep more workers.  And we haven't raised income taxes by a single dime on a single person.  Not a single dime.  (Applause.)
Because of the steps we took, there are about two million Americans working right now who would otherwise be unemployed.  (Applause.)  Two hundred thousand work in construction and clean energy; 300,000 are teachers and other education workers.  Tens of thousands are cops, firefighters, correctional officers, first responders.  (Applause.)  And we're on track to add another one and a half million jobs to this total by the end of the year.
The plan that has made all of this possible, from the tax cuts to the jobs, is the Recovery Act.  (Applause.)  That's right -– the Recovery Act, also known as the stimulus bill.  (Applause.)  Economists on the left and the right say this bill has helped save jobs and avert disaster.  But you don't have to take their word for it.  Talk to the small business in Phoenix that will triple its workforce because of the Recovery Act.  Talk to the window manufacturer in Philadelphia who said he used to be skeptical about the Recovery Act, until he had to add two more work shifts just because of the business it created.  Talk to the single teacher raising two kids who was told by her principal in the last week of school that because of the Recovery Act, she wouldn't be laid off after all. 
There are stories like this all across America.  And after two years of recession, the economy is growing again.  Retirement funds have started to gain back some of their value.  Businesses are beginning to invest again, and slowly some are starting to hire again.   
But I realize that for every success story, there are other stories, of men and women who wake up with the anguish of not knowing where their next paycheck will come from; who send out resumes week after week and hear nothing in response.  That is why jobs must be our number-one focus in 2010, and that's why I'm calling for a new jobs bill tonight.  (Applause.)  
Now, the true engine of job creation in this country will always be America's businesses.  (Applause.)  But government can create the conditions necessary for businesses to expand and hire more workers. 
We should start where most new jobs do –- in small businesses, companies that begin when -- (applause) -- companies that begin when an entrepreneur -- when an entrepreneur takes a chance on a dream, or a worker decides it's time she became her own boss.  Through sheer grit and determination, these companies have weathered the recession and they're ready to grow.  But when you talk to small businessowners in places like Allentown, Pennsylvania, or Elyria, Ohio, you find out that even though banks on Wall Street are lending again, they're mostly lending to bigger companies.  Financing remains difficult for small businessowners across the country, even those that are making a profit.
So tonight, I'm proposing that we take $30 billion of the money Wall Street banks have repaid and use it to help community banks give small businesses the credit they need to stay afloat. (Applause.)  I'm also proposing a new small business tax credit
 -– one that will go to over one million small businesses who hire new workers or raise wages.  (Applause.)  While we're at it, let's also eliminate all capital gains taxes on small business investment, and provide a tax incentive for all large businesses and all small businesses to invest in new plants and equipment.  (Applause.) 
Next, we can put Americans to work today building the infrastructure of tomorrow.  (Applause.)  From the first railroads to the Interstate Highway System, our nation has always been built to compete.  There's no reason Europe or China should have the fastest trains, or the new factories that manufacture clean energy products.
Tomorrow, I'll visit Tampa, Florida, where workers will soon break ground on a new high-speed railroad funded by the Recovery Act.  (Applause.)  There are projects like that all across this country that will create jobs and help move our nation's goods, services, and information.  (Applause.) 
We should put more Americans to work building clean energy facilities -- (applause) -- and give rebates to Americans who make their homes more energy-efficient, which supports clean energy jobs.  (Applause.)  And to encourage these and other businesses to stay within our borders, it is time to finally slash the tax breaks for companies that ship our jobs overseas, and give those tax breaks to companies that create jobs right here in the United States of America.  (Applause.)
Now, the House has passed a jobs bill that includes some of these steps.  (Applause.)  As the first order of business this year, I urge the Senate to do the same, and I know they will.  (Applause.)  They will.  (Applause.)  People are out of work.  They're hurting.  They need our help.  And I want a jobs bill on my desk without delay.  (Applause.)
But the truth is, these steps won't make up for the seven million jobs that we've lost over the last two years.  The only way to move to full employment is to lay a new foundation for long-term economic growth, and finally address the problems that America's families have confronted for years.  
We can't afford another so-called economic 'expansion' like the one from the last decade –- what some call the 'lost decade' -– where jobs grew more slowly than during any prior expansion; where the income of the average American household declined while the cost of health care and tuition reached record highs; where prosperity was built on a housing bubble and financial speculation. 
From the day I took office, I've been told that addressing our larger challenges is too ambitious; such an effort would be too contentious.  I've been told that our political system is too gridlocked, and that we should just put things on hold for a while. 
For those who make these claims, I have one simple question: How long should we wait?  How long should America put its future on hold?  (Applause.)
You see, Washington has been telling us to wait for decades, even as the problems have grown worse.  Meanwhile, China is not waiting to revamp its economy.  Germany is not waiting.  India is not waiting.  These nations -- they're not standing still.  These nations aren't playing for second place.  They're putting more emphasis on math and science.  They're rebuilding their infrastructure.  They're making serious investments in clean energy because they want those jobs.  Well, I do not accept second place for the United States of America.  (Applause.) 
As hard as it may be, as uncomfortable and contentious as the debates may become, it's time to get serious about fixing the problems that are hampering our growth.
Now, one place to start is serious financial reform.  Look, I am not interested in punishing banks.  I'm interested in protecting our economy.  A strong, healthy financial market makes it possible for businesses to access credit and create new jobs. It channels the savings of families into investments that raise incomes.  But that can only happen if we guard against the same recklessness that nearly brought down our entire economy. 
We need to make sure consumers and middle-class families have the information they need to make financial decisions.  (Applause.)  We can't allow financial institutions, including those that take your deposits, to take risks that threaten the whole economy.  
Now, the House has already passed financial reform with many of these changes.  (Applause.)  And the lobbyists are trying to kill it.  But we cannot let them win this fight.  (Applause.)  And if the bill that ends up on my desk does not meet the test of real reform, I will send it back until we get it right.  We've got to get it right.  (Applause.)
Next, we need to encourage American innovation.  Last year, we made the largest investment in basic research funding in history -– (applause) -- an investment that could lead to the world's cheapest solar cells or treatment that kills cancer cells but leaves healthy ones untouched.  And no area is more ripe for such innovation than energy.  You can see the results of last year's investments in clean energy -– in the North Carolina company that will create 1,200 jobs nationwide helping to make advanced batteries; or in the California business that will put a thousand people to work making solar panels.
But to create more of these clean energy jobs, we need more production, more efficiency, more incentives.  And that means building a new generation of safe, clean nuclear power plants in this country.  (Applause.)  It means making tough decisions about opening new offshore areas for oil and gas development.  (Applause.)  It means continued investment in advanced biofuels and clean coal technologies.  (Applause.)  And, yes, it means passing a comprehensive energy and climate bill with incentives that will finally make clean energy the profitable kind of energy in America.  (Applause.)
I am grateful to the House for passing such a bill last year.  (Applause.)  And this year I'm eager to help advance the bipartisan effort in the Senate.  (Applause.) 
I know there have been questions about whether we can afford such changes in a tough economy.  I know that there are those who disagree with the overwhelming scientific evidence on climate change.  But here's the thing -- even if you doubt the evidence, providing incentives for energy-efficiency and clean energy are the right thing to do for our future -– because the nation that leads the clean energy economy will be the nation that leads the global economy.  And America must be that nation.  (Applause.)
Third, we need to export more of our goods.  (Applause.)  Because the more products we make and sell to other countries, the more jobs we support right here in America.  (Applause.)  So tonight, we set a new goal:  We will double our exports over the next five years, an increase that will support two million jobs in America.  (Applause.)  To help meet this goal, we're launching a National Export Initiative that will help farmers and small businesses increase their exports, and reform export controls consistent with national security.  (Applause.)
We have to seek new markets aggressively, just as our competitors are.  If America sits on the sidelines while other nations sign trade deals, we will lose the chance to create jobs on our shores.  (Applause.)  But realizing those benefits also means enforcing those agreements so our trading partners play by the rules.  (Applause.)  And that's why we'll continue to shape a Doha trade agreement that opens global markets, and why we will strengthen our trade relations in Asia and with key partners like South Korea and Panama and Colombia.  (Applause.)
Fourth, we need to invest in the skills and education of our people.  (Applause.)
Now, this year, we've broken through the stalemate between left and right by launching a national competition to improve our schools.  And the idea here is simple:  Instead of rewarding failure, we only reward success.  Instead of funding the status quo, we only invest in reform -- reform that raises student achievement; inspires students to excel in math and science; and turns around failing schools that steal the future of too many young Americans, from rural communities to the inner city.  In the 21st century, the best anti-poverty program around is a world-class education.  (Applause.)  And in this country, the success of our children cannot depend more on where they live than on their potential. 
When we renew the Elementary and Secondary Education Act, we will work with Congress to expand these reforms to all 50 states.  Still, in this economy, a high school diploma no longer guarantees a good job.  That's why I urge the Senate to follow the House and pass a bill that will revitalize our community colleges, which are a career pathway to the children of so many working families.  (Applause.) 
To make college more affordable, this bill will finally end the unwarranted taxpayer subsidies that go to banks for student loans.  (Applause.)  Instead, let's take that money and give families a $10,000 tax credit for four years of college and increase Pell Grants.  (Applause.)  And let's tell another one million students that when they graduate, they will be required to pay only 10 percent of their income on student loans, and all of their debt will be forgiven after 20 years –- and forgiven after 10 years if they choose a career in public service, because in the United States of America, no one should go broke because they chose to go to college.  (Applause.) 
And by the way, it's time for colleges and universities to get serious about cutting their own costs -– (applause) -- because they, too, have a responsibility to help solve this problem. 
Now, the price of college tuition is just one of the burdens facing the middle class.  That's why last year I asked Vice President Biden to chair a task force on middle-class families.  That's why we're nearly doubling the child care tax credit, and making it easier to save for retirement by giving access to every worker a retirement account and expanding the tax credit for those who start a nest egg.  That's why we're working to lift the value of a family's single largest investment –- their home.  The steps we took last year to shore up the housing market have allowed millions of Americans to take out new loans and save an average of $1,500 on mortgage payments.     
This year, we will step up refinancing so that homeowners can move into more affordable mortgages.  (Applause.)  And it is precisely to relieve the burden on middle-class families that we still need health insurance reform.  (Applause.)  Yes, we do.  (Applause.)
Now, let's clear a few things up.  (Laughter.)  I didn't choose to tackle this issue to get some legislative victory under my belt.  And by now it should be fairly obvious that I didn't take on health care because it was good politics.  (Laughter.)  I took on health care because of the stories I've heard from Americans with preexisting conditions whose lives depend on getting coverage; patients who've been denied coverage; families –- even those with insurance -– who are just one illness away from financial ruin.
After nearly a century of trying -- Democratic administrations, Republican administrations -- we are closer than ever to bringing more security to the lives of so many Americans.  The approach we've taken would protect every American from the worst practices of the insurance industry.  It would give small businesses and uninsured Americans a chance to choose an affordable health care plan in a competitive market.  It would require every insurance plan to cover preventive care. 
And by the way, I want to acknowledge our First Lady, Michelle Obama, who this year is creating a national movement to tackle the epidemic of childhood obesity and make kids healthier. (Applause.)  Thank you.  She gets embarrassed.  (Laughter.)
Our approach would preserve the right of Americans who have insurance to keep their doctor and their plan.  It would reduce costs and premiums for millions of families and businesses.  And according to the Congressional Budget Office -– the independent organization that both parties have cited as the official scorekeeper for Congress –- our approach would bring down the deficit by as much as $1 trillion over the next two decades.  (Applause.)
Still, this is a complex issue, and the longer it was debated, the more skeptical people became.  I take my share of the blame for not explaining it more clearly to the American people.  And I know that with all the lobbying and horse-trading, the process left most Americans wondering, 'What's in it for me?'
But I also know this problem is not going away.  By the time I'm finished speaking tonight, more Americans will have lost their health insurance.  Millions will lose it this year.  Our deficit will grow.  Premiums will go up.  Patients will be denied the care they need.  Small business owners will continue to drop coverage altogether.  I will not walk away from these Americans, and neither should the people in this chamber.  (Applause.)
So, as temperatures cool, I want everyone to take another look at the plan we've proposed.  There's a reason why many doctors, nurses, and health care experts who know our system best consider this approach a vast improvement over the status quo.  But if anyone from either party has a better approach that will bring down premiums, bring down the deficit, cover the uninsured, strengthen Medicare for seniors, and stop insurance company abuses, let me know.  (Applause.)  Let me know.  Let me know.  (Applause.)  I'm eager to see it. 
Here's what I ask Congress, though:  Don't walk away from reform.  Not now.  Not when we are so close.  Let us find a way to come together and finish the job for the American people.  (Applause.)  Let's get it done.  Let's get it done.  (Applause.)
Now, even as health care reform would reduce our deficit, it's not enough to dig us out of a massive fiscal hole in which we find ourselves.  It's a challenge that makes all others that much harder to solve, and one that's been subject to a lot of political posturing.  So let me start the discussion of government spending by setting the record straight. 
At the beginning of the last decade, the year 2000, America had a budget surplus of over $200 billion.  (Applause.)  By the time I took office, we had a one-year deficit of over $1 trillion and projected deficits of $8 trillion over the next decade.  Most of this was the result of not paying for two wars, two tax cuts, and an expensive prescription drug program.  On top of that, the effects of the recession put a $3 trillion hole in our budget.  All this was before I walked in the door.  (Laughter and applause.)
Now -- just stating the facts.  Now, if we had taken office in ordinary times, I would have liked nothing more than to start bringing down the deficit.  But we took office amid a crisis.  And our efforts to prevent a second depression have added another $1 trillion to our national debt.  That, too, is a fact.
I'm absolutely convinced that was the right thing to do.  But families across the country are tightening their belts and making tough decisions.  The federal government should do the same.  (Applause.)  So tonight, I'm proposing specific steps to pay for the trillion dollars that it took to rescue the economy last year.
Starting in 2011, we are prepared to freeze government spending for three years.  (Applause.)  Spending related to our national security, Medicare, Medicaid, and Social Security will not be affected.  But all other discretionary government programs will.  Like any cash-strapped family, we will work within a budget to invest in what we need and sacrifice what we don't.  And if I have to enforce this discipline by veto, I will.  (Applause.)  
We will continue to go through the budget, line by line, page by page, to eliminate programs that we can't afford and don't work.  We've already identified $20 billion in savings for next year.  To help working families, we'll extend our middle-class tax cuts.  But at a time of record deficits, we will not continue tax cuts for oil companies, for investment fund managers, and for those making over $250,000 a year.  We just can't afford it.  (Applause.) 
Now, even after paying for what we spent on my watch, we'll still face the massive deficit we had when I took office.  More importantly, the cost of Medicare, Medicaid, and Social Security will continue to skyrocket.  That's why I've called for a bipartisan fiscal commission, modeled on a proposal by Republican Judd Gregg and Democrat Kent Conrad.  (Applause.)  This can't be one of those Washington gimmicks that lets us pretend we solved a problem.  The commission will have to provide a specific set of solutions by a certain deadline. 
Now, yesterday, the Senate blocked a bill that would have created this commission.  So I'll issue an executive order that will allow us to go forward, because I refuse to pass this problem on to another generation of Americans.  (Applause.)  And when the vote comes tomorrow, the Senate should restore the pay-as-you-go law that was a big reason for why we had record surpluses in the 1990s.  (Applause.) 
  
Now, I know that some in my own party will argue that we can't address the deficit or freeze government spending when so many are still hurting.  And I agree -- which is why this freeze won't take effect until next year -- (laughter) -- when the economy is stronger.  That's how budgeting works.  (Laughter and applause.)  But understand –- understand if we don't take meaningful steps to rein in our debt, it could damage our markets, increase the cost of borrowing, and jeopardize our recovery -– all of which would have an even worse effect on our job growth and family incomes. 
From some on the right, I expect we'll hear a different argument -– that if we just make fewer investments in our people, extend tax cuts including those for the wealthier Americans, eliminate more regulations, maintain the status quo on health care, our deficits will go away.  The problem is that's what we did for eight years.  (Applause.)  That's what helped us into this crisis.  It's what helped lead to these deficits.  We can't do it again.
Rather than fight the same tired battles that have dominated Washington for decades, it's time to try something new.  Let's invest in our people without leaving them a mountain of debt.  Let's meet our responsibility to the citizens who sent us here.  Let's try common sense.  (Laughter.)  A novel concept.
To do that, we have to recognize that we face more than a deficit of dollars right now.  We face a deficit of trust -– deep and corrosive doubts about how Washington works that have been growing for years.  To close that credibility gap we have to take action on both ends of Pennsylvania Avenue -- to end the outsized influence of lobbyists; to do our work openly; to give our people the government they deserve.  (Applause.)
That's what I came to Washington to do.  That's why -– for the first time in history –- my administration posts on our White House visitors online.  That's why we've excluded lobbyists from policymaking jobs, or seats on federal boards and commissions.
But we can't stop there.  It's time to require lobbyists to disclose each contact they make on behalf of a client with my administration or with Congress.  It's time to put strict limits on the contributions that lobbyists give to candidates for federal office. 
With all due deference to separation of powers, last week the Supreme Court reversed a century of law that I believe will open the floodgates for special interests –- including foreign corporations –- to spend without limit in our elections.  (Applause.)  I don't think American elections should be bankrolled by America's most powerful interests, or worse, by foreign entities.  (Applause.)  They should be decided by the American people.  And I'd urge Democrats and Republicans to pass a bill that helps to correct some of these problems.
I'm also calling on Congress to continue down the path of earmark reform.  Applause.)  Democrats and Republicans.  (Applause.)  Democrats and Republicans.  You've trimmed some of this spending, you've embraced some meaningful change.  But restoring the public trust demands more.  For example, some members of Congress post some earmark requests online.  (Applause.)  Tonight, I'm calling on Congress to publish all earmark requests on a single Web site before there's a vote, so that the American people can see how their money is being spent. (Applause.)
Of course, none of these reforms will even happen if we don't also reform how we work with one another.  Now, I'm not naïve.  I never thought that the mere fact of my election would usher in peace and harmony -- (laughter) -- and some post-partisan era.  I knew that both parties have fed divisions that are deeply entrenched.  And on some issues, there are simply philosophical differences that will always cause us to part ways. These disagreements, about the role of government in our lives, about our national priorities and our national security, they've been taking place for over 200 years.  They're the very essence of our democracy.
But what frustrates the American people is a Washington where every day is Election Day.  We can't wage a perpetual campaign where the only goal is to see who can get the most embarrassing headlines about the other side -– a belief that if you lose, I win.  Neither party should delay or obstruct every single bill just because they can.  The confirmation of -- (applause) -- I'm speaking to both parties now.  The confirmation of well-qualified public servants shouldn't be held hostage to the pet projects or grudges of a few individual senators.  (Applause.) 
Washington may think that saying anything about the other side, no matter how false, no matter how malicious, is just part of the game.  But it's precisely such politics that has stopped either party from helping the American people.  Worse yet, it's sowing further division among our citizens, further distrust in our government.
So, no, I will not give up on trying to change the tone of our politics.  I know it's an election year.  And after last week, it's clear that campaign fever has come even earlier than usual.  But we still need to govern. 
To Democrats, I would remind you that we still have the largest majority in decades, and the people expect us to solve problems, not run for the hills.  (Applause.)  And if the Republican leadership is going to insist that 60 votes in the Senate are required to do any business at all in this town -- a supermajority -- then the responsibility to govern is now yours as well.  (Applause.)  Just saying no to everything may be good short-term politics, but it's not leadership.  We were sent here to serve our citizens, not our ambitions.  (Applause.)  So let's show the American people that we can do it together.  (Applause.)
This week, I'll be addressing a meeting of the House Republicans.  I'd like to begin monthly meetings with both Democratic and Republican leadership.  I know you can't wait.  (Laughter.)
Throughout our history, no issue has united this country more than our security.  Sadly, some of the unity we felt after 9/11 has dissipated.  We can argue all we want about who's to blame for this, but I'm not interested in re-litigating the past. I know that all of us love this country.  All of us are committed to its defense.  So let's put aside the schoolyard taunts about who's tough.  Let's reject the false choice between protecting our people and upholding our values.  Let's leave behind the fear and division, and do what it takes to defend our nation and forge a more hopeful future -- for America and for the world.  (Applause.)
That's the work we began last year.  Since the day I took office, we've renewed our focus on the terrorists who threaten our nation.  We've made substantial investments in our homeland security and disrupted plots that threatened to take American lives.  We are filling unacceptable gaps revealed by the failed Christmas attack, with better airline security and swifter action on our intelligence.  We've prohibited torture and strengthened partnerships from the Pacific to South Asia to the Arabian Peninsula.  And in the last year, hundreds of al Qaeda's fighters and affiliates, including many senior leaders, have been captured or killed -- far more than in 2008.
And in Afghanistan, we're increasing our troops and training Afghan security forces so they can begin to take the lead in July of 2011, and our troops can begin to come home.  (Applause.)  We will reward good governance, work to reduce corruption, and support the rights of all Afghans -- men and women alike.  (Applause.)  We're joined by allies and partners who have increased their own commitments, and who will come together tomorrow in London to reaffirm our common purpose.  There will be difficult days ahead.  But I am absolutely confident we will succeed.
As we take the fight to al Qaeda, we are responsibly leaving Iraq to its people.  As a candidate, I promised that I would end this war, and that is what I am doing as President.  We will have all of our combat troops out of Iraq by the end of this August.  (Applause.)  We will support the Iraqi government -- we will support the Iraqi government as they hold elections, and we will continue to partner with the Iraqi people to promote regional peace and prosperity.  But make no mistake:  This war is ending, and all of our troops are coming home.  (Applause.)   
Tonight, all of our men and women in uniform -- in Iraq, in Afghanistan, and around the world –- they have to know that we -- that they have our respect, our gratitude, our full support.  And just as they must have the resources they need in war, we all have a responsibility to support them when they come home.  (Applause.)  That's why we made the largest increase in investments for veterans in decades -- last year.  (Applause.)   That's why we're building a 21st century VA.  And that's why Michelle has joined with Jill Biden to forge a national commitment to support military families.  (Applause.)
Now, even as we prosecute two wars, we're also confronting perhaps the greatest danger to the American people -– the threat of nuclear weapons.  I've embraced the vision of John F. Kennedy and Ronald Reagan through a strategy that reverses the spread of these weapons and seeks a world without them.  To reduce our stockpiles and launchers, while ensuring our deterrent, the United States and Russia are completing negotiations on the farthest-reaching arms control treaty in nearly two decades.  (Applause.)  And at April's Nuclear Security Summit, we will bring 44 nations together here in Washington, D.C. behind a clear goal:  securing all vulnerable nuclear materials around the world in four years, so that they never fall into the hands of terrorists.  (Applause.)
Now, these diplomatic efforts have also strengthened our hand in dealing with those nations that insist on violating international agreements in pursuit of nuclear weapons.  That's why North Korea now faces increased isolation, and stronger sanctions –- sanctions that are being vigorously enforced.  That's why the international community is more united, and the Islamic Republic of Iran is more isolated.  And as Iran's leaders continue to ignore their obligations, there should be no doubt:  They, too, will face growing consequences.  That is a promise.  (Applause.)
That's the leadership that we are providing –- engagement that advances the common security and prosperity of all people. We're working through the G20 to sustain a lasting global recovery.  We're working with Muslim communities around the world to promote science and education and innovation.  We have gone from a bystander to a leader in the fight against climate change. We're helping developing countries to feed themselves, and continuing the fight against HIV/AIDS.  And we are launching a new initiative that will give us the capacity to respond faster and more effectively to bioterrorism or an infectious disease -– a plan that will counter threats at home and strengthen public health abroad.
As we have for over 60 years, America takes these actions because our destiny is connected to those beyond our shores.  But we also do it because it is right.  That's why, as we meet here tonight, over 10,000 Americans are working with many nations to help the people of Haiti recover and rebuild.  (Applause.)  That's why we stand with the girl who yearns to go to school in Afghanistan; why we support the human rights of the women marching through the streets of Iran; why we advocate for the young man denied a job by corruption in Guinea.  For America must always stand on the side of freedom and human dignity.  (Applause.)  Always.  (Applause.)
Abroad, America's greatest source of strength has always been our ideals.  The same is true at home.  We find unity in our incredible diversity, drawing on the promise enshrined in our Constitution:  the notion that we're all created equal; that no matter who you are or what you look like, if you abide by the law you should be protected by it; if you adhere to our common values you should be treated no different than anyone else.    
We must continually renew this promise.  My administration has a Civil Rights Division that is once again prosecuting civil rights violations and employment discrimination.  (Applause.)  We finally strengthened our laws to protect against crimes driven by hate.  (Applause.)  This year, I will work with Congress and our military to finally repeal the law that denies gay Americans the right to serve the country they love because of who they are.  (Applause.)  It's the right thing to do.  (Applause.)  
We're going to crack down on violations of equal pay laws -– so that women get equal pay for an equal day's work.  (Applause.) And we should continue the work of fixing our broken immigration system -– to secure our borders and enforce our laws, and ensure that everyone who plays by the rules can contribute to our economy and enrich our nation.  (Applause.)
In the end, it's our ideals, our values that built America  -- values that allowed us to forge a nation made up of immigrants from every corner of the globe; values that drive our citizens still.  Every day, Americans meet their responsibilities to their families and their employers.  Time and again, they lend a hand to their neighbors and give back to their country.  They take pride in their labor, and are generous in spirit.  These aren't Republican values or Democratic values that they're living by; business values or labor values.  They're American values.  
Unfortunately, too many of our citizens have lost faith that our biggest institutions -– our corporations, our media, and, yes, our government –- still reflect these same values.  Each of these institutions are full of honorable men and women doing important work that helps our country prosper.  But each time a CEO rewards himself for failure, or a banker puts the rest of us at risk for his own selfish gain, people's doubts grow.  Each time lobbyists game the system or politicians tear each other down instead of lifting this country up, we lose faith.  The more that TV pundits reduce serious debates to silly arguments, big issues into sound bites, our citizens turn away.  
No wonder there's so much cynicism out there.  No wonder there's so much disappointment. 
I campaigned on the promise of change –- change we can believe in, the slogan went.  And right now, I know there are many Americans who aren't sure if they still believe we can change –- or that I can deliver it. 
But remember this –- I never suggested that change would be easy, or that I could do it alone.  Democracy in a nation of 300 million people can be noisy and messy and complicated.  And when you try to do big things and make big changes, it stirs passions and controversy.  That's just how it is.
Those of us in public office can respond to this reality by playing it safe and avoid telling hard truths and pointing fingers.  We can do what's necessary to keep our poll numbers high, and get through the next election instead of doing what's best for the next generation. 
But I also know this:  If people had made that decision 50 years ago, or 100 years ago, or 200 years ago, we wouldn't be here tonight.  The only reason we are here is because generations of Americans were unafraid to do what was hard; to do what was needed even when success was uncertain; to do what it took to keep the dream of this nation alive for their children and their grandchildren.
Our administration has had some political setbacks this year, and some of them were deserved.  But I wake up every day knowing that they are nothing compared to the setbacks that families all across this country have faced this year.  And what keeps me going -– what keeps me fighting -– is that despite all these setbacks, that spirit of determination and optimism, that fundamental decency that has always been at the core of the American people, that lives on.   
It lives on in the struggling small business owner who wrote to me of his company, 'None of us,' he said, '…are willing to consider, even slightly, that we might fail.'
It lives on in the woman who said that even though she and her neighbors have felt the pain of recession, 'We are strong.  We are resilient.  We are American.'
It lives on in the 8-year-old boy in Louisiana, who just sent me his allowance and asked if I would give it to the people of Haiti. 
And it lives on in all the Americans who've dropped everything to go someplace they've never been and pull people they've never known from the rubble, prompting chants of 'U.S.A.! U.S.A.!  U.S.A!' when another life was saved. 
The spirit that has sustained this nation for more than two centuries lives on in you, its people.  We have finished a difficult year.  We have come through a difficult decade.  But a new year has come.  A new decade stretches before us.  We don't quit.  I don't quit.  (Applause.)  Let's seize this moment -- to start anew, to carry the dream forward, and to strengthen our union once more.  (Applause.)
Thank you.  God bless you.  And God bless the United States of America. 
</speech>
"

# Obama Grade #
step_7_ast <- "Here is my thought process for grading this speech.

Obama’s speech includes a modest people-centric element, but it is firmly rooted in pluralist and pragmatic language. He frequently refers to the struggles of “hard-working Americans,” families trying to make ends meet, and small business owners weathering the recession. He highlights stories from “Elkhart, Indiana,” “Galesburg, Illinois,” and even quotes letters from children and struggling parents. However, he does not construct “the people” as a unified, morally superior actor whose will must dominate politics. Instead, he emphasizes diversity: Americans have “different backgrounds, different stories, different beliefs.” The moral tone is empathetic, but not sacralizing. The people are valued as the subjects and beneficiaries of public policy, not as the singular source of political legitimacy. Thus, while the speech draws emotional strength from its connection to ordinary Americans, it does not fulfill the populist criterion of a righteous, homogenous 'people.'
The anti-elite critique in the speech is present, but diffuse and non-essential. Obama takes clear aim at Wall Street behavior, criticizing banks that “hand out big bonuses” after being rescued by taxpayers, and CEOs who “reward themselves for failure.” He also critiques lobbyists, special interests, and the recent Supreme Court decision that opened the door to greater corporate spending in elections. Yet, this elite is not framed as a singular, evil group intentionally subverting democracy. Obama explicitly notes that institutions like corporations, the media, and even government are “full of honorable men and women.” His criticisms are functional, not moralistic; institutional, not conspiratorial. The elite is not cast as an existential threat to the people, but rather as a powerful actor whose actions must be checked and reformed within the bounds of democratic norms. This keeps the anti-elite element from crossing into populist territory.
The Manichaean dimension is largely absent. Obama does not present politics as a binary battle between good and evil, or the people versus a corrupt elite. Instead, he emphasizes cooperation, compromise, and shared responsibility. He frames America’s history as one of resilience in the face of uncertainty, and repeatedly appeals to bipartisan collaboration. There are no apocalyptic warnings, no claims of betrayal or moral decay. Even his sharpest critiques are embedded in a framework of reform and renewal rather than confrontation. While he expresses urgency and frustration with the pace of change, he remains measured in tone and hopeful in outlook. This absence of cosmic or dualistic framing clearly distinguishes the speech from the high-stakes, polarized narratives common to populist discourse.
Finally, the speech is strongly pluralist, both in substance and rhetoric. Obama repeatedly affirms institutional integrity, democratic procedures, and the importance of working across partisan divides. He invokes a “deficit of trust,” not to discredit institutions, but to argue for greater transparency and accountability through institutional reforms. His policy agenda—ranging from health care and education to tax reform and infrastructure—is pragmatic and technocratic. He supports oversight mechanisms, bipartisan commissions, and legislation crafted through deliberation and compromise. There is no call to bypass or upend the rules of the game; rather, he seeks to make them work better. The speech exudes faith in the capacity of democratic institutions to respond to crises and enact meaningful change—hallmarks of pluralist political discourse.
The speech registers slightly above 0.0 on the populism scale—perhaps around 0.3—due to limited elite critique and rhetorical alignment with popular suffering. However, it remains fundamentally pluralist and pragmatic, eschewing populist structure and tone in favor of inclusive, institutional discourse.
Here is the coding for populism in the Barack Obama speech:
Populist element in Obama’s speech

Manichaean Vision of the World (Category 1):
 
Speech quotes:
For these Americans and so many others, change has not come fast enough.  Some are frustrated; some are angry.  They don't understand why it seems like bad behavior on Wall Street is rewarded, but hard work on Main Street isn't; or why Washington has been unable or unwilling to solve any of our problems.
Cosmic Proportions and Historical Reification (Category 2):
 
No quotes: 

Populist notion of the people (Category 3):
 
No quotes: 

The Elite as a Conspiring Evil (Category 4):
 
Speech quotes: 
For these Americans and so many others, change has not come fast enough.  Some are frustrated; some are angry.  They don't understand why it seems like bad behavior on Wall Street is rewarded, but hard work on Main Street isn't; or why Washington has been unable or unwilling to solve any of our problems.

Systemic Change (Category 5):
 
No quotes: 

Anything goes attitude (Category 6):

No quotes: 
Non-Populist element in Obama’s Discourse
Category 1: Pluralist vision of the world

Speech quotes
'We can either settle for a country where a shrinking number of people do really well while a growing number of Americans barely get by, or we can restore an economy where everyone gets a fair shot, and everyone does their fair share, and everyone plays by the same set of rules.  (Applause.)  What’s at stake aren’t Democratic values or Republican values, but American values.  And we have to reclaim them.'
Category 2: Concrete interpretation of political issues

Speech quotes:

'In 2008, the house of cards collapsed.  We learned that mortgages had been sold to people who couldn’t afford or understand them.  Banks had made huge bets and bonuses with other people’s money.  Regulators had looked the other way, or didn’t have the authority to stop the bad behavior.'

'It was wrong.  It was irresponsible.  And it plunged our economy into a crisis that put millions out of work, saddled us with more debt, and left innocent, hardworking Americans holding the bag.  In the six months before I took office, we lost nearly 4 million jobs.  And we lost another 4 million before our policies were in full effect.'

'Those are the facts.  But so are these:  In the last 22 months, businesses have created more than 3 million jobs.'
Category 3: Democracy as calculation of votes of individual citizens

Speech quotes:

'Let’s also remember that hundreds of thousands of talented, hardworking students in this country face another challenge:  the fact that they aren’t yet American citizens.  Many were brought here as small children, are American through and through, yet they live every day with the threat of deportation.'
Category 4: Non-antagonistic view of opponents

Speech quotes:

'Some of this has to do with the corrosive influence of money in politics.  So together, let’s take some steps to fix that.  Send me a bill that bans insider trading by members of Congress; I will sign it tomorrow.
Category 5: Incremental reform

Speech quotes:

'Tonight, I’m announcing the creation of a Trade Enforcement Unit that will be charged with investigating unfair trading practices in countries like China.  (Applause.)  There will be more inspections to prevent counterfeit or unsafe goods from crossing our borders.' 
 
'Join me in a national commitment to train 2 million Americans with skills that will lead directly to a job.' 
Category 6: Commitment to institutional norms, rights and liberties

Speech quotes:

'Let’s never forget:  Millions of Americans who work hard and play by the rules every day deserve a government and a financial system that do the same.  It’s time to apply the same rules from top to bottom.  No bailouts, no handouts, and no copouts.  An America built to last insists on responsibility from everybody.' 
Overall comment:
In Barack Obama's speech, it is marked by non-populist element focusing in pragmatic and pluralistic features. Firstly, although there is an appeal to the American people, they are not understood as an inherently virtuous entity. Secondly, even though there is a reference to Wall Street and those at the top, the speech does not exclude an elite or an evil minority as the sole cause of society's and the people's problems. Finally, there is a reference to the general will of the people, but not as the ultimate source of political power that prevails above all else. Additionally, Obama’s speech is focused on specific topics, which are intended to be addressed through differentiated and concrete public policies. Furthermore, it demonstrates complete respect for institutions and the rules of the game, as well as the absence of combative language. This aligns it more closely with a pragmatic or pluralistic discourse. However, there is a criticism of Wall Street and big companies, which can be read as criticism of elites oppressing the American people and profiting while regular workers suffer the financial crisis. There’s mention of ordinary, hard-working Americans who are enduring the effects of this crisis, while companies continue to profit. These slight populist themes prevent it from being a 0.0. However, it doesn’t include the 'general will' of the people or depict a unified, homogenous group, which are necessary elements for a speech to be considered populist with at least a category of one.
Grade: 0.3"

# George Bush (step 8) #
step_8_user <- "Read the speech and code the level of populism (0-2 to the tenth place):

<speech>
ADDRESS OF THE PRESIDENT TO THE JOINT SESSION OF CONGRESS
  
 September 20, 2001
  
THE PRESIDENT:  Mr. Speaker, Mr. President Pro Tempore, members of Congress, and fellow Americans:  
In the normal course of events, Presidents come to this chamber to report on the state of the Union.  Tonight, no such report is needed.  It has already been delivered by the American people.
We have seen it in the courage of passengers, who rushed terrorists to save others on the ground -- passengers like an exceptional man named Todd Beamer.  And would you please help me to welcome his wife, Lisa Beamer, here tonight.  (Applause.)
We have seen the state of our Union in the endurance of rescuers, working past exhaustion.  We have seen the unfurling of flags, the lighting of candles, the giving of blood, the saying of prayers -- in English, Hebrew, and Arabic.  We have seen the decency of a loving and giving people who have made the grief of strangers their own.
My fellow citizens, for the last nine days, the entire world has seen for itself the state of our Union -- and it is strong.  (Applause.)
Tonight we are a country awakened to danger and called to defend freedom.  Our grief has turned to anger, and anger to resolution.  Whether we bring our enemies to justice, or bring justice to our enemies, justice will be done.  (Applause.)
I thank the Congress for its leadership at such an important time.  All of America was touched on the evening of the tragedy to see Republicans and Democrats joined together on the steps of this Capitol, singing 'God Bless America.'  And you did more than sing; you acted, by delivering $40 billion to rebuild our communities and meet the needs of our military.
Speaker Hastert, Minority Leader Gephardt, Majority Leader Daschle and Senator Lott, I thank you for your friendship, for your leadership and for your service to our country.  (Applause.)  
And on behalf of the American people, I thank the world for its outpouring of support.  America will never forget the sounds of our National Anthem playing at Buckingham Palace, on the streets of Paris, and at Berlin's Brandenburg Gate.  
We will not forget South Korean children gathering to pray outside our embassy in Seoul, or the prayers of sympathy offered at a mosque in Cairo.  We will not forget moments of silence and days of mourning in Australia and Africa and Latin America.
Nor will we forget the citizens of 80 other nations who died with our own:  dozens of Pakistanis; more than 130 Israelis; more than 250 citizens of India; men and women from El Salvador, Iran, Mexico and Japan; and hundreds of British citizens.  America has no truer friend than Great Britain.  (Applause.)   Once again, we are joined together in a great cause -- so honored the British Prime Minister has crossed an ocean to show his unity of purpose with America.  Thank you for coming, friend.  (Applause.)
On September the 11th, enemies of freedom committed an act of war against our country.  Americans have known wars -- but for the past 136 years, they have been wars on foreign soil, except for one Sunday in 1941.  Americans have known the casualties of war -- but not at the center of a great city on a peaceful morning.  Americans have known surprise attacks -- but never before on thousands of civilians.  All of this was brought upon us in a single day -- and night fell on a different world, a world where freedom itself is under attack.
Americans have many questions tonight.  Americans are asking:  Who attacked our country?  The evidence we have gathered all points to a collection of loosely affiliated terrorist organizations known as al Qaeda.  They are the same murderers indicted for bombing American embassies in Tanzania and Kenya, and responsible for bombing the USS Cole.
Al Qaeda is to terror what the mafia is to crime.  But its goal is not making money; its goal is remaking the world -- and imposing its radical beliefs on people everywhere.
The terrorists practice a fringe form of Islamic extremism that has been rejected by Muslim scholars and the vast majority of Muslim clerics -- a fringe movement that perverts the peaceful teachings of Islam.  The terrorists' directive commands them to kill Christians and Jews, to kill all Americans, and make no distinction among military and civilians, including women and children.
This group and its leader -- a person named Osama bin Laden -- are linked to many other organizations in different countries, including the Egyptian Islamic Jihad and the Islamic Movement of Uzbekistan.  There are thousands of these terrorists in more than 60 countries.  They are recruited from their own nations and neighborhoods and brought to camps in places like Afghanistan, where they are trained in the tactics of terror.  They are sent back to their homes or sent to hide in countries around the world to plot evil and destruction.
The leadership of al Qaeda has great influence in Afghanistan and supports the Taliban regime in controlling most of that country.  In Afghanistan, we see al Qaeda's vision for the world.
Afghanistan's people have been brutalized -- many are starving and many have fled.  Women are not allowed to attend school.  You can be jailed for owning a television.  Religion can be practiced only as their leaders dictate.  A man can be jailed in Afghanistan if his beard is not long enough.  
The United States respects the people of Afghanistan -- after all, we are currently its largest source of humanitarian aid -- but we condemn the Taliban regime.  (Applause.)  It is not only repressing its own people, it is threatening people everywhere by sponsoring and sheltering and supplying terrorists.  By aiding and abetting murder, the Taliban regime is committing murder.  
And tonight, the United States of America makes the following demands on the Taliban:  Deliver to United States authorities all the leaders of al Qaeda who hide in your land. (Applause.)  Release all foreign nationals, including American citizens, you have unjustly imprisoned.  Protect foreign journalists, diplomats and aid workers in your country.  Close immediately and permanently every terrorist training camp in Afghanistan, and hand over every terrorist, and every person in their support structure, to appropriate authorities.  (Applause.)  Give the United States full access to terrorist training camps, so we can make sure they are no longer operating.  
These demands are not open to negotiation or discussion.  (Applause.)  The Taliban must act, and act immediately.  They will hand over the terrorists, or they will share in their fate.  
I also want to speak tonight directly to Muslims throughout the world.  We respect your faith.  It's practiced freely by many millions of Americans, and by millions more in countries that America counts as friends.  Its teachings are good and peaceful, and those who commit evil in the name of Allah blaspheme the name of Allah.  (Applause.)  The terrorists are traitors to their own faith, trying, in effect, to hijack Islam itself.  The enemy of America is not our many Muslim friends; it is not our many Arab friends.  Our enemy is a radical network of terrorists, and every government that supports them.  (Applause.)
Our war on terror begins with al Qaeda, but it does not end there.  It will not end until every terrorist group of global reach has been found, stopped and defeated.  (Applause.)
Americans are asking, why do they hate us?  They hate what we see right here in this chamber -- a democratically elected government.  Their leaders are self-appointed.  They hate our freedoms -- our freedom of religion, our freedom of speech, our freedom to vote and assemble and disagree with each other.
They want to overthrow existing governments in many Muslim countries, such as Egypt, Saudi Arabia, and Jordan.  They want to drive Israel out of the Middle East.  They want to drive Christians and Jews out of vast regions of Asia and Africa.
These terrorists kill not merely to end lives, but to disrupt and end a way of life.  With every atrocity, they hope that America grows fearful, retreating from the world and forsaking our friends.  They stand against us, because we stand in their way.
We are not deceived by their pretenses to piety.  We have seen their kind before.  They are the heirs of all the murderous ideologies of the 20th century.  By sacrificing human life to serve their radical visions -- by abandoning every value except the will to power -- they follow in the path of fascism, and Nazism, and totalitarianism.  And they will follow that path all the way, to where it ends:  in history's unmarked grave of discarded lies. (Applause.)  
Americans are asking:  How will we fight and win this war?   We will direct every resource at our command -- every means of diplomacy, every tool of intelligence, every instrument of law enforcement, every financial influence, and every necessary weapon of war -- to the disruption and to the defeat of the global terror network.
This war will not be like the war against Iraq a decade ago, with a decisive liberation of territory and a swift conclusion.  It will not look like the air war above Kosovo two years ago, where no ground troops were used and not a single American was lost in combat.
Our response involves far more than instant retaliation and isolated strikes.  Americans should not expect one battle, but a lengthy campaign, unlike any other we have ever seen.  It may include dramatic strikes, visible on TV, and covert operations, secret even in success.  We will starve terrorists of funding, turn them one against another, drive them from place to place, until there is no refuge or no rest.  And we will pursue nations that provide aid or safe haven to terrorism.  Every nation, in every region, now has a decision to make. Either you are with us, or you are with the terrorists.  (Applause.)  From this day forward, any nation that continues to harbor or support terrorism will be regarded by the United States as a hostile regime.
Our nation has been put on notice:  We are not immune from attack.  We will take defensive measures against terrorism to protect Americans.  Today, dozens of federal departments and agencies, as well as state and local governments, have responsibilities affecting homeland security.  These efforts must be coordinated at the highest level.  So tonight I announce the creation of a Cabinet-level position reporting directly to me -- the Office of Homeland Security.  
And tonight I also announce a distinguished American to lead this effort, to strengthen American security: a military veteran, an effective governor, a true patriot, a trusted friend -- Pennsylvania's Tom Ridge.  (Applause.)  He will lead, oversee and coordinate a comprehensive national strategy to safeguard our country against terrorism, and respond to any attacks that may come.  
These measures are essential.  But the only way to defeat terrorism as a threat to our way of life is to stop it, eliminate it, and destroy it where it grows.  (Applause.)
Many will be involved in this effort, from FBI agents to intelligence operatives to the reservists we have called to active duty.  All deserve our thanks, and all have our prayers.  And tonight, a few miles from the damaged Pentagon, I have a message for our military:  Be ready.  I've called the Armed Forces to alert, and there is a reason.  The hour is coming when America will act, and you will make us proud.  (Applause.)
This is not, however, just America's fight.  And what is at stake is not just America's freedom.  This is the world's fight.  This is civilization's fight.  This is the fight of all who believe in progress and pluralism, tolerance and freedom.
We ask every nation to join us.  We will ask, and we will need, the help of police forces, intelligence services, and banking systems around the world.  The United States is grateful that many nations and many international organizations have already responded -- with sympathy and with support.  Nations from Latin America, to Asia, to Africa, to Europe, to the Islamic world.  Perhaps the NATO Charter reflects best the attitude of the world:  An attack on one is an attack on all.
The civilized world is rallying to America's side.  They understand that if this terror goes unpunished, their own cities, their own citizens may be next.  Terror, unanswered, can not only bring down buildings, it can threaten the stability of legitimate governments.  And you know what -- we're not going to allow it.  (Applause.)
Americans are asking:  What is expected of us?  I ask you to live your lives, and hug your children.  I know many citizens have fears tonight, and I ask you to be calm and resolute, even in the face of a continuing threat.
I ask you to uphold the values of America, and remember why so many have come here.  We are in a fight for our principles, and our first responsibility is to live by them.  No one should be singled out for unfair treatment or unkind words because of their ethnic background or religious faith.  (Applause.)
I ask you to continue to support the victims of this tragedy with your contributions.  Those who want to give can go to a central source of information, libertyunites.org, to find the names of groups providing direct help in New York, Pennsylvania, and Virginia.
The thousands of FBI agents who are now at work in this investigation may need your cooperation, and I ask you to give it.
I ask for your patience, with the delays and inconveniences that may accompany tighter security; and for your patience in what will be a long struggle.
I ask your continued participation and confidence in the American economy.  Terrorists attacked a symbol of American prosperity.  They did not touch its source.  America is successful because of the hard work, and creativity, and enterprise of our people.  These were the true strengths of our economy before September 11th, and they are our strengths today. (Applause.)
And, finally, please continue praying for the victims of terror and their families, for those in uniform, and for our great country.  Prayer has comforted us in sorrow, and will help strengthen us for the journey ahead.
Tonight I thank my fellow Americans for what you have already done and for what you will do.  And ladies and gentlemen of the Congress, I thank you, their representatives, for what you have already done and for what we will do together.
Tonight, we face new and sudden national challenges.  We will come together to improve air safety, to dramatically expand the number of air marshals on domestic flights, and take new measures to prevent hijacking.  We will come together to promote stability and keep our airlines flying, with direct assistance during this emergency.  (Applause.)
We will come together to give law enforcement the additional tools it needs to track down terror here at home.  (Applause.)  We will come together to strengthen our intelligence capabilities to know the plans of terrorists before they act, and find them before they strike.  (Applause.)
We will come together to take active steps that strengthen America's economy, and put our people back to work.
Tonight we welcome two leaders who embody the extraordinary spirit of all New Yorkers:  Governor George Pataki, and Mayor Rudolph Giuliani.  (Applause.)  As a symbol of America's resolve, my administration will work with Congress, and these two leaders, to show the world that we will rebuild New York City.  (Applause.)
After all that has just passed -- all the lives taken, and all the possibilities and hopes that died with them -- it is natural to wonder if America's future is one of fear.  Some speak of an age of terror.  I know there are struggles ahead, and dangers to face.  But this country will define our times, not be defined by them.  As long as the United States of America is determined and strong, this will not be an age of terror; this will be an age of liberty, here and across the world.  (Applause.)
Great harm has been done to us.  We have suffered great loss.  And in our grief and anger we have found our mission and our moment.  Freedom and fear are at war.  The advance of human freedom -- the great achievement of our time, and the great hope of every time -- now depends on us.  Our nation -- this generation -- will lift a dark threat of violence from our people and our future.  We will rally the world to this cause by our efforts, by our courage.  We will not tire, we will not falter, and we will not fail.  (Applause.)
It is my hope that in the months and years ahead, life will return almost to normal.  We'll go back to our lives and routines, and that is good.  Even grief recedes with time and grace.  But our resolve must not pass.  Each of us will remember what happened that day, and to whom it happened.  We'll remember the moment the news came -- where we were and what we were doing.  Some will remember an image of a fire, or a story of rescue.  Some will carry memories of a face and a voice gone forever.
And I will carry this:  It is the police shield of a man named George Howard, who died at the World Trade Center trying to save others.  It was given to me by his mom, Arlene, as a proud memorial to her son.  This is my reminder of lives that ended, and a task that does not end.  (Applause.)
I will not forget this wound to our country or those who inflicted it.  I will not yield; I will not rest; I will not relent in waging this struggle for freedom and security for the American people.
The course of this conflict is not known, yet its outcome is certain.  Freedom and fear, justice and cruelty, have always been at war, and we know that God is not neutral between them.  (Applause.)
Fellow citizens, we'll meet violence with patient justice -- assured of the rightness of our cause, and confident of the victories to come.  In all that lies before us, may God grant us wisdom, and may He watch over the United States of America.
Thank you.
</speech>"

# Bush Grade #
step_8_ast <- "This is my thought process for the Bush speech.
Bush’s speech offers a mild people-centric element, primarily in the form of emotional appeals to American unity and collective resilience. He celebrates the “decency of a loving and giving people,” citing ordinary citizens such as first responders, grieving families, and passengers like Todd Beamer as embodiments of national virtue. Yet, this is not a populist construction of “the people” as a politically sovereign, morally pure force pitted against a corrupt establishment. Rather, the American people are honored for their character, service, and sacrifice—not as a political agent demanding systemic transformation. Bush says “the state of our Union has already been delivered by the American people,” but this is metaphorical and rhetorical, not a claim that their general will should override institutional governance. Thus, while “the people” are central to the emotional tone, they are not constructed in populist terms.
The speech lacks a populist-style anti-elite narrative. There is no attack on corrupt domestic elites, no scapegoating of institutions, bureaucrats, or political classes. In fact, Bush praises Congress, bipartisan cooperation, and international solidarity. Rather than vilifying the political establishment, he thanks both parties for their leadership and emphasizes unity: “Republicans and Democrats joined together.” There is no reference to a conspiratorial elite obstructing the public will or undermining democracy. The only “enemies” in the speech are external—terrorist networks like al-Qaeda and the Taliban regime—which are portrayed as threats to civilization, not internal elites that must be overthrown or exposed. As such, this speech is almost entirely devoid of the anti-elite framing that is foundational to populist discourse.
By contrast, the speech strongly embodies a Manichaean worldview, perhaps more than any other element. Bush frames the post-9/11 conflict in stark moral terms: a struggle between “freedom and fear,” “justice and cruelty,” “civilization” and “terror.” He asserts that “God is not neutral” between these forces and invokes historical analogies to fascism, Nazism, and totalitarianism. The terrorists are not merely criminals or strategic opponents; they are evil actors who “sacrifice human life to serve their radical visions.” Bush states plainly: “They stand against us, because we stand in their way.” This is a classic populist moral dualism—not populist in structure (no elite-people binary), but clearly populist in its moral absolutism. The stakes are existential, and compromise is explicitly rejected (“These demands are not open to negotiation or discussion”). The use of such cosmic framing places the speech high on the Manichaean scale.
Finally, the speech contains strong pluralist features, particularly in its respect for institutions and legal norms. Bush affirms democratic governance and praises the bipartisan work of Congress. He emphasizes America’s international alliances, highlights the diversity of victims and supporters from around the world, and makes a point to distinguish Islam from terrorism: “We respect your faith… its teachings are good and peaceful.” He also reminds Americans not to engage in prejudice or discrimination against Muslims and Arab Americans. Institutional responses—law enforcement, intelligence, diplomacy, and military preparedness—are all framed as essential and legitimate. Bush does not reject democratic procedures or institutional accountability; rather, he mobilizes them in response to crisis. His framing may be morally binary, but it remains procedurally and institutionally grounded.
In summary, Bush’s speech is morally polarizing and deeply nationalistic, but it lacks the core elements of populism: no elite enemy, and no empowered, unified “people.” Its rhetorical power lies in moral clarity and national resolve, not in populist structure or tone. I would give this speech a 0.0. 
Based on the reasoning above, here is how I would fill out the rubric.
Populist elements in Bush’s speeches: 

Manichaean Vision of the World (Category 1):
 
Speech quotes:

'The terrorists are traitors to their own faith, trying, in effect, to hijack Islam itself.  The enemy of America is not our many Muslim friends; it is not our many Arab friends.  Our enemy is a radical network of terrorists, and every government that supports them.' 

'Every nation, in every region, now has a decision to make. Either you are with us, or you are with the terrorists. From this day forward, any nation that continues to harbor or support terrorism will be regarded by the United States as a hostile regime.'

'On September the 11th, enemies of freedom committed an act of war against our country.'
 
'Al Qaeda is to terror what the mafia is to crime.'
 
'The terrorists' directive commands them to kill Christians and Jews, to kill all Americans, and make no distinction among military and civilians, including women and children.'
 
Cosmic Proportions and Historical Reification (Category 2):
 
Speech quotes: 

No quotes
 
Populist notion of the people (Category 3):
 
Speech quotes: 

'Terrorists attacked a symbol of American prosperity.  They did not touch its source.  America is successful because of the hard work, and creativity, and enterprise of our people.'
 
The Elite as a Conspiring Evil (Category 4):
 
Speech quotes: 

Systemic Change (Category 5):
 
Speech quotes: 

No quotes
 
Anything goes attitude (Category 6):

Speech quotes: 

No quotes
 
Non-Populist element in Bush’s Discourse
Category 1: Pluralist vision of the world

Speech quotes: 
Category 2: Concrete interpretation of political issues

Speech quotes: 
Category 3: Democracy as calculation of votes of individual citizens

Speech quotes: 
Category 4: Non-antagonistic view of opponents

Speech quotes: 
Category 5: Incremental reform

Speech quotes: 
Category 6: Commitment to institutional norms, rights and liberties

Speech quotes: 

Overall Comments:

While this speech does contain populist elements, the combination and use of these elements makes it so it cannot be classified as a populist speech. It’s highly Manichaean with loaded language, clearly defining good and evil. However, terrorists are not an elite. For populism, the 'evil' must be an elite—a small, powerful group oppressing common people. In Bush’s speech, terrorists are portrayed as small groups, not as an overarching elite holding political power. Moreover, the people in populism must be an underdog—a majority oppressed by elites. In Bush’s speech, the American people are portrayed as strong and united, not as an underdog needing to reclaim power. There’s no framing of Americans taking back control of Washington or politics. This speech is nationalistic, praising the entire American people as strong and resilient, rather than dividing them into 'real' people and elites.For these reasons, Bush’s speech scores a zero. It’s highly Manichaean, but it doesn’t include the populist notions of 'the people' or an elite. Moreover, it does not incorporate explicitly non-populist elements, such as pluralist or elitist discourse; rather, it aligns more closely with nationalist rhetoric. 

Grade: 0.0"

# Sarah Palin (step 9) #
step_9_user <- "Read the speech and code the level of populism (0-2 to the tenth place):

<speech>
Sarah Palin Speaks at Tea Party Convention
Aired February 6, 2010 - 21:00   ET
THIS IS A RUSH TRANSCRIPT. THIS COPY MAY NOT BE IN ITS FINAL FORM AND MAY BE UPDATED.
Thank you very much. Thank you.
Thank you so much. God bless you. 
Thank you. Thank you so much. 
I am so proud to be an American. 
Thank you so much for being here tonight. 
Do you love your freedom? If you love your freedom, think of it. Any of you here serving in uniform, past or present, raise your hand? We are going to thank you for our freedom. God bless you guys. We salute you. We honor you. Thank you. 
I am so proud to be American. Thank you. Gosh. Thank you. Happy birthday, Ronald Reagan. 
Well, a special hello to the C-SPAN viewers. You may not be welcome in those health care negotiations but you have an invitation to the tea party. 
Very good to be here in Tennessee, the volunteer state. It's the home of good country music and good southern barbecue, and great to be at the tea party convention. I guess down here that's some southern sweet tea. In Alaska, we have a smaller version of tea party up there. And we call it iced tea. 
And I am a big supporter of this movement. I believe in this movement. Got lots of friends and family in the lower 48 attending these events across the country, and just knowing that this is the movement, and America is ready for another revolution, and you are a part of this. 
I look forward to attending more tea party events in the near future. It is so inspiring to see real people, not politicos -- 
-- not inside the beltway professionals come out and stand up and speak out for commonsense, conservative principles. 

And today, I want to start off with a special shout out to America's newest Senator. Thanks to you, Scott Brown. 
Now in many ways Scott Brown represents what this beautiful movement is all about. He was just a guy with a truck and a passion to serve our country. He looked around and he saw that things weren't quite right in Washington, so he stood up and he decided he was going do his part to put our government back on the side of the people. And it took guts and it took a lot of hard work, but with grassroots support, Scott Brown carried the day. It has been so interesting now to watch the aftermath of the Massachusetts shout-out revolution. 
The White House blames the candidate. Their candidate. And Nancy Pelosi, she blamed the Senate Democrats. And Rahm Emanuel, he criticized a pollster. 
And yet again, President Obama found some way to make this all about George Bush. 
You know, considering the reason conservative elections sweep, it is time to stop that they blaming everyone else. When you are zero for three, you better stop lecturing and start listening. 
The only place that the left hasn't placed the blame is on their agenda. So some advice for our friends on that side of the aisle. That's where you've got to look because that's what got you into this mess. The Obama/Pelosi/Reid agenda will leave us less secure, more in debt and under the thumb of big government. That is out of touch and is out of date. And if Scott Brown is any indication, it is running out of time. 
Because from Virginia to New Jersey to Massachusetts, voters are sending a message up and down the east coast, and in good places like Nevada and Connecticut and Colorado, Michigan, North Dakota, they've got the liberal left, that establishment running scared. 
The bottom line is this. It's been a year now. They own this now. and voters are going to hold them accountable. Because out here in the cities and in the towns across this great country we know that we've got some big problems to solve. We've gotten tired now of looking backward. We want to look forward and, from here, my friends, the future–it looks really good. It looks really good. Because if there is hope in Massachusetts, there's hope everywhere. 
Brown's victory, it's exciting and it's a sign of more good things to come. A lot of great common-sense conservative candidates are going to put it all on the line in 2010. This year, there are going to be tough primaries. And I think that's good. Competition in these primaries is good. Competition makes us work harder and be more efficient and produce more. I hope you will get out there and work hard for the candidates who reflect your values, your priorities, because despite what the pundits want you to think, contested primaries aren't civil war. They're democracy at work and that's beautiful. 
I was the product of a competitive primary running for governor. I faced five guys in the party and we put our ideas and our experience out there on the table for debate. And then we allowed, of course, the voters to decide. That is a healthy process. And it gives Americans the kind of leadership that they want and they deserve. And so in 2010, I tip my hat to anyone with the courage to throw theirs in the ring and may the best ideas and candidates win.
But while I hope you give the candidates that you choose your best effort, please understand they're human. There's no perfect candidate. And they're going to disappoint occasionally. And when they do, let them know, but don't get discouraged and sit it out, because the stakes are too high. The stakes are too high right now, and your voice is too important, so work hard for these candidates but put your faith in ideas. 
And in that spirit, I caution against allowing this movement to be defined by any one leader or politician. The tea party movement is not a top-down operation. It's a ground-up call to action that is forcing both parties to change the way they're doing business, and that's beautiful. 
This is about the people. This is about the people. And it's bigger than any king or queen of a tea party. And it's a lot bigger than any charismatic guy with a teleprompter. 
The soul of this movement is the people, everyday Americans, who grow our food and run our small businesses, who teach our kids and fight our wars. They're folks in small towns and cities across this great nation who saw what was happening and they saw and were concerned and they got involved. Like you, they go to town hall meetings and they write op-eds. They run for local office. You all have the courage to stand up and speak out. You have a vision for the future, one that values conservative principles and commonsense solutions. And if that sounds like you, then you probably, too, are feeling a bit discouraged by what you see in Washington, D.C. 
Now in recent weeks, many of us have grown even more uneasy about our administration's approach to national security, the most important role ascribed to our federal government. 
Let me say, too, it's not politicizing our security to discuss our concerns because Americans deserve to know the truth about the threats that we face and what the administration is or isn't doing about them. So let's talk about them. New terms used like 'overseas contingency operation' instead of the word 'war.' That reflects a world view that is out of touch with the enemy that we face. We can't spin our way out of this threat. It is one thing to call a pay raise a job created or saved. It is quite another to call the devastation that a homicide bomber can inflict a 'manmade disaster.' I just say, come on, Washington, if no where else, national security, that is one place where you've got to call it like it is. 
And in that spirit, in that spirit, we should acknowledge that, on Christmas day, the system did not work. Abdulmutallab passed through airport security with a bomb. and he boarded a flight hell bent on killing innocent passengers. This terrorist trained in Yemen with al Qaeda. His American visa was not revoked until after he tried to kill hundreds of passengers. On Christmas day, the only thing that stopped this terrorist is blind luck and brave passengers. It was a Christmas miracle. And that is not the way that the system is supposed to work. 
What followed was equally disturbing after he was captured. He was questioned for only 50 minutes. We have a choice in how to do this. The choice was only question him for 50 minutes and then read his Miranda rights. The administration says then there are no downsides or upsides to treating terrorists like civilian criminal defendants. But a lot of us would beg to differ. For example, there are questions we would have liked this foreign terrorist to answer before he lawyered up and invoked our U.S. constitutional right to remain silent. 
Our U.S. constitutional rights. 
Our rights that you, sir, fought and were willing to die for to protect in our Constitution. 
The rights that my son, as an infantryman in the United States Army, is willing to die for. The protections provided, thanks to you, sir, we're going to bestow them on a terrorist who hates our Constitution and tries to destroy our Constitution and our country. This makes no sense because we have a choice in how we're going to deal with the terrorists. We don't have to go down that road. There are questions that we would have liked answered before he lawyered up, like where exactly were you trained and by whom. You are bragging about all these other terrorists just like you, who are they? When and where will they try to strike next? 
The events surrounding the Christmas day plot reflect the kind of thinking that led to September 11th. The threat then, as the 'USS Cole' was attacked, our embassies were attacked, it was treated like an international crime spree not like an act of war. We are seeing that mindset again settle into Washington again. That scares me for my children, for your children. Treating this as a mere law enforcement matter places our country at great risks because that is not how radical Islamic extremists look at this. They know we are at war. To win that war, we need a commander in chief, not a professor of law standing at the lectern. 
It's that same kind of misguided thinking that is seen throughout the administration's foreign policy decisions. Our president spent a year reaching out to hostile regimes, writing personal letters to dangerous dictators and apologizing for America, and what do we have to show for that? Here's what we have to show. North Korea tested nuclear weapons and longer-range ballistic missiles. Israel, a friend and critical ally, now questions the strength of our support. Plans for a missile defense system in Europe, they've been scrapped. Relations with China and Russia are no better. and relations with Japan, that key Asian ally, they are in the worst shape in years. And around the world, people who are seeking freedom from oppressive regimes wonder if Alaska is still that beacon of hope for their cause. The administration cut support for democracy programs. And where the president has not been clear, I ask where is his clear and where his strong voice of support for the Iranians who are risking all in their opposition to Ahmadinejad? 
Just that short list, that short list. And you know, it is no wonder that our president only spent 9 percent of his State of the Union address discussing national security, foreign policy, because there aren't a lot of victories he could talk about that night. And that is a short list. There are so many challenges in front of us. And it can seem overwhelming. But despite these challenges, we have hope that we can move things in the right direction but it is going to require the administration to change course. We need a foreign policy that distinguishes America's friends from her enemies and recognizes the true nature of the threats that we face. 
We need a strong national defense. I think you would agree with me. As Reagan used to talk about that peace through strength. In that respect, I applaud the president for following at least a part of the recommendations made by our commanders on the ground to send in some more reinforcements to Afghanistan. Now, though, he, we, must spend less time courting our adversaries and working with our allies. And we must build coalitions capable of confronting dangerous regimes like Iran and North Korea. It is time for more than just tough talk. I'm just like you, probably so tired of hearing the talk, talk, talk. 
Tired of hearing the talk. 
It's time for some tough actions, like sanctions on Iran. And in places in the world where people are struggling and oppressed and they're fighting for freedom, America must stand with them. We need a clear foreign policy that stands with the people and for democracy, one that reflects both our values and our interests. And it is in our best interest because democracies, they don't go to war with each other. They can settle their differences peacefully. 
The lesson of the last year is this. Foreign policy can't be managed through the politics of personality. And our president would do well to take note of an observation John F. Kennedy made once he was in office, that all of the world's problems aren't his predecessor's fault. 
The problems that we face in the real world require real solutions and we'd better get to it because the risks that they pose are great and they're grave. However, as Barry Goldwater said, we can be conquered by bombs, but we can also be conquered by neglect, by ignoring our Constitution and disregarding the principles of limited government. And in the past year, his words ring true. Washington has now replaced private irresponsibility with public irresponsibility. The list of companies and industries that the government is crowding out and bailing out and taking over, it continues to grow. First, it was the banks, mortgage companies, financial institutions, then automakers. Soon, if they had their way, health care, student loans. Today, in the words of Congressman Paul Ryan, the $700 billion TARP has morphed into crony capitalism at its worse. It is becoming a slush fund for the Treasury Department's favorite big players, just as we had been warned about. While people on main street look for jobs, people on Wall Street, they're collecting billions and billions in your bailout bonuses. Among the top 17 companies that received your bailout money, 92 percent of the senior officers and directors, they still have their good jobs. And everyday Americans are wondering, where are the consequences for them helping to get us into this worst economic situation since the great depression? Where are the consequences? 
When Washington passed a $787 billion stimulus bill, we were nervous because they just spent $700 billion to bailout Wall Street. On the state level, as a governor, we knew a lot of that money came with fat strings attached. The federal government was going to have more control over our states. They were going to disrespect the Tenth Amendment of our Constitution by essentially bribing with us. Take this federal money and then we going to be able to mandate a few more things on you though. I joined with other conservative governors around the nation in rejecting some of those dollars. Legislators -- 
Turned out to be, though, nothing to applaud, because legislators then were threatening lawsuits if governors didn't take the money. And I vetoed some of the funds that I knew we couldn't maintain the programs that we were going to pay for with these borrowed, printed up, invented dollars out of nowhere, but lawsuits were threatened. Even in Alaska, in a Republican-controlled legislature, my veto was overridden, and the money poured into those states. And I believe we will see this play out in our states. The federal government will have taken more control over the people who live in our states. 

Now I understand wanting to believe that this is all free money and for some, I guess, it is tough to tell people 'no' in tough times. Plus, remember our administration promise that it would be good stewards of taxpayer dollars. Remember? Remember, Vice President Biden? He was put in charge of a tough, unprecedented oversight effort. That's how it was introduced. You know why? Because nobody messes with Joe. 
Now, this was all part of that hope and change and transparency. And now a year later, I got to ask the supporters of all that, how is that hopey-changey stuff working out for you? 
See, I tried to look into that transparency thing but Joe's meetings with the transparency and accountability board, it was closed to the public. 
Yes. They held a transparency meeting behind closed doors. 
So I'm not sure if anybody's messing with Joe. But here is what I do know. A lot of that stimulus cash, it ended up in some pretty odd places, including districts that didn't even exist. 
And programs that really don't have a whole lot to do with stimulating the economy. Nearly $6 million was given to a Democrat pollster, who had already made millions during the Democrats' presidential primary. Nearly $10 million was spent to update the stimulus web site. And one state even spent a million bucks to put up signs that advertised they were spending the federal stimulus projects or, as someone put it, this was a $1 million effort to tell you it is spending your money. 
And it didn't create a single job. 
Those uses of stimulus funds don't sound targeted and they don't sound timely as we were promised. They just sound wasteful and, in the case of those signs, kind of ridiculous. All of that stimulus. I don't know about you but seeing those checks written for pet projects of congressmen and those in the White House, did you feel very stimulated? 
And then it turns out that Washington got the price tag wrong. All of these projects and programs, they cost tens and tens of billions more than we were told. It is now closer to $860 billion. Add this to the fact that the White House can't even tell us how many jobs were actually created. Depending on who you ask, it is anywhere from thousands to two million. 
But one number we are sure of is the unemployment number. That is 9.7, which is well above the 8 percent mark that we were promised our stimulus package would go to avoid. And unemployment now is -- underemployment now is 16.5 percent. You have got all these people who have just kind of given up right now. and they are not even enrolling in some of these programs. Tough to count them. 
Folks, I won't go into all of it tonight, but the list of broken promises is long. Candidate Obama pledged to end closed-door, sweetheart deals and no-bit contracts once and for all, but just last month his administration awarded a $25 million no-bid contract to a Democrat donor? Is that hope? Nope. It's not hope. 
That's the same old, same old in Washington, D.C. And instead of changing the way Washington does business, we got the cornhusker kickback and the Louisiana Purchase and millions of tax breaks for union boss' desires. The promised ban on lobbyist in this new administration, he handed out waivers left and right, and there are more than 40 former lobbyists who now work at the top levels in this administration. And these days, most members of Congress, they don't get to read the bill before they have to vote on it, much less the pledged that a bill wouldn't be signed into law before we all had five days to review it online.
So, see, it's easy to understand why Americans are shaking their heads when Washington has broken trust with the people that these politicians are to be serving. We're drowning in national debt and many of us have had enough. Now the foundational principles in all of this, it's easy to understand. It really is even I though I think D.C. would just love for us to believe that this is all way over our heads. Somebody in Tennessee, somebody up there in Alaska, she'll never understand what we are talking about here in D.C. No, this is all pretty simple stuff. When our families, when our small businesses, we start running our finances in to the red, what do we do? We tighten our belts and we cut back budgets. That is what we teach our children, to live within our means. That is what Todd and I do when we have to make payroll, buy new equipment for our commercial fishing business. We have to plan for the future, meet a budget. 
But in Washington, why is it just the opposite of that? This week, they unveiled a record busting, mind boggling $3.8 trillion federal budget and they keep borrowing and they keep printing these dollars and they keep making us more and more beholden to foreign countries and they keep making us take these steps towards insolvency. Now what they are doing in proposing these big new programs with giant price tags, they're sticking our kids with the bill. And that is immoral. That is generational theft. We are stealing the opportunities from our children. 
And freedom lovers around this country need to be aware this makes us more beholden to other countries, it makes us less secure. It makes us less free and that should tick us off. So, folks, with all these serious challenges ahead, we've got private-sector job creation that has got to take place and economic woes and health care, the war on terror. 
But as the saying goes, if you can't ride two horses at once, you shouldn't be in the circus. So here's some advice for those in D.C. who want to shine in the greatest show on earth. Too often when big government and big business get together and cronyism sets in, well, it benefits insiders not everyday Americans. The administration and Congress should do what we did up there in Alaska when the good old boys started making back room deals that were benefiting big oil and not the citizens of the state. And the citizens of the state then, Alaskans, we got together and we put government back on the side of the people. And a lot of the big wigs, they started getting in trouble and some of the big wigs ended up going to jail over their back room deals. 
Our government needs to adopt a pro-market agenda that doesn't pick winners and losers but it invites competition and it levels the playing field for everyone. Washington has got to across the board, lower taxes for small businesses so that our mom and pops can reinvest and hire people so that our businesses can thrive. They should support competition, support innovation, reward hard work. 
And they should do all that they can to make sure that the game is fair without the undo corrupt influence. And then they need to get government out of the way. If they would do this -- if they would do this, our economy, it would roar back to life and for instance on health care, we need bipartisan solutions to help families not increase taxes. Remember that red reset button that America through Secretary Clinton, she gave to Putin. Remember that? I think we should ask for that back and hand it instead to Congress. And say, no, start all over on this health care scheme and pass meaningful, market-based reforms that incorporate some simple steps that have broad support. The best ideas, not back room deals but insurance purchases across state lines and the tort reform that we've talked about. 
Those things that are common sense steps towards reform that the White House and leaders on the Democrats' side of the aisle in Congress, they don't want to consider. So it makes you wonder, what truly is their motivation? What is their intention if they won't consider even these common sense, broad based support ideas that would work? And to create jobs. Washington should jump start energy projects. I said it during the campaign and I'll say it now, we need an all of the above approach to energy policy. That means proven conventional resource development and support for nuclear power. And I was thankful that the president at least mentioned nuclear power in his State of the Union. 
But, again, we need more than words. We need a plan to turn that goal into a reality and that way we can pave the way for projects that will create jobs, those are real job creators and deliver carbon free energy. And while we're at it, let's expedite the regulatory and permitting and legal processes for on and offshore drilling.
Instead of paying billions of dollars, hundreds of billions of dollars that now are being sent to foreign regimes, we should be drilling here and drilling now instead of relying on them to develop their resources for us. So what we've got to do is axe that plan for cap-and-tax, that policy is going to kill jobs and it's going to pass the burden of paying for it onto our working families. 
And finally, if we are going to get serious about fiscal restraint, then we've got to make Washington start walking the walk. After putting us on a track to quadruple the deficit, the proposed spending freeze, maybe it is a start, but it's certainly not enough. As Senator John Thune said, it's like putting a Band-Aid on a self- inflicted gunshot wound. 
We need to go further. Cut spending. Don't just simply slow down a spending spree and we've got to axe the plans for a second stimulus when the first hasn't even been measured for any success yet. Kill the plans for the second stimulus and be aware that now that second stimulus is being referred to as a jobs bill. Now these aren't the only ways to rein in spending, and alone, they're not going to be enough, not enough to tackle the insane debt and the deficits that we face. But they are a good way to start and to show that we're serious about getting our financial house in order. 
Now like a lot of you, perhaps, I have spent the last year thinking about how to best serve. How can I help our country? How can I make sure that I, that you, that we're in a position of nobody being able to succeed. When they try to tell us to sit down and shut up, how can we best serve? In 2008, I had the honor really of a lifetime, the honor of a lifetime, running alongside John McCain. I look at him as an American hero. And nearly 60 million Americans voted for us. They cast their ballot for the things that we are talking about tonight. Lower taxes, smaller government, transparency, energy independence and strong national security. And while no, our votes did not carry the day, it was still a call to serve our country. Those voters wanted us to keep on fighting and take the gloves off and they wanted common sense conservative solutions and they wanted us to keep on debating. And each of us who is here today, we're living proof that you don't need an office or a title to make a difference and you don't need a proclaimed leader as if we are all just a bunch of sheep and we're looking for a leader to progress this movement.
That is what we are fighting for. It is what we are fighting about. It is what we believe in and that's what this movement is all about. When people are willing to meet halfway and stand up for common sense solutions and values, then we want to work with them. And in that spirit, I applaud Independents and Democrats like Bart Stupak who stood up to tough partisan pressure and he wanted to protect the sanctity of life and the rights of the soon to be born. I applaud him for that.
When we can work together, we will. But when the work of Washington violates our consciences and when the work and effort in Washington, D.C., violate our Constitution, then we will stand up and we will be counted. Because we are the loyal opposition. And we have a vision for the future of our country, too, and it is a vision anchored in time tested truths. 
That the government that governs least, governs best. And that the Constitution provides the best road map towards a more perfect union. And that only limited government can expand prosperity and opportunity for all and that freedom is a God given right and it is worth fighting for. God bless you. And that America's finest, our men and women in uniform, are a force for good throughout the world and that is nothing to apologize for.
These are enduring truths and these enduring truths have been passed down from Washington to Lincoln to Reagan and now to you. But while this movement, our roots there, in our spirit, too, they are historic. The current form of this movement is fresh and it's young and it's fragile. We are now the keepers of an honorable tradition of conservative values and good works. And we must never forget that it is a sacred trust to carry these ideas forward. It demands civility and it requires decent constructive issue-oriented debate. 
Opponents of this message, they are seeking to marginalize this movement. They want to paint us as ideologically extreme and the counterpoint to liberal intolerance and outrageous conspiracy theorists aimed at our own government and unethical shameless tactics like considering a candidate's children fair game. 
But unlike the elitists who denounce this movement, they just don't want to hear the message. I've traveled across this great country and I've talked to the patriotic men and women who make up the Tea Party movement, and they are good and kind and selfless and they are deeply concerned about our country. And today I ask only this, let's make this movement a tribute to their good example and make it worthy of their hard work and their support. 
Do not let us have our heads turned from the important work before us and do not give others an excuse to be able to turn their eyes from this. Let us not get bogged down in the small squabbles. Let us get caught up in the big ideas. To do so would be a fitting tribute to Ronald Reagan, especially tonight, as he would have turned 99. No longer with us. His spirit lives on and his American dream endures. He knew the best of our country is not all gathered in Washington, D.C. It is here in our communities where families live and children learn and children with special needs are welcomed in this world and embraced. And thank you for that. 
The best of America can be found in places where patriots are brave enough and free enough to be able to stand up and speak up and where small businesses grow our economy one job at a time and folks like Reagan, we know that America is still that shining city on a hill. I do believe that God shed his grace on thee. We know that our best days are yet to come. Tea Party nation, we know that there is nothing wrong with America that together we can't fix as Americans.
So from the bottom of my heart and speaking on behalf of millions and millions and millions of Americans who want to encourage this movement, this movement is about the people. Who can argue of a movement that is about the people and for the people? Remember, all political power is inherent in the people and government is supposed to be working for the people. That is what this movement is about. 
From the bottom of my heart, I thank you for being part of the solution. God bless you, Tea Partiers and God bless the USA. Thank you. God bless you.
</speech>
"

# Sarah Palin Grade #
step_9_ast <- "Here is my thought process for grading this speech.
Palin’s speech features a strong people-centric appeal, with “the people” consistently portrayed as hard-working, morally upright, and politically sidelined. She celebrates “everyday Americans” who “grow our food and run our small businesses, who teach our kids and fight our wars,” and she contrasts these salt-of-the-earth citizens with Washington insiders and technocrats. She also emphasizes the role of the states—like Alaska and Tennessee—as more authentic and grounded than the federal government. In this speech, “the people” are not simply cultural heroes; they are framed as the rightful source of political power. Palin’s refrain that the Tea Party movement is “not top-down” but “bottom-up” reflects a populist invocation of the general will: it is the people who must guide governance, not the elites or political machines. The moral legitimacy of politics, in her account, flows from them.
The anti-elite framing is explicit and sustained. Palin identifies Washington, D.C.—particularly the Obama administration, congressional Democrats, and federal bureaucracies—as a bloated, corrupt, and self-serving elite. These elites are accused of cronyism, overspending, manipulating the economy, and ignoring the Constitution. She criticizes “fat elite résumés,” “closed-door sweetheart deals,” and “insiders” who benefit from “bailout bonuses” while everyday Americans struggle. Big business and Wall Street are cast as collaborators in this betrayal, enabled by federal power. This fulfills the populist requirement of defining a powerful minority that acts in opposition to the people’s interests, enriching themselves while ordinary citizens bear the consequences. Her rhetorical question, “Where are the consequences?” underscores the populist belief that the elite are unaccountable and shielded from the very laws they impose on others.
The speech also contains a Manichaean undercurrent, though more restrained than in high-intensity populism. Palin draws sharp moral distinctions between the virtuous people and the corrupt elite, describing the political system as morally compromised and guided by false values. She characterizes the national security response as dangerously soft, invoking 9/11 to frame political naivety as a risk to American lives. At times, she appeals to divine authority—calling for “divine intervention” and referencing the Founders and Constitution in sacred terms. Yet, her tone remains comparatively moderate. Unlike Evo Morales, she does not call for revolutionary transformation or overthrowing the system. Instead, her message is reformist, grounded in electoral change and a revival of “common sense.” The moral conflict is clear but lacks cosmic or violent overtones. This places the Manichaeanism at a moderate level, present but not dominating the rhetorical field.
Palin’s speech contains little pluralist content. She rarely affirms the legitimacy of disagreement or institutional mediation. While she calls for bipartisan solutions on issues like healthcare and occasionally praises Democrats who align with Tea Party values (e.g., Bart Stupak), this is conditional inclusion, not an embrace of political diversity. Her distrust of both political parties, criticism of the media, and celebration of non-professional candidates reflect a skepticism toward institutions and conventional politics. At the same time, she doesn’t reject the Constitution or democratic procedures—she uses them as touchstones to legitimize her critique. Her policy proposals (tax cuts, regulatory reform, drilling, tort reform) indicate a degree of policy focus not typically present in higher-intensity populism, which tempers the more combative aspects of her message.
Overall, Palin’s speech is a clear case of populism, indeed, almost strong populism—firmly structured around populist binaries and moral critique, but less radical in tone and scope than higher-intensity cases like Morales. The populist elements are consistent and strong, but moderated by institutional language and policy detail. I would give it a 1.5.

Populist elements in Palin’s speech

Category 1: Manichaean Vision of the World:
 
Speech quotes:

'While people on main street look for jobs, people on Wall Street, they're collecting billions and billions in your bailout bonuses.'
 
 
'So, see, it's easy to understand why Americans are shaking their heads when Washington has broken trust with the people that these politicians are to be serving. We're drowning in national debt and many of us have had enough.'
 
Category 2: Cosmic Proportions and Historical Reification:
 
Speech quotes: 

No quotes
 
Category 3: Populist notion of the people:

Speech quotes: 

'The soul of this movement is the people, everyday Americans, who grow our food and run our small businesses, who teach our kids and fight our wars. They're folks in small towns and cities across this great nation who saw what was happening and they saw and were concerned and they got involved.'
 
Category 4: The Elite as a Conspiring Evil:
 
Speech quotes: 

'Washington has now replaced private irresponsibility with public irresponsibility. The list of companies and industries that the government is crowding out and bailing out and taking over, it continues to grow.'
 
 
'So here's some advice for those in D.C. who want to shine in the greatest show on earth. Too often when big government and big business get together and cronyism sets in, well, it benefits insiders not everyday Americans.'
 
Category 5: Systemic Change:
 
Speech quotes: 

'And I am a big supporter of this movement. I believe in this movement. Got lots of friends and family in the lower 48 attending these events across the country, and just knowing that this is the movement, and America is ready for another revolution, and you are a part of this.'
 
Category 6: Anything goes attitude:
Speech quotes: 

No quotes
Non-Populist element in Palin’s Discourse
Category 1: Pluralist vision of the world

Speech quotes: 

No quotes
Category 2: Concrete interpretation of political issues

Speech quotes: 

No quotes
Category 3: Democracy as calculation of votes of individual citizens

Speech quotes: 

No quotes
Category 4: Non-antagonistic view of opponents

Speech quotes: 

No quotes
Category 5: Incremental reform

Speech quotes: 

No quotes
Category 6: Commitment to institutional norms, rights and liberties

Speech quotes: 

No quotes

Overall Comments:
There are clear populist elements in the speech. Firstly, it is possible to identify an appeal to a virtuous people represented by average Americans, workers, and the states. Secondly, a clear recognition of an elite is present, represented by the federal government and big businesses, which benefit at the expense of the people's interests. Finally, there is an acknowledgment of the general will of the people as the ultimate source of political power, which will enable change and restore governance to the people. Overall, Palin references ordinary people and their role in guiding politics and frequently references hard-working, ordinary Alaskans oppressed by big government, which she identifies as the elite in her speech. At this Tea Party rally, Palin’s speech reflects small-government conservatism, where big government is the enemy. Her speech has a right-wing populist appeal but is not as strongly populist as Morales, who used more charged language like 'death cult of capitalism' and called for overthrowing the system. Palin’s language is moderate by comparison. Moreover, while she references historical figures like Ronald Reagan, this is standard for American conservatives. Her speech includes populist themes but also touches on specific policies like taxes and economic issues, which are less Manichaean. Palin’s speech might score around 1.5,but it doesn’t qualify as a 2. The elements are there and consistently used, but it’s more moderate. 
Grade: 1.5"

# Donald Trump Speech #
step_10_user <- "Read the speech and code the level of populism (0-2 to the tenth place):

<speech>
Thank you very much.  That’s so nice.  The United States has many great diplomats, but there is truly no better ambassador for our country than our beautiful First Lady, Melania.  Thank you, Melania.  That was very nice.  (Applause.)
We’ve come to your nation to deliver a very important message:  America loves Poland, and America loves the Polish people.  (Applause.)  Thank you.
The Poles have not only greatly enriched this region, but Polish-Americans have also greatly enriched the United States, and I was truly proud to have their support in the 2016 election.  (Applause.)
It is a profound honor to stand in this city, by this monument to the Warsaw Uprising, and to address the Polish nation that so many generations have dreamed of:  a Poland that is safe, strong, and free.  (Applause.)
President Duda and your wonderful First Lady, Agata, have welcomed us with the tremendous warmth and kindness for which Poland is known around the world.  Thank you.  (Applause.)  My sincere — and I mean sincerely thank both of them.  And to Prime Minister Syzdlo, a very special thanks also.  (Applause.)
We are also pleased that former President Lech Walesa, so famous for leading the Solidarity Movement, has joined us today, also.  (Applause.)  Thank you.  Thank you.  Thank you.
On behalf of all Americans, let me also thank the entire Polish people for the generosity you have shown in welcoming our soldiers to your country.  These soldiers are not only brave defenders of freedom, but also symbols of America’s commitment to your security and your place in a strong and democratic Europe.
We are proudly joined on stage by American, Polish, British, and Romanian soldiers.  Thank you.  (Applause.)  Thank you.  Great job.
President Duda and I have just come from an incredibly successful meeting with the leaders participating in the Three Seas Initiative.  To the citizens of this great region, America is eager to expand our partnership with you.  We welcome stronger ties of trade and commerce as you grow your economies. And we are committed to securing your access to alternate sources of energy, so Poland and its neighbors are never again held hostage to a single supplier of energy.  (Applause.)
Mr. President, I congratulate you, along with the President of Croatia, on your leadership of this historic Three Seas Initiative.  Thank you.  (Applause.)
This is my first visit to Central Europe as President, and I am thrilled that it could be right here at this magnificent, beautiful piece of land.  It is beautiful.  (Applause.)  Poland is the geographic heart of Europe, but more importantly, in the Polish people, we see the soul of Europe.  Your nation is great because your spirit is great and your spirit is strong.  (Applause.)
For two centuries, Poland suffered constant and brutal attacks.  But while Poland could be invaded and occupied, and its borders even erased from the map, it could never be erased from history or from your hearts.  In those dark days, you have lost your land but you never lost your pride.  (Applause.)
So it is with true admiration that I can say today, that from the farms and villages of your countryside to the cathedrals and squares of your great cities, Poland lives, Poland prospers, and Poland prevails.  (Applause.)
Despite every effort to transform you, oppress you, or destroy you, you endured and overcame.  You are the proud nation of Copernicus — think of that — (applause) — Chopin, Saint John Paul II.  Poland is a land of great heroes.  (Applause.)  And you are a people who know the true value of what you defend.
The triumph of the Polish spirit over centuries of hardship gives us all hope for a future in which good conquers evil, and peace achieves victory over war.
For Americans, Poland has been a symbol of hope since the beginning of our nation.  Polish heroes and American patriots fought side by side in our War of Independence and in many wars that followed.  Our soldiers still serve together today in Afghanistan and Iraq, combatting the enemies of all civilization.
For America’s part, we have never given up on freedom and independence as the right and destiny of the Polish people, and we never, ever will.  (Applause.)
Our two countries share a special bond forged by unique histories and national characters.  It’s a fellowship that exists only among people who have fought and bled and died for freedom.  (Applause.)
The signs of this friendship stand in our nation’s capital.  Just steps from the White House, we’ve raised statues of men with names like Pułaski and Kościuszko.  (Applause.)  The same is true in Warsaw, where street signs carry the name of George Washington, and a monument stands to one of the world’s greatest heroes, Ronald Reagan.  (Applause.)
And so I am here today not just to visit an old ally, but to hold it up as an example for others who seek freedom and who wish to summon the courage and the will to defend our civilization.  (Applause.)  The story of Poland is the story of a people who have never lost hope, who have never been broken, and who have never, ever forgotten who they are.  (Applause)
AUDIENCE:  Donald Trump!  Donald Trump!  Donald Trump!
  PRESIDENT TRUMP:  Thank you.  Thank you so much.  Thank you.  Thank you so much.  Such a great honor.  This is a nation more than one thousand years old.  Your borders were erased for more than a century and only restored just one century ago.
In 1920, in the Miracle of Vistula, Poland stopped the Soviet army bent on European conquest.  (Applause.)  Then, 19 years later in 1939, you were invaded yet again, this time by Nazi Germany from the west and the Soviet Union from the east.  That’s trouble.  That’s tough.
Under a double occupation the Polish people endured evils beyond description: the Katyn forest massacre, the occupations, the Holocaust, the Warsaw Ghetto and the Warsaw Ghetto Uprising, the destruction of this beautiful capital city, and the deaths of nearly one in five Polish people.  A vibrant Jewish population — the largest in Europe — was reduced to almost nothing after the Nazis systematically murdered millions of Poland’s Jewish citizens, along with countless others, during that brutal occupation.
In the summer of 1944, the Nazi and Soviet armies were preparing for a terrible and bloody battle right here in Warsaw. Amid that hell on earth, the citizens of Poland rose up to defend their homeland.  I am deeply honored to be joined on stage today by veterans and heroes of the Warsaw Uprising.  (Applause.)
AUDIENCE:  (Chanting.)
PRESIDENT TRUMP:  What great spirit.  We salute your noble sacrifice and we pledge to always remember your fight for Poland and for freedom.  Thank you.  Thank you.  (Applause.)
This monument reminds us that more than 150,000 Poles died during that desperate struggle to overthrow oppression.
From the other side of the river, the Soviet armed forces stopped and waited.  They watched as the Nazis ruthlessly destroyed the city, viciously murdering men, women, and children.  They tried to destroy this nation forever by shattering its will to survive.
But there is a courage and a strength deep in the Polish character that no one could destroy.  The Polish martyr, Bishop Michael Kozal, said it well:  “More horrifying than a defeat of arms is a collapse of the human spirit.”
Through four decades of communist rule, Poland and the other captive nations of Europe endured a brutal campaign to demolish freedom, your faith, your laws, your history, your identity — indeed the very essence of your culture and your humanity.  Yet, through it all, you never lost that spirit.  (Applause.)  Your oppressors tried to break you, but Poland could not be broken.  (Applause.)
And when the day came on June 2nd, 1979, and one million Poles gathered around Victory Square for their very first mass with their Polish Pope, that day, every communist in Warsaw must have known that their oppressive system would soon come crashing down.  (Applause.)  They must have known it at the exact moment during Pope John Paul II’s sermon when a million Polish men, women, and children suddenly raised their voices in a single prayer.  A million Polish people did not ask for wealth.  They did not ask for privilege.  Instead, one million Poles sang three simple words:  “We Want God.”  (Applause.)
In those words, the Polish people recalled the promise of a better future.  They found new courage to face down their oppressors, and they found the words to declare that Poland would be Poland once again.
As I stand here today before this incredible crowd, this faithful nation, we can still hear those voices that echo through history.  Their message is as true today as ever.  The people of Poland, the people of America, and the people of Europe still cry out “We want God.”  (Applause.)
Together, with Pope John Paul II, the Poles reasserted their identity as a nation devoted to God.  And with that powerful declaration of who you are, you came to understand what to do and how to live.  You stood in solidarity against oppression, against a lawless secret police, against a cruel and wicked system that impoverished your cities and your souls.  And you won.  Poland prevailed.  Poland will always prevail.  (Applause.)
AUDIENCE:  Donald Trump!  Donald Trump!  Donald Trump!
  PRESIDENT TRUMP:  Thank you.  You were supported in that victory over communism by a strong alliance of free nations in the West that defied tyranny.  Now, among the most committed members of the NATO Alliance, Poland has resumed its place as a leading nation of a Europe that is strong, whole, and free.
A strong Poland is a blessing to the nations of Europe, and they know that.  A strong Europe is a blessing to the West and to the world.  (Applause.)  One hundred years after the entry of American forces into World War I, the transatlantic bond between the United States and Europe is as strong as ever and maybe, in many ways, even stronger.
This continent no longer confronts the specter of communism.  But today we’re in the West, and we have to say there are dire threats to our security and to our way of life.  You see what’s happening out there.  They are threats.  We will confront them.  We will win.  But they are threats.  (Applause.)
AUDIENCE:  Donald Trump!  Donald Trump!  Donald Trump!
  PRESIDENT TRUMP:  We are confronted by another oppressive ideology — one that seeks to export terrorism and extremism all around the globe.  America and Europe have suffered one terror attack after another.  We’re going to get it to stop.  (Applause.)
During a historic gathering in Saudi Arabia, I called on the leaders of more than 50 Muslim nations to join together to drive out this menace which threatens all of humanity.  We must stand united against these shared enemies to strip them of their territory and their funding, and their networks, and any form of ideological support that they may have.  While we will always welcome new citizens who share our values and love our people, our borders will always be closed to terrorism and extremism of any kind.  (Applause.)
AUDIENCE:  Donald Trump!  Donald Trump!  Donald Trump!
  PRESIDENT TRUMP:  We are fighting hard against radical Islamic terrorism, and we will prevail.  We cannot accept those who reject our values and who use hatred to justify violence against the innocent.
Today, the West is also confronted by the powers that seek to test our will, undermine our confidence, and challenge our interests.  To meet new forms of aggression, including propaganda, financial crimes, and cyberwarfare, we must adapt our alliance to compete effectively in new ways and on all new battlefields.
We urge Russia to cease its destabilizing activities in Ukraine and elsewhere, and its support for hostile regimes — including Syria and Iran — and to instead join the community of responsible nations in our fight against common enemies and in defense of civilization itself.  (Applause.)
Finally, on both sides of the Atlantic, our citizens are confronted by yet another danger — one firmly within our control.  This danger is invisible to some but familiar to the Poles:  the steady creep of government bureaucracy that drains the vitality and wealth of the people.  The West became great not because of paperwork and regulations but because people were allowed to chase their dreams and pursue their destinies.
Americans, Poles, and the nations of Europe value individual freedom and sovereignty.  We must work together to confront forces, whether they come from inside or out, from the South or the East, that threaten over time to undermine these values and to erase the bonds of culture, faith and tradition that make us who we are.  (Applause.)  If left unchecked, these forces will undermine our courage, sap our spirit, and weaken our will to defend ourselves and our societies.
But just as our adversaries and enemies of the past learned here in Poland, we know that these forces, too, are doomed to fail if we want them to fail.  And we do, indeed, want them to fail.  (Applause.)  They are doomed not only because our alliance is strong, our countries are resilient, and our power is unmatched.  Through all of that, you have to say everything is true.  Our adversaries, however, are doomed because we will never forget who we are.  And if we don’t forget who are, we just can’t be beaten.  Americans will never forget.  The nations of Europe will never forget.  We are the fastest and the greatest community.  There is nothing like our community of nations.  The world has never known anything like our community of nations.
We write symphonies.  We pursue innovation.  We celebrate our ancient heroes, embrace our timeless traditions and customs, and always seek to explore and discover brand-new frontiers.
We reward brilliance.  We strive for excellence, and cherish inspiring works of art that honor God.  We treasure the rule of law and protect the right to free speech and free expression.  (Applause.)
We empower women as pillars of our society and of our success.  We put faith and family, not government and bureaucracy, at the center of our lives.  And we debate everything.  We challenge everything.  We seek to know everything so that we can better know ourselves.  (Applause.)
And above all, we value the dignity of every human life, protect the rights of every person, and share the hope of every soul to live in freedom.  That is who we are.  Those are the priceless ties that bind us together as nations, as allies, and as a civilization.
What we have, what we inherited from our — and you know this better than anybody, and you see it today with this incredible group of people — what we’ve inherited from our ancestors has never existed to this extent before.  And if we fail to preserve it, it will never, ever exist again.  So we cannot fail.
This great community of nations has something else in common:  In every one of them, it is the people, not the powerful, who have always formed the foundation of freedom and the cornerstone of our defense.  The people have been that foundation here in Poland — as they were right here in Warsaw — and they were the foundation from the very, very beginning in America.
Our citizens did not win freedom together, did not survive horrors together, did not face down evil together, only to lose our freedom to a lack of pride and confidence in our values.  We did not and we will not.  We will never back down.  (Applause.)
AUDIENCE:  Donald Trump!  Donald Trump!  Donald Trump!
  PRESIDENT TRUMP:  As long as we know our history, we will know how to build our future.  Americans know that a strong alliance of free, sovereign and independent nations is the best defense for our freedoms and for our interests.  That is why my administration has demanded that all members of NATO finally meet their full and fair financial obligation.
As a result of this insistence, billions of dollars more have begun to pour into NATO.  In fact, people are shocked.  But billions and billions of dollars more are coming in from countries that, in my opinion, would not have been paying so quickly.
To those who would criticize our tough stance, I would point out that the United States has demonstrated not merely with words but with its actions that we stand firmly behind Article 5, the mutual defense commitment.  (Applause.)
Words are easy, but actions are what matters.  And for its own protection — and you know this, everybody knows this, everybody has to know this — Europe must do more.  Europe must demonstrate that it believes in its future by investing its money to secure that future.
That is why we applaud Poland for its decision to move forward this week on acquiring from the United States the battle-tested Patriot air and missile defense system — the best anywhere in the world.  (Applause.)  That is also why we salute the Polish people for being one of the NATO countries that has actually achieved the benchmark for investment in our common defense.  Thank you.  Thank you, Poland.  I must tell you, the example you set is truly magnificent, and we applaud Poland.  Thank you.  (Applause.)
We have to remember that our defense is not just a commitment of money, it is a commitment of will.  Because as the Polish experience reminds us, the defense of the West ultimately rests not only on means but also on the will of its people to prevail and be successful and get what you have to have.  The fundamental question of our time is whether the West has the will to survive.  Do we have the confidence in our values to defend them at any cost?  Do we have enough respect for our citizens to protect our borders?  Do we have the desire and the courage to preserve our civilization in the face of those who would subvert and destroy it?  (Applause.)
We can have the largest economies and the most lethal weapons anywhere on Earth, but if we do not have strong families and strong values, then we will be weak and we will not survive.  (Applause.)  If anyone forgets the critical importance of these things, let them come to one country that never has.  Let them come to Poland.  (Applause.)  And let them come here, to Warsaw, and learn the story of the Warsaw Uprising.
When they do, they should learn about Jerusalem Avenue.  In August of 1944, Jerusalem Avenue was one of the main roads running east and west through this city, just as it is today.
Control of that road was crucially important to both sides in the battle for Warsaw.  The German military wanted it as their most direct route to move troops and to form a very strong front.  And for the Polish Home Army, the ability to pass north and south across that street was critical to keep the center of the city, and the Uprising itself, from being split apart and destroyed.
Every night, the Poles put up sandbags amid machine gun fire — and it was horrendous fire — to protect a narrow passage across Jerusalem Avenue.  Every day, the enemy forces knocked them down again and again and again.  Then the Poles dug a trench.  Finally, they built a barricade.  And the brave Polish fighters began to flow across Jerusalem Avenue.  That narrow passageway, just a few feet wide, was the fragile link that kept the Uprising alive.
Between its walls, a constant stream of citizens and freedom fighters made their perilous, just perilous, sprints.  They ran across that street, they ran through that street, they ran under that street — all to defend this city.  “The far side was several yards away,” recalled one young Polish woman named Greta.  That mortality and that life was so important to her.  In fact, she said, “The mortally dangerous sector of the street was soaked in the blood.  It was the blood of messengers, liaison girls, and couriers.”
Nazi snipers shot at anybody who crossed.  Anybody who crossed, they were being shot at.  Their soldiers burned every building on the street, and they used the Poles as human shields for their tanks in their effort to capture Jerusalem Avenue.  The enemy never ceased its relentless assault on that small outpost of civilization.  And the Poles never ceased its defense.
The Jerusalem Avenue passage required constant protection, repair, and reinforcement, but the will of its defenders did not waver, even in the face of death.  And to the last days of the Uprising, the fragile crossing never, ever failed.  It was never, ever forgotten.  It was kept open by the Polish people.
The memories of those who perished in the Warsaw Uprising cry out across the decades, and few are clearer than the memories of those who died to build and defend the Jerusalem Avenue crossing.  Those heroes remind us that the West was saved with the blood of patriots; that each generation must rise up and play their part in its defense — (applause) — and that every foot of ground, and every last inch of civilization, is worth defending with your life.
Our own fight for the West does not begin on the battlefield — it begins with our minds, our wills, and our souls.  Today, the ties that unite our civilization are no less vital, and demand no less defense, than that bare shred of land on which the hope of Poland once totally rested.  Our freedom, our civilization, and our survival depend on these bonds of history, culture, and memory.
And today as ever, Poland is in our heart, and its people are in that fight.  (Applause.)  Just as Poland could not be broken, I declare today for the world to hear that the West will never, ever be broken.  Our values will prevail.  Our people will thrive.  And our civilization will triumph.  (Applause.)
AUDIENCE:  Donald Trump!  Donald Trump!  Donald Trump!
  PRESIDENT TRUMP:  Thank you.  So, together, let us all fight like the Poles — for family, for freedom, for country, and for God.
Thank you.  God Bless You.  God bless the Polish people.  God bless our allies.  And God bless the United States of America.
Thank you.  God bless you.  Thank you very much.
</speech>"

# Donald Trump Grade #
step_10_ast <- "This is how I would score the speech above on a range of 0.0 to 2.0, down to the tenths place.
Trump’s speech features a strong and expansive conception of “the people,” grounded in sovereignty, national identity, and religious morality. The American people are described as the ultimate source of power: “the people govern, the people rule, and the people are sovereign.” He frames his presidency as a return of power to these citizens—those who were “forgotten and left behind.” In addition, Trump extends the category of “the people” beyond America’s borders, invoking “good, God-fearing, hard-working” people across allied nations like Poland, all united in the desire to uphold liberty and democratic civilization. While not always framed in explicitly populist terms, the speech strongly suggests that the will of the people is singular, virtuous, and threatened, which is consistent with a populist lens. However, it is worth noting that this “people” are broadly inclusive and nationally defined, rather than class-based or culturally specific.
The anti-elite dimension is present but diffuse. Trump criticizes global bureaucracies, multinational trade deals, and international tribunals for failing ordinary people. He implies that international institutions have become bloated and unaccountable, and that “some governments with egregious human rights records sit on the U.N. Human Rights Council.” These critiques mirror populist narratives about elites who benefit at the expense of the people. However, he does not identify a single, conspiring elite, nor does he portray domestic institutions as corrupt to their core. While bureaucracy is seen as an obstacle to national sovereignty and popular will, it is never framed as an enemy that must be overthrown. Therefore, this aspect of the speech provides moderate populist content, but stops short of the more sharply defined elite antagonism typical of higher-intensity populism.
The Manichaean framing in the speech is pronounced and persistent. Trump casts world politics as a moral battle between good and evil, with clear sides and no moral ambiguity. He invokes “the righteous many” versus “the wicked few,” condemns North Korea’s regime as “twisted” and on a “suicide mission,” and calls out Iran and Venezuela as corrupt, oppressive, and destabilizing. These conflicts are positioned not as geopolitical tensions, but as civilizational showdowns between decency and depravity, freedom and tyranny, life and death. He often connects these themes to divine authority, invoking “almighty God” and using religious language to elevate the stakes. These features give the speech a clearly moralized and cosmic tone, matching core traits of populist Manichaeanism. However, as feedback notes, the absence of a clearly defined elite enemy tempers this dimension, making the speech Manichaean, but not radically populist.
Trump’s speech includes limited pluralist gestures, primarily framed through mutual respect among sovereign nations. He affirms that “we do not seek to impose our way of life on anyone” and emphasizes that “strong, sovereign nations let diverse countries with different values… work side by side.” While this framing respects difference, it is bounded by a sovereignty-first worldview that views international engagement as conditional and transactional. Trump’s tone toward institutions like the UN is skeptical, but not fully rejectionist. He affirms the legitimacy of collective global action—particularly against terrorism—but insists that it must be driven by the will and interest of strong nation-states. These features point to a selective pluralism grounded in nationalism and mutual benefit, rather than inclusive deliberation or democratic diversity. Pluralism is present, but marginal to the speech’s overall structure.
This speech is imperfectly populist. It combines a strong moralized worldview, an assertive invocation of “the people,” and pointed anti-elite sentiment, but stops short of full-blown populism due to the lack of a clearly defined internal elite and the presence of some pluralist themes. Its moral clarity, sovereign nationalism, and people-centric rhetoric mark it as robustly populist in tone and structure, but not maximalist. Hence, the score of 0.9 is well-supported.
Here is how I would fill out the rubric:
  Populist elements in Trump’s speech
Category 1: Manichaean Vision of the World:
  Speech quotes:
  ‘If the righteous many do not confront the wicked few, then evil will triumph.’
‘Do we have the desire and the courage to preserve our civilization in the face of those who would subvert and destroy it?’
‘We are fighting hard against radical Islamic terrorism, and we will prevail.’
Category 2: Cosmic Proportions and Historical Reification:
  Speech quotes:
  ‘We know that these forces, too, are doomed to fail if we want them to fail. And we do, indeed, want them to fail. They are doomed not only because our alliance is strong, our countries are resilient, and our power is unmatched… Our adversaries, however, are doomed because we will never forget who we are.’
‘And so I am here today not just to visit an old ally, but to hold it up as an example for others who seek freedom and who wish to summon the courage and the will to defend our civilization.’
‘Just as Poland could not be broken, I declare today for the world to hear that the West will never, ever be broken. Our values will prevail. Our people will thrive. And our civilization will triumph.’
Category 3: Populist Notion of the People:
  Speech quotes:
  ‘It is the people, not the powerful, who have always formed the foundation of freedom and the cornerstone of our defense.’
‘The people have been that foundation here in Poland… and they were the foundation from the very, very beginning in America.’
‘From its very first moments, the American story is the story of what is possible when people take ownership of their future.’
‘Americans, Poles, and the nations of Europe value individual freedom and sovereignty.’
Category 4: The Elite as a Conspiring Evil:
  Speech quotes:
  ‘This danger is invisible to some but familiar to the Poles: the steady creep of government bureaucracy that drains the vitality and wealth of the people.’
‘The West became great not because of paperwork and regulations but because people were allowed to chase their dreams and pursue their destinies.’
Category 5: Systemic Change:
  Speech quotes:
  No quotes
Category 6: Anything Goes Attitude:
  Speech quotes:
  No quotes
Non-Populist elements in Trump’s speech
Category 1: Pluralist Vision of the World
Speech quotes:
  No quotes
Category 2: Concrete Interpretation of Political Issues
Speech quotes:
  ‘That is why my administration has demanded that all members of NATO finally meet their full and fair financial obligation.’
‘Poland… is acquiring from the United States the battle-tested Patriot air and missile defense system — the best anywhere in the world.’
Category 3: Democracy as Calculation of Votes of Individual Citizens
Speech quotes:
  No quotes
Category 4: Non-Antagonistic View of Opponents
Speech quotes:
  No quotes
Category 5: Incremental Reform
Speech quotes:
  No quotes
Category 6: Commitment to Institutional Norms, Rights, and Liberties
Speech quotes:
  ‘To those who would criticize our tough stance, I would point out that the United States has demonstrated not merely with words but with its actions that we stand firmly behind Article 5, the mutual defense commitment.’
In this speech, President Trump identifies a strong, but very broad and inclusive sense of ‘the people.’ ‘The people’ are the good, God-fearing, hard-working citizens in Poland, the US, and elsewhere in the US. These people have a clear, unified will—to uphold the values of democracy. He hints at ways that this will is undermined, by conspiring terrorists from without and by the insidious growth of bureaucracy from within. However, he does not ever really specifically identify one evil elite. He ascribes cosmic implications to the present moment, calling upon great religious and national Polish heroes (Copernicus, Pope John Paul II) as examples of those who have paved the way before, and the speech in Manichaean in the sense that every issue is strongly moral, and there can be no debate about which side to stand on. But again, this is tempered by the lack of any real conspiring elite. Thus, even with the Manichaean tone and the strong will of the people, this speech is imperfectly populist. It garners a score of 0.9."

# Tony Abbott Speech #
step_11_user <- "Read the speech and code the level of populism (0-2 to the tenth place):

<speech>
Tony Abbott Campaign Launch Speech: Full Transcript. August 25, 2013.

I am so proud of my girls. I am proud of my family that has given me so much. I am so proud of my team and I am so proud of our country.
Again, I want to speak directly to you, the Australian people.
This election is about making a great country even better; and that starts with changing the worst government in our history.
I will spend the next two weeks reassuring people that there is a better way while Mr Rudd will spend the next two weeks trying to scare you about what might happen if he doesn't keep his job.
Mr Rudd thinks this election is all about him.
Well, it's not about him and it's not about me.
It's about you and how a better government can help your family and make your job more secure.
This election is the most important in a generation.
It pits the Liberal and National parties' positive plans for the future against more of the same from a confused and chaotic Labor Party.
We are a great country and a great people but we can't afford another three years like the last six.
Yes, we need a new way but to get a new way we have to choose a new government: a new government with a positive plan to restore the hope, reward and opportunity that should be your birth right.
This is what a Liberal and National Party government will do.
We'll build a stronger economy so everyone can get ahead.
We'll scrap the carbon tax so your family will be $550 a year better off.
We'll get the budget back under control by ending Labor's waste.
We'll stop the boats.
And we'll build the roads of the 21st century because I hope to be an infrastructure prime minister who puts bulldozers on the ground and cranes into our skies.
We have a plan and we know how to pay for it.
We'll end Labor's big waste – like the $11.5 billion in border protection cost blowouts.
We'll end Labor's small waste – like the $180,000 that the Department of Human Services spent studying ergonomic chairs.
And we'll end Labor's ridiculous waste – like selling the parliamentary billiards tables for $5000.
Then they spent another $100,000 on an investigation into why they were sold for so little.
We know that you expect us to be as frugal and prudent with your money, which we hold on trust from you, as you would be with your own hard-earned savings.
We understand, deep in our DNA, that you can't have a strong society and strong communities without strong economies to sustain them and you can't have a strong economy without profitable private businesses.
We know that a stronger economy is not about picking winners but about helping everyone to get ahead.
We understand that government doesn't create wealth, people do; and that no country has ever taxed its way to prosperity.
We'll abolish the carbon tax so power prices and gas prices will go down.
We'll abolish the mining tax so investment and employment will go up.
We'll cut the company tax rate because, as the former Treasury Chief has said, the main beneficiaries will be workers.
We'll cut red tape by $1 billion a year every year because the businesses of Australia should be competing, innovating, marketing, investing and employing, rather than simply lobbying government for more favourable rules or the best possible handout.
We'll move the workplace relations pendulum back to the sensible centre, restore a strong cop-on-the-beat in the construction industry, and hit dodgy union officials with the same penalties as corporate crooks.
I want our workers to be the best paid in the world and for that to happen, we have to be amongst the most productive in the world.
I want us to be a better country, not just a richer one, but you don't build a better society by issuing a press release.
Unlike Labor, my colleagues and I understand that a strong economy is the foundation of better communities.
It's much easier, after all, to persuade people to do more for others when it doesn't involve robbing Peter to pay Paul.
On day one of an incoming Coalition government, I will instruct the public service to prepare the carbon tax repeal legislation.
I will give the directions needed to commence Operation Sovereign Borders.
The Clean Energy Finance Corporation will cease making non-commercial loans with taxpayers' money.
And the motor industry will be saved from Mr Rudd's $1.8 billion tax on company cars.
From day one, it will be obvious that Australia is under new management and once more open for business.
Within one hundred days, legislation to abolish the carbon tax and to abolish the mining tax will be in the Parliament.
The Australian Building and Construction Commission will be running again, and the true state of Labor's books will be revealed.
The NBN will have a new business plan to ensure that every household gains five times current broadband speeds – within three years and without digging up almost every street in Australia – for $60 billion less than Labor.
By the end of a Coalition government's first term, the budget will be on-track to a believable surplus.
The WestConnex in Sydney, the East West Link in Melbourne, the Gateway Upgrade here in Brisbane, the North South Road in Adelaide, and the Swan Bypass in Perth will be well and truly underway.
A standing Green Army, rising to be 15,000 strong, will be working with councils, farmers and volunteers to clean up our polluted waterways and restore our degraded bush.
And the National Disability Insurance Scheme will be operating in large parts of every state.
We won't shirk hard decisions.
We've already announced $17 billion in sensible savings.
We'll trim the commonwealth public sector payroll by 12,000 through natural attrition because we don't need 20,000 more public servants now than in 2007.
We won't continue the school kids' bonus because it's a cash splash with borrowed money that our children will have to repay.
We can't continue the low income super offset because it's funded by a mining tax that's not raising any money.
We'll delay the superannuation guarantee levy increase because it's another cost that small business can't afford right now.
And we won't increase the humanitarian migrant intake until such time as it's no longer being filled by people smugglers.
There will be no new spending under a Coalition government that's not fully-costed and fully-funded.
That way, we can be confident that the budget will return to surplus as quickly as possible.
By the end of a Coalition government's first term, working with the states, teacher standards will be rising and teaching programmes will be improving.
People who are capable of working will be working, preferably for a wage but if not, for the dole.
And there will be a fair dinkum paid parental leave scheme in place, because factory workers and shop assistants deserve to get their actual wage while they are on leave - just like public servants do.
Our paid parental leave scheme is all upside for small business and families.
We must be a country that rewards people for having a go – but we must never leave anyone behind.
That's why I announce today that an incoming Coalition government will finally index eligibility thresholds for the Commonwealth Seniors Health Card so that more self-funded retirees will have access to cheaper medicines.
As well, an incoming Coalition government will commit an additional $200 million to dementia research to help the 300,000 Australians who have it today and to help the 900,000 at risk of having it in 30 years' time as our population gets older.
The best people to find treatments and cures for this insidious disease are our world-beating medical researchers.
Finally, an incoming Coalition government will help more young Australians to start a trade, stay in a trade and finish a trade by giving apprentices access to a $20,000 loan, like university students have.
This will be available to the 60,000 mostly young Australians who next year will start learning the trade skills that are in short supply – the electrical, plumbing, carpentry, cooking, welding and mechanical apprenticeships – that only half of them, on current figures, will finish.
This is a hand-up – not a handout – for people who will meet our skills needs for the next 40 years.
Choosing a trade, no less than going to university, is a good way to make something of your life.
If our vision is realised, within 10 years, Australia will have lower, simpler, fairer taxes.
There will be two million more jobs, in manufacturing as well as in agriculture, services, education and a still buoyant resources sector.
We'll have a more functional federation where the states are sovereign in their own sphere.
The infrastructure gap will be filled – with the Pacific Highway duplicated, the Midland Highway upgraded and the Bruce Highway flood-proofed.
Public schools and hospitals will have far more freedom to be as good as their private rivals.
Childcare will be more affordable and more available to families who need more than one income and who have to cope in a 24/7 economy.
Within a decade, the budget surplus will be 1 per cent of GDP, defence spending will be 2 per cent of GDP, the private health insurance rebate will be fully restored, and each year, government will be a smaller percentage of our economy.
Starting next year, I will work to recognise indigenous people in the constitution - something that should have been done a century ago that would complete our constitution rather than change it.
As long as I am in public life, I will continue to spend a week a year in a remote indigenous community as I've done over the past decade.
Because, if they're good enough for people to live in, they should be good enough for a prime minister to stay in.
And in indigenous communities, no less than in every Australian community, the kids should go to school, the adults should go to work, and the ordinary law of the land should be upheld.
My vision for Australia is not that big brother government knows best; it's that our country will best flourish when all of our citizens, individually and collectively, have the best chance to be their best selves.
Government's job is rarely to tell people what to do; mostly, it's to make it easier for people to make their own choices.
Over the next three years, should we win the election, an incoming Coalition government will do exactly what we've said we'll do.
We will be a no surprises, no excuses government, because you are sick of nasty surprises and lame excuses from people that you have trusted with your future...
It's performance, not promises, that will earn your respect; it's actions, not words, that you are looking for.
For the past three years, the Coalition has had the same strong, united team and the same clear plans.
You could trust us in opposition and you will be able to trust us in government.
After all, the best possible preparation for being a strong and effective government is being a strong and effective opposition - especially when 16 members of the shadow cabinet were ministers in the last government that stopped the boats and brought the budget back into the black.
You don't expect miracles; just a government that is competent and trustworthy and a prime minister who doesn't talk down to you.
And I'm confident that your expectations can be more than met.
An incoming Coalition cabinet will respect the limits of government as well as its potential and will never seek to divide Australian against Australian on the basis of class, gender, or where people were born.
When I look at workers and managers, I don't see people trying to rip each other off but people trying to get ahead together as a team.
When I look at skilled migrants coming to Australia to work and pay taxes from day one, I don't see people who are stealing Aussie jobs but people who are building our country; and who have come here to join us, not to change us.
When I look at small business people, I don't see people who need to be regulated and controlled for their own good but people who have mortgaged their houses to employ their staff and serve their customers.
When I look at farmers and fishermen and foresters, I don't see people despoiling the environment but people who are our best conservationists because that is the only way that their children and grandchildren can follow the same calling.
When I look at pensioners and superannuants, I don't see people who are a drain on the taxpayer but people who have built the country that I am lucky enough to live in.
When I look at the benefits that all Australians rightly enjoy such as Medicare and good public schools and hospitals, I don't see “middle class welfare” but the hallmarks of a society that gives families a fair go.
I am fundamentally optimistic because I know that tomorrow can be better than today when it's built on the values that last.
After the previous Liberal and National party government gave you the four largest surpluses in our history the current government has given you the five largest deficits in our history.
But the worst deficit is not the budget deficit but the trust deficit.
This election is all about trust.
Who do you trust to reduce power prices and gas prices?
  Trust the party that will abolish the carbon tax, not the one that inflicted it on you.
Who do you trust to get debt and deficit under control?
  Trust the party that left you $50 billion in the bank, not the one that squandered your inheritance.
Who do you trust to stop the boats?
  Trust the party that solved the problem not the one that started it up again.
Mr Rudd knows that his government has failed – that's why he never talks about his record.
He knows that the carbon tax has been a disaster – that's why he's faked abolishing it.
He knows that the Labor Party has become a national embarrassment – that's why he's faked reforming it.
He knows that a serious country can't lose control of its borders – that's why he's faked a PNG solution that's taken scarcely 10 per cent of the 3,000 new boat people that have arrived in just five weeks.
He knows that no one wants another three years like the last six; that's why his campaign is not about what he has done but what he says that I might do.
He says that a Coalition government would sack nurses and teachers even though we don't employ any ... and sell schools and hospitals ... even though we don't own any.
So not only is Mr Rudd leading the most incompetent government in our history, he's now running the most dishonest election campaign in our history.
And it will just get worse over the next two weeks as the unions spend $12 million on the mother of all scare campaigns.
I make this pledge to you the Australian people.
I will govern for all Australians.
I want to lift everyone's standard of living.
I want to see wages and benefits rise in line with a growing economy.
I want to see our hospitals and schools improving as we invest the proceeds of a well-run economy into the things that really count.
I won't let you down.
This is my pledge to you.
The last time Mr Rudd was prime minister, his own party sacked him.
When a desperate party put him back, one third of the cabinet resigned rather than serve with him.
So my question is this: if the people who've worked with Mr Rudd don't trust him, why should you?
The Labor Party has form when it comes to telling you to put your trust in people who don't deserve it.
In 2004, Labor told you to trust Mark Latham and you know what happened to him.
In 2007, Labor told you to trust Kevin Rudd, and you know what happened to him then.
In 2010, Labor told you to trust Julia Gillard and you know what happened to her.
Now Labor is telling you to trust Kevin Rudd again - but the one thing you know is that you can't trust what Labor tells you.
The current government has turned a $20 billion surplus into deficits stretching out as far as the eye can see.
The current government has turned $50 billion in the bank into debt spiralling towards $400 billion that our children and grandchildren will struggle to repay.
We can't go on like this.
As you know from bitter experience, if you reward bad behaviour, you get more of it.
If you reward failure, you just get more failure...
To Labor voters wondering why your party has sold its soul to the Greens; to Green voters wondering why your party has embraced socialism over environmentalism; to independent voters wondering why your MP has sided with a bad government, to everyone who has been let down and embarrassed by the circus in Canberra,
I say: give my team a chance.
I'm confident that our best years are ahead of us, but not if we have another three years like the last six.
Choose change, and the last six years will soon seem like an aberration.
Choose change, and we'll send a signal to people in authority that we can forgive honest mistakes but not persistent incompetence and deception.
Choose change, and there are few problems that cannot be improved.
But the only way to choose change is to vote for your Liberal and National candidate.
We have the plan, we have the team and we are ready.
That's the choice I urge you to make.
For your family's sake, for our country;
Join us.
</speech>"

# Tony Abbott Grade #
step_11_ast <- "Here is my thought process and grade:
  Abbott’s speech references “the Australian people” as the intended beneficiaries of his policies, but does not construct them as a morally pure or sovereign force. He emphasizes his intention to govern “for all Australians,” to “lift everyone’s standard of living,” and to help “your family” and “your job” — framing the people in practical, inclusive terms. However, there is no romanticized notion of a unified, virtuous will of the people, nor any call to reclaim politics on their behalf. “The people” are treated as recipients of good governance, not as protagonists in a moral struggle. This makes the speech lightly populist in tone, but non-populist in structure on this dimension.
The speech contains a clear but narrowly focused anti-elite component, aimed primarily at the incumbent Labor government. Abbott accuses Kevin Rudd and the Labor Party of leading “the most incompetent government in our history,” and of running a “dishonest election campaign.” He highlights financial mismanagement and suggests that the government has broken trust with the public. While these critiques are sharp, they remain partisan rather than systemic — Abbott does not attack institutions themselves or construct a wide-ranging narrative of elite betrayal. Still, his repeated emphasis on “trust” and “failure” makes the anti-elite tone moderately populist, even if it is aimed only at a rival party.
The moral contrast between parties is present, but not deeply developed. Abbott does frame the election as a choice between “change” and “more of the same,” and refers to Labor’s actions as deceptive and wasteful. He urges voters to reject “persistent incompetence and deception,” which implies a clear binary between responsible and irresponsible leadership. However, the speech does not rise to the level of cosmic or existential moralism. There is no portrayal of politics as a battle between good and evil or between the people and a dark force. Instead, Abbott’s Manichaean framing is best understood as rhetorical contrast typical of campaign discourse, not as full populist moral dualism.
Abbott’s speech demonstrates a strong respect for pluralism and democratic norms, which is a major reason why it does not qualify as fully populist. He explicitly commits to not dividing Australians by class, gender, or origin, and he affirms the value of diverse groups including skilled migrants, retirees, business owners, and workers. He describes government’s role as enabling individual choice, not controlling behavior. These statements reflect institutional modesty, democratic inclusion, and a belief in governance by competence — not rupture. Unlike stronger populist rhetoric, this speech does not challenge the legitimacy of political institutions, but rather aims to reform and lead them more effectively. This pluralist framing helps temper the populist features, justifying its score just below the midpoint of the scale.
Tony Abbott’s campaign speech is partially populist, with a clear anti-Labor critique and rhetorical appeals to “the people,” but it avoids populism’s full structure. It lacks a mythologized people, does not propose a battle against a corrupt system, and affirms liberal-democratic pluralism. While the critique of Labor is bordering on populist, they are not painted as the evil conspiring elite that real populist would, but mostly as incompetent politicians. These features explain why, although it contains populist notes, it is best described as mostly non-populist with some moderate populist tones — consistent with a 0.45 rating.
Here is how I would fill out the rubric:
  Populist elements in Abbott’s speech
Category 1: Manichaean Vision of the World:
  Speech quotes:
  ‘Choose change, and we'll send a signal to people in authority that we can forgive honest mistakes but not persistent incompetence and deception.’
 ‘This election is the most important in a generation. It pits the Liberal and National parties' positive plans for the future against more of the same from a confused and chaotic Labor Party.’
‘So not only is Mr Rudd leading the most incompetent government in our history, he's now running the most dishonest election campaign in our history.’
Category 2: Cosmic Proportions and Historical Reification:
 Speech quotes:
 No quotes
Category 3: Populist Notion of the People:
 Speech quotes:
 ‘Again, I want to speak directly to you, the Australian people.’
 ‘It’s not about him and it’s not about me. It’s about you and how a better government can help your family and make your job more secure.’
 ‘My vision for Australia is not that big brother government knows best; it's that our country will best flourish when all of our citizens… have the best chance to be their best selves.’
‘Government’s job is rarely to tell people what to do; mostly, it’s to make it easier for people to make their own choices.’
Category 4: The Elite as a Conspiring Evil:
  Speech quotes:
  ‘He knows that the carbon tax has been a disaster – that's why he's faked abolishing it.’
‘The current government has turned a $20 billion surplus into deficits stretching out as far as the eye can see.’
‘You are sick of nasty surprises and lame excuses from people that you have trusted with your future.’
Category 5: Systemic Change:
  Speech quotes:
  No quotes
Category 6: Anything Goes Attitude:
  Speech quotes:
  No quotes
Non-Populist elements in Abbott’s speech
Category 1: Pluralist Vision of the World:
  Speech quotes:
  ‘An incoming Coalition cabinet will… never seek to divide Australian against Australian on the basis of class, gender, or where people were born.’
‘When I look at skilled migrants coming to Australia… I don't see people who are stealing Aussie jobs but people who are building our country.’
Category 2: Concrete Interpretation of Political Issues:
 Speech quotes:
 ‘We'll scrap the carbon tax so your family will be $550 a year better off.’
‘The NBN will have a new business plan… for $60 billion less than Labor.’
Category 3: Democracy as Calculation of Votes of Individual Citizens:
  Speech quotes:
  No quotes
Category 4: Non-Antagonistic View of Opponents:
  Speech quotes:
  No quotes
Category 5: Incremental Reform:
  Speech quotes:
  ‘There will be no new spending under a Coalition government that's not fully-costed and fully-funded.’
 ‘We'll trim the commonwealth public sector payroll by 12,000 through natural attrition.’
Category 6: Commitment to Institutional Norms, Rights, and Liberties:
  Speech quotes:
  ‘Government’s job is rarely to tell people what to do; mostly, it’s to make it easier for people to make their own choices.’
‘The best possible preparation for being a strong and effective government is being a strong and effective opposition.’
Although this speech has populist elements, it is largely non-populist. The notion of a romanticized will of the people is not really present; however, he does discuss benefiting the whole Australian population with his policies. He defines the Labour party as being a corrupt political elite, but he also openly respects democratic institutions. I would give this a 0.45."

# Final part of prompt #
final_prompt_intro

## Building the complete prompt ------------------------------------------------

# Version for GPT o4-mini (doesn't accept user/system roles)
build_CoT_prompt.GPT <- function(target_speech) {
  prompt_1 <- paste0(
    intro_system, "\n\n",
    
    # Step 1
    "## INPUT USER: ## ", step_1_user, "\n",
    "## OUTPUT ASSISTENT: ## ", step_1_ast, "\n\n",
    
    # Step 2: Holistic Grading
    "## INPUT USER: ## ", step_2_user, "\n",
    "## OUTPUT ASSISTENT: ## ", step_2_ast, "\n\n",
    
    # Step 3: Rubric Explanation
    "## INPUT USER: ## ", step_3_user, "\n\n",
    "## OUTPUT ASSISTENT: ## ", step_3_ast, "\n\n",
    
    # Step 3.2: Training
    "## INPUT USER: ## ", step_3.2_user, "\n\n",
    "## OUTPUT ASSISTENT: ## ", step_3.2_ast, "\n\n",
    
    # Step 4: Training
    "## INPUT USER: ## ", step_4_user, "\n\n",
    "## OUTPUT ASSISTENT: ## ", step_4_ast, "\n\n",
    
    # Step 5: Training
    "## INPUT USER: ## ", step_5_user, "\n\n",
    "## OUTPUT ASSISTENT: ## ", step_5_ast, "\n\n",
    
    # Step 6: Training
    "## INPUT USER: ## ", step_6_user, "\n\n",
    "## OUTPUT ASSISTENT: ## ", step_6_ast, "\n\n",
    
    # Step 7: Training
    "## INPUT USER: ## ", step_7_user, "\n\n",
    "## OUTPUT ASSISTENT: ## ", step_7_ast, "\n\n",
    
    # Step 8: Training
    "## INPUT USER: ## ", step_8_user, "\n\n",
    "## OUTPUT ASSISTENT: ## ", step_8_ast, "\n\n",
    
    # Step 9: Training
    "## INPUT USER: ## ", step_9_user, "\n\n",
    "## OUTPUT ASSISTENT: ## ", step_9_ast, "\n\n",
    
    # Step 10: Training
    "## INPUT USER: ## ", step_10_user, "\n\n",
    "## OUTPUT ASSISTENT: ## ", step_10_ast, "\n\n",
    
    # Step 11: Training
    "## INPUT USER: ## ", step_11_user, "\n\n",
    "## OUTPUT ASSISTENT: ## ", step_11_ast, "\n\n",
    
    # Speech we want to code
    "<INPUT> ## SPEECH TO CODE ## \n", target_speech, "\n\n",
    
    # Step 4: Final Query
    final_prompt_intro)
  return(prompt_1)
}

# Version for general use (with user/system roles)
build_CoT_prompt <- function(target_speech) {
  messages <- list(
    list(role = "system", content = intro_system),
    list(role = "user", content = step_1_user),
    list(role = "assistant", content = step_1_ast),
    list(role = "user", content = step_2_user),
    list(role = "assistant", content = step_2_ast),
    list(role = "user", content = step_3_user),
    list(role = "assistant", content = step_3_ast),
    list(role = "user", content = step_3.2_user),
    list(role = "assistant", content = step_3.2_ast),
    list(role = "user", content = step_4_user),
    list(role = "assistant", content = step_4_ast),
    list(role = "user", content = step_5_user), 
    list(role = "assistant", content = step_5_ast),
    list(role = "user", content = step_6_user),
    list(role = "assistant", content = step_6_ast),
    list(role = "user", content = step_7_user),
    list(role = "assistant", content = step_7_ast),
    list(role = "user", content = step_8_user),
    list(role = "assistant", content = step_8_ast),
    list(role = "user", content = step_9_user),
    list(role = "assistant",  content = step_9_ast),
    list(role = "user", content = step_10_user),
    list(role = "assistant", content = step_10_ast),
    list(role = "user", content = step_11_user),
    list(role = "assistant",  content = step_11_ast),
    list(role = "user", content = paste0("## SPEECH TO CODE ## \n", target_speech, "\n\n", final_prompt_intro))
  )
  return(messages)
}

# For Qwen 3, to turn off the "thinking" mode:
build_CoT_prompt_nt <- function(target_speech) {
  messages <- list(
    list(role = "system", content = intro_system),
    list(role = "user", content = step_1_user),
    list(role = "assistant", content = step_1_ast),
    list(role = "user", content = step_2_user),
    list(role = "assistant", content = step_2_ast),
    list(role = "user", content = step_3_user),
    list(role = "assistant", content = step_3_ast),
    list(role = "user", content = step_3.2_user),
    list(role = "assistant", content = step_3.2_ast),
    list(role = "user", content = step_4_user),
    list(role = "assistant", content = step_4_ast),
    list(role = "user", content = step_5_user), 
    list(role = "assistant", content = step_5_ast),
    list(role = "user", content = step_6_user),
    list(role = "assistant", content = step_6_ast),
    list(role = "user", content = step_7_user),
    list(role = "assistant", content = step_7_ast),
    list(role = "user", content = step_8_user),
    list(role = "assistant", content = step_8_ast),
    list(role = "user", content = step_9_user),
    list(role = "assistant",  content = step_9_ast),
    list(role = "user", content = step_10_user),
    list(role = "assistant", content = step_10_ast),
    list(role = "user", content = step_11_user),
    list(role = "assistant",  content = step_11_ast),
    list(role = "user", content = paste0("## SPEECH TO CODE ## \n", target_speech, "\n\n", final_prompt_intro, "/no_think"))
  )
  return(messages)
}




