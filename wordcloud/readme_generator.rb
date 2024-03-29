require_relative "./cloud_types"

class ReadmeGenerator
  WORD_CLOUD_URL = 'https://raw.githubusercontent.com/Skyline-9/Skyline-9/master/wordcloud/wordcloud.png'
  ADDWORD = 'add'
  SHUFFLECLOUD = 'shuffle'
  INITIAL_COUNT = 3
  USER = "Skyline-9"

  def initialize(octokit:)
    @octokit = octokit
  end

  def generate
    participants = Hash.new(0)
    current_contributors = Hash.new(0)
    current_words_added = INITIAL_COUNT
    total_clouds = CloudTypes::CLOUDLABELS.length
    total_words_added = INITIAL_COUNT * total_clouds

    octokit.issues.each do |issue|
      participants[issue.user.login] += 1
      if issue.title.split('|')[1] != SHUFFLECLOUD && issue.labels.any? { |label| CloudTypes::CLOUDLABELS.include?(label.name) }
        total_words_added += 1
        if issue.labels.any? { |label| label.name == CloudTypes::CLOUDLABELS.last }
          current_words_added += 1
          current_contributors[issue.user.login] += 1
        end
      end
    end

    markdown = <<~HTML
### Hey there <img src="https://media.giphy.com/media/hvRJCLFzcasrR4ia7z/giphy.gif" width="25px">

![](https://shields-io-visitor-counter.herokuapp.com/badge?page=skyline-9.skyline-9&style=for-the-badge&logo=Github)<img src="https://media.giphy.com/media/mGcNjsfWAjY5AEZNw6/giphy.gif" width="50">

  Hi, I'm [Richard Luo](https://skyline-9.github.io/), a student at Georgia Tech's College of Computing with threads in Artificial Intelligence and Information/Internetworks. Currently, I'm working as a Research Assistant in Georgia Tech's Robot Autonomy and Interactive Learning (RAIL) Lab under the supervision of Professor Sonia Chernova. In the past, I've worked as a Cybersecurity Analyst for Georgia Tech's Security Operations Center and as an undergraduate researcher in Professor Wenke Lee's lab working on remote privacy-preserving biometric authentication.
  
- 💬 I love to meet new people, so feel free to reach out and connect with me
- 📫 How to reach me: [LinkedIn](https://www.linkedin.com/in/richardluorl)
- 📝 [Resume](https://skyline-9.github.io/static/media/resume.a70c8a38ff48c4180c73.pdf)

<details>
<summary><b>📈My GitHub Stats</b>: </summary>

  
<img src="https://github-readme-stats.vercel.app/api?username=skyline-9&show_icons=true&theme=radical&count_private=true&hide=issues" alt="skyline-9" />

</details>

**🛠  Tech Stack**

![](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![](https://img.shields.io/badge/C%2B%2B-00599C?style=for-the-badge&logo=c%2B%2B&logoColor=white)
![](https://img.shields.io/badge/C-00599C?style=for-the-badge&logo=c&logoColor=white)
![](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![](https://img.shields.io/badge/numpy-%23013243.svg?style=for-the-badge&logo=numpy&logoColor=white)
![](https://img.shields.io/badge/TensorFlow-%23FF6F00.svg?style=for-the-badge&logo=TensorFlow&logoColor=white)
![](https://img.shields.io/badge/opencv-%23white.svg?style=for-the-badge&logo=opencv&logoColor=white)
![](https://img.shields.io/badge/pandas-%23150458.svg?style=for-the-badge&logo=pandas&logoColor=white)
![](https://img.shields.io/badge/HTML-239120?style=for-the-badge&logo=html5&logoColor=white)
![](https://img.shields.io/badge/CSS-239120?&style=for-the-badge&logo=css3&logoColor=white)
![](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)
![](https://img.shields.io/badge/react-%2320232a.svg?style=for-the-badge&logo=react&logoColor=%2361DAFB)
![](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
![](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)


![](https://camo.githubusercontent.com/105b60ce28ec05ae23246c58638645c12cbdab6a1f5860309eb407e0aea90545/68747470733a2f2f696d6775722e636f6d2f72696c485678412e706e67)
    
## Join the Community Word Cloud :cloud: :pencil2:

### :thought_balloon: [Click Here To Add A Word](https://github.com/Skyline-9/Skyline-9/issues/new?template=addword.md&title=wordcloud%7C#{ADDWORD}%7C%3CINSERT-WORD%3E) to see the word cloud update in real time

A new word cloud will be automatically generated when you [add your own word](https://github.com/Skyline-9/Skyline-9/issues/new?template=addword.md&title=wordcloud%7C#{ADDWORD}%7C%3CINSERT-WORD%3E). The prompt will change frequently, so be sure to come back and check it out :relaxed:

:game_die: Don't like the arrangement of the current word cloud? [Regenerate it](https://github.com/Skyline-9/Skyline-9/issues/new?template=shufflecloud.md&title=wordcloud%7C#{SHUFFLECLOUD})

<div align="center">

## #{CloudTypes::CLOUDPROMPTS.last}

<img src="#{WORD_CLOUD_URL}" alt="WordCloud" width="100%">

![Word Cloud Words Badge](https://img.shields.io/badge/Words%20in%20this%20Cloud-#{current_words_added}-informational?labelColor=7D898B&style=for-the-badge)
![Word Cloud Contributors Badge](https://img.shields.io/badge/Contributors%20this%20Cloud-#{current_contributors.size}-blueviolet?labelColor=7D898B&style=for-the-badge)

    HTML

    # TODO: [![Github Badge](https://img.shields.io/badge/-@username-24292e?style=flat&logo=Github&logoColor=white&link=https://github.com/username)](https://github.com/username)

    current_contributors.each do |username, count|
      markdown.concat("[![Github Badge](https://img.shields.io/badge/-@#{format_username(username)}-24292e?style=for-the-badge&logo=Github&logoColor=white&link=https://github.com/#{username})](https://github.com/#{username}) ")
    end

    # markdown.concat("\n\n Check out the [previous word cloud](#{previous_cloud_url}) to see our community's **#{CloudTypes::CLOUDPROMPTS[-2]}**")

    markdown.concat("</div>")
  end

  private

  def format_username(name)
    name.gsub('-', '--')
  end

  def previous_cloud_url
    url_end = CloudTypes::CLOUDPROMPTS[-2].gsub(' ', '-').gsub(':', '').gsub('?', '').downcase
    "https://github.com/Skyline-9/Skyline-9/blob/master/previous_clouds/previous_clouds.md##{url_end}"
  end

  attr_reader :octokit
end
