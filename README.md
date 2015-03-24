transvoyage
===========

Transform Wikivoyage article from a language to another.

== How to use the script ==

- Use Ubuntu or another Linux. Might work on Mac too.
- Download latest English Wikivoyage listings CSV from http://datahub.io/dataset/wikivoyage-listings-as-csv
- Put the CSV in the same directory as this script
- If you want to generate Toronto, execute in a terminal: ./en2fr.sh Toronto
- The last output line tells you the output file. Open that file and paste to Wikivoyage.

== How to adapt the script for other languages ==

You can easily adapt the script to transform English→Italian or English→Hebrew for instance (the source has to be English, transforming from another language than English would be much more difficult).

- Register on Github
- Click "Fork" at https://github.com/nicolas-raoul/transvoyage
- Find an Ubuntu or Linux or Mac computer
- Install Git
- Run a `git clone git@github.com:yourname/transvoyage.git` command as explained on your fork's page
- Test the script `en2fr.sh`, as described in the section above.
- Copy `en2fr.sh` to `en2ja.sh` for instance
- Open `en2ja.sh` with a text editor
- Find the line that contains `{{Bannière page}}`. This section is the skeleton of the destination article. Replace everything as you see fit but do not touch to anything that starts with a `$` sign.
- Test the script `en2ja.sh`, as described in the section above.
- Find the line that contains `{{Voir`. This section is the skeleton for each "See" listing. Replace everything as you see fit but do not touch to anything that starts with a `$` sign (feel free to reorder them though).
- Test again.
- Repeat for all other listing types.
- Perform a final test.
- Important: Contribute your changes so that others can use your script: Run `git add en2ja.sh; git commit -m "Added script"; git push`, then send me a pull request or contact me via Wikivoyage.
