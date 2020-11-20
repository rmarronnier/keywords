require "spec"
require "../src/keywords"
STOP_WORDS = File.read("#{__DIR__}/en.txt").split("\n") # .to_set
TEXTTT     = "Nuclear fusion is a reaction in which two or more atomic nuclei are combined to form one or more different atomic nuclei and subatomic particles (neutrons or protons). The difference in mass between the reactants and products is manifested as either the release or the absorption of energy. This difference in mass arises due to the difference in atomic binding energy between the nuclei before and after the reaction. Fusion is the process that powers active or main sequence stars and other high-magnitude stars, where large amounts of energy are released.

A fusion process that produces nuclei lighter than iron-56 or nickel-62 will generally release energy. These elements have relatively small mass per nucleon and large binding energy per nucleon. Fusion of nuclei lighter than these releases energy (an exothermic process), while fusion of heavier nuclei results in energy retained by the product nucleons, and the resulting reaction is endothermic. The opposite is true for the reverse process, nuclear fission. This means that the lighter elements, such as hydrogen and helium, are in general more fusible; while the heavier elements, such as uranium, thorium and plutonium, are more fissionable. The extreme astrophysical event of a supernova can produce enough energy to fuse nuclei into elements heavier than iron.

In 1920, Arthur Eddington suggested hydrogen-helium fusion could be the primary source of stellar energy. Quantum tunneling was discovered by Friedrich Hund in 1929, and shortly afterwards Robert Atkinson and Fritz Houtermans used the measured masses of light elements to show that large amounts of energy could be released by fusing small nuclei. Building on the early experiments in nuclear transmutation by Ernest Rutherford, laboratory fusion of hydrogen isotopes was accomplished by Mark Oliphant in 1932. In the remainder of that decade, the theory of the main cycle of nuclear fusion in stars was worked out by Hans Bethe. Research into fusion for military purposes began in the early 1940s as part of the Manhattan Project. Fusion was accomplished in 1951 with the Greenhouse Item nuclear test. Nuclear fusion on a large scale in an explosion was first carried out on 1 November 1952, in the Ivy Mike hydrogen bomb test.

Research into developing controlled fusion inside fusion reactors has been ongoing since the 1940s, but the technology is still in its development phase."

TEXT = "I don't think there's much reading material because it's largely based on opinionated philosophy. So it's definitely not a technical reason.

Crystal often favors a little bit more explicitness compared to Ruby, with the goal of reducing surprises. Here, I think it's easy to argue that calling some method on a Hash turns it into an Array, rather than changing the internal ordering a Hash has, can be a bit surprising offhand. In Ruby this happens because Hash is Enumerable and sort_by is an Enumerable method and the key thing to understand here is that in terms of Enumerable a Hash is a list of pairs and that's what sort_by operates on. But internalizing this connection is quite some cognitive overhead to ask for.

So in Crystal so far we preferred to make this conversion a little bit more explicit, and the code a little bit more intention revealing. It literally says there, I want an ordered list of pairs, ordered by the following criteria.

Reiterating my previous point, personally I had very few cases where I ended up wanting to have the features of a map structure, that is constant time lookup of a value by some unique key, and the features of a list structure, that is a defined ordering between some values, at the same time. In fact this feature combination is so seldom that many standard libraries don't offer any possibility for it, or at least do not provide it in the standard map type but rather a special one. Anyways, the few cases where I personally encountered this desire turned out to be quite indicative of me not having found the right datastructure for my problem yet, often simply realizing I didn't actually need one of the two features I talked about above and thus making the resulting program easier to reason about by using the other structure. This is what I meant when I said this is a code smell to me, it's an indication to me that I should be revisiting something.

Personally I wouldn't even use the term one-liner for the expression above, which I tend to use for common transformations on some data structure that usually have a much higher complexity than a call to to_a :)

So, why does that little to_a bother you so much? :) Maybe your data should never be a Hash in the first place?"

# STOP_WORDS = File.read(Cadmium::Tokenizer.StopWords + "en.txt").split("\n").to_set

TEXTT = "A 72-year-old voter in Dayton, Ohio, said, “I’m angry about everything.” A retired veterinary technician in Detroit said she voted for one reason only: “Donald Trump. To make sure he’s not reelected.” A federal employee who waited in line for 10 hours in suburban Atlanta explained simply: “I have three Black sons.”

Two weeks before Election Day, Black Americans have voted in striking numbers, helping to drive historic levels of early voting as mail ballots have flooded election offices and people have endured huge lines to cast ballots in person across the country.

In interviews in 10 states where early voting is underway, Black voters said this year’s presidential election is the most important of their lifetime — some calling it more consequential even than 2008, when those who were old enough went to the polls in record numbers to make Barack Obama the country’s first Black president.

They spoke of a sense of urgency to protect the nation’s democracy, and their role in it, which they believe a second Trump term would erode beyond repair. Many said they view the president as a racist who cannot bring himself to disavow white supremacists or the year’s spate of police killings of unarmed Black Americans, and they believe the country is less safe for themselves and their families.

Over and over again, Black Americans described their vote this year as much more than a choice between two presidential candidates, but as an urgent stand in the long fight against racial injustice in America, which the year’s events have made clear is not yet over.

“We shouldn’t be where we’re at in 2020,” said Tasha Grant, 44, a nurse who voted in Charlotte on Thursday and hopes her vote for the Democratic nominee, former vice president Joe Biden, will ensure that her children grow up in a safer, more accepting world.

