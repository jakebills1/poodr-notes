# procedural ruby script to calculate gear ratios. meaning the difference in number of teeth between different gears
chainring = 52 # number of teeth
cog = 11
ratio = chainring / cog.to_f
puts ratio

chainring = 30
cog = 27
ratio = chainring / cog.to_f
puts ratio
# a gear has chainrings, cogs, and a ratio meaning data and behavior
