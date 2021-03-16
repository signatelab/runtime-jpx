import transformers
from transformers import BertJapaneseTokenizer

transformers.BertModel.from_pretrained("cl-tohoku/bert-base-japanese-whole-word-masking")
BertJapaneseTokenizer.from_pretrained("cl-tohoku/bert-base-japanese-whole-word-masking")
