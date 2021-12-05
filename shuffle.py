import random
import pandas as pd

# ╋╋╋╋╋╋╋┏┓╋╋╋╋╋╋╋╋╋╋╋╋┏┓
# ╋╋╋╋╋╋╋┃┃╋╋╋╋╋╋╋╋╋╋╋╋┃┃
# ┏━━┳┓╋┏┫┗━┳━━┳━┳━━┳━━┫┃┏━━━┓
# ┃┏━┫┃╋┃┃┏┓┃┃━┫┏┫┏┓┃┏┓┃┃┣━━┃┃
# ┃┗━┫┗━┛┃┗┛┃┃━┫┃┃┗┛┃┏┓┃┗┫┃━━┫
# ┗━━┻━┓┏┻━━┻━━┻┛┗━┓┣┛┗┻━┻━━━┛
# ╋╋╋┏━┛┃╋╋╋╋╋╋╋╋┏━┛┃
# ╋╋╋┗━━┛╋╋╋╋╋╋╋╋┗━━┛

# read csv
galz_ipfs_url_list  = pd.read_csv('./galz_ipfs_url_list.csv')
galz_holders_list   = pd.read_csv('./galz_holders_list.csv')

chainlinkRandomNumber = "" # gonna be implemented after VRF transaction

# changes from dataframe to pandas
galz_ipfs_url_list.to_numpy
galz_holders_list.to_numpy

# shuffle via seed from ChainLinkVRF
random.Random(chainlinkRandomNumber).shuffle(galz_ipfs_url_list)
random.Random(chainlinkRandomNumber).shuffle(galz_holders_list)

# concatenate results to DataFrame
shuffle_reveal_result = pd.DataFrame(pd.np.column_stack([galz_ipfs_url_list, galz_holders_list]))

# save csv from result
shuffle_reveal_result.to_csv('./shuffle_reveal_result.csv', index = False)