“Especially my son,” she said. “It doesn’t matter if he’s smart and an ‘A’ student. People still see him as a Black male.”

Turnout numbers in states with available data show a surge of Black participation in the first few days of in-person voting. In North Carolina, which began early voting Thursday, Black voters accounted for more than 30 percent of turnout on the first day — well above their 23 percent share overall in 2016. In Georgia, Black voters accounted for about 32 percent of mail ballots and in-person votes cast through Thursday, so far outpacing their overall share of the electorate in 2016."

TTEXX = "The Democratic governor’s emergency directive to stem new COVID-19 infections in the state put a 25% capacity limit on the number of people who may gather indoors until Nov. 6. It was challenged in court by bar owners and others shortly after it was issued on Oct. 6, and blocked by a judge on Oct. 14.

Sarah Kleban, 19, a sophomore at the University of Wisconsin-La Crosse who works as a waitress back home in Milwaukee, said she depended on tips from patrons to make ends meet, but still sided with the governor.

“A 25% limit really hurts, but I think we need to put people’s safety first,” Kleban said. “If we have to choose between wages or safety, we have to be safe.”

Wisconsin, one of several battleground states in the Nov. 3 U.S. presidential election, is scrambling to contain a resurgence that officials fear could overwhelm the state’s hospitals.

“This critically important ruling will help us prevent the spread of this virus by restoring limits on public gatherings,” Evers said in a statement.

A national group representing nursing home administrators on Monday warned that they were starting to see an acceleration in coronavirus infections among their highly vulnerable residents that parallels the increases in the general population.

Nursing homes, which were devastated in the early weeks of the pandemic last spring, could soon experience a third spike in cases, said the American Health Care Association and National Center for Assisted Living.

Wisconsin is one of five states where more than 20% of COVID-19 tests are coming back positive. Local health officials last week warned about “very intense community spread in all age groups” as they announced a string of grim records.

Even so, a field hospital erected at fairgrounds outside Milwaukee to treat COVID-19 patients should local hospitals run out of beds remained empty as of Sunday, according to Wisconsin health authorities.

In New Mexico, the governor warned on Monday that the state’s healthcare resources might not be sufficient if coronavirus cases continue to rise at the current pace.

“If COVID-19 continues to exponentially spread like last week, New Mexico will not have the health care and hospital capacity for every New Mexican who needs care,” Governor Michelle Lujan Grisham, a Democrat, wrote in a tweet.

FALL SURGE
The number of new COVID-19 cases in the United States last week rose 13% to more than 393,000, approaching levels last seen during a summer peak, according to a Reuters analysis. [nL1N2HA0XY]

Thirty-four of 50 states have seen cases increase for at least two weeks in a row, up from 29 the prior week.

They include Pennsylvania, Ohio, Michigan and North Carolina — all swing states in the U.S. election, in which the Trump administration’s handling of the coronavirus pandemic has become a critical issue.

Deaths fell 2% to about 4,900 people for the week ended Oct. 18, according to the analysis of state and county reports. Since the outbreak started, nearly 220,000 people in the country have died and over 8.1 million have become infected.

After coronavirus infections in nursing homes dropped for seven consecutive weeks from a peak of 10,125 in late July, the number of cases rose in the final week of September, according to data cited by the nursing home association, which represents more than 14,000 facilities.

COVID-19-related deaths at nursing homes have been trending lower from 3,222 per week in late May to 1,060 at the end of September, the group said.

“We could still see another wave of COVID cases caused by the sheer volume of rising cases in communities across the U.S., given the asymptomatic and pre-symptomatic spread of this virus,” AHCA/NCAL President Mark Parkinson said in a statement.

The group said its member nursing homes need more testing supplies, personal protective equipment and staff to prevent a new outbreak."

OSDIFOPISDF = "The count, laughing, nudged the blushing Sonya and pointed
to her former adorer.
“Do you recognize him?” said he. “And where has he sprung

from?” he asked, turning to Shinshin. “Didn’t he vanish some-
where?”

“He did,” replied Shinshin. “He was in the Caucasus and ran
away from there. They say he has been acting as minister to some
ruling prince in Persia, where he killed the Shah’s brother. Now
all the Moscow ladies are mad about him! It’s ‘Dolokhov the
Persian’ that does it! We never hear a word but Dolokhov is
mentioned. They swear by him, they offer him to you as they
would a dish of choice sterlet. Dolokhov and Anatole Kuragin
have turned all our ladies’ heads.”
A tall, beautiful woman with a mass of plaited hair and much
exposed plump white shoulders and neck, round which she wore
a double string of large pearls, entered the adjoining box rustling
her heavy silk dress and took a long time settling into her place.
Natasha involuntarily gazed at that neck, those shoulders, and
pearls and coiffure, and admired the beauty of the shoulders and

the pearls. While Natasha was fixing her gaze on her for the sec-
ond time the lady looked round and, meeting the count’s eyes,

nodded to him and smiled. She was the Countess Bezukhova,
Pierre’s wife, and the count, who knew everyone in society,
leaned over and spoke to her.
“Have you been here long, Countess?” he inquired. “I’ll call,
I’ll call to kiss your hand. I’m here on business and have brought
my girls with me. They say Semenova acts marvelously. Count
Pierre never used to forget us. Is he here?”

“Yes, he meant to look in,” answered Helene, and glanced at-
tentively at Natasha.

Count Rostov resumed his seat."
