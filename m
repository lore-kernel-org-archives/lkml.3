Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaFMG2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:28:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25481 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaFMGZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:25:58 -0400
X-AuditID: cbfee690-b7fb56d000003439-c4-539a9974c3e4
From: Shahina Shaik <shahina.s@samsung.com>
To: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Shahina Shaik <sharab.shaik@gmail.com>
Subject: [PATCH 4/4] Sound: tlv320aic31xx: Fixed Coding Style Issues
Date: Fri, 13 Jun 2014 11:56:54 +0530
Message-id: <1402640814-7037-1-git-send-email-shahina.s@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkWrdk5qxgg86jphZXLh5ispj68Amb
	xbcrHUwWl3fNYbPo3NXPavHt+ARGi5eb3zA5sHts+NzE5rFz1l12j02rOtk89r1dxuax+XS1
	x+dNcgFsUVw2Kak5mWWpRfp2CVwZ057cZym4ylGxc/ExxgbGmexdjJwcEgImEjv23GaEsMUk
	Ltxbz9bFyMUhJLCUUWL3idtwRbd/7GCCSExnlOh6epgRwullkji04hhzFyMHB5uAtsT7eU4g
	DSIC7YwSDx+CTWUW0JL4f30NE4gtLOAisa/hMCuIzSKgKrHx6FmwGl6g+P6Fb5lAxkgIKEjM
	mWQDsbebXeLP0lqIcgGJb5MPsUCUyEpsOsAMUSIpcXDFDZYJjIILGBlWMYqmFiQXFCelF5no
	FSfmFpfmpesl5+duYgSG7ul/zybsYLx3wPoQYzLQuInMUqLJ+cDQzyuJNzQ2M7IwNTE1NjK3
	NCNNWEmcV+1RUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxnS/1aLfVl55nCGweqH3Xh3r
	uyoPtrZ/99MUEN/Qf0pyvreMVISBm8O6F7OW6nc5sm9IfGHS9v18JPcJ+YDuPfOElp06ILjz
	ypu8eSslTr6+rOLOM8NhQ9Ly8k9qN5d/rBD+e/FG+l6vfCUV/t+uos5dK61qLryJPbNnzqUn
	77UOd+9ImfuadboSS3FGoqEWc1FxIgAlpWAXcwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t9jQd2SmbOCDVqua1lcuXiIyWLqwyds
	Ft+udDBZXN41h82ic1c/q8W34xMYLV5ufsPkwO6x4XMTm8fOWXfZPTat6mTz2Pd2GZvH5tPV
	Hp83yQWwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6
	ZeYA3aKkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzJj25D5LwVWOip2L
	jzE2MM5k72Lk5JAQMJG4/WMHE4QtJnHh3nq2LkYuDiGB6YwSXU8PM0I4vUwSh1YcY+5i5OBg
	E9CWeD/PCaRBRKCdUeLhQ0YQm1lAS+L/9TVgg4QFXCT2NRxmBbFZBFQlNh49C1bDCxTfv/At
	E8gYCQEFiTmTbCYwci9gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERwbz6R3MK5qsDjE
	KMDBqMTDG/B+ZrAQa2JZcWXuIUYJDmYlEd57DbOChXhTEiurUovy44tKc1KLDzEmAy2fyCwl
	mpwPjNu8knhDYxNzU2NTSxMLEzNL0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamAUWi/Y
	lXLA7nVFxOIPs9X8r97eHZA864ZtzcSitz8XOllHX6l1O3Bcryz8tEiKSZJMfdWz3qUPvu8+
	xVuZPUevTv3d3/713Hc3To3boz2jsn3H+rI7N2Yf/fus8L9RfueHDO3jEz9MlZkfu+l3ntX1
	YDO7b9Xz8oMunxC89FSISWKn6ULOo/yHlViKMxINtZiLihMB8XlUQ9ECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shahina Shaik <sharab.shaik@gmail.com>

Fixed coding style issues of "Missing Blank line after declaration"
Signed-off-by: Shahina Shaik <sharab.shaik@gmail.com>
---
 sound/soc/codecs/tlv320aic31xx.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/tlv320aic31xx.c b/sound/soc/codecs/tlv320aic31xx.c
index 2341910..a9c4a8b 100644
--- a/sound/soc/codecs/tlv320aic31xx.c
+++ b/sound/soc/codecs/tlv320aic31xx.c
@@ -329,6 +329,7 @@ static int aic31xx_wait_bits(struct aic31xx_priv *aic31xx, unsigned int reg,
 	unsigned int bits;
 	int counter = count;
 	int ret = regmap_read(aic31xx->regmap, reg, &bits);
+
 	while ((bits & mask) != wbits && counter && !ret) {
 		usleep_range(sleep, sleep * 2);
 		ret = regmap_read(aic31xx->regmap, reg, &bits);
@@ -435,6 +436,7 @@ static int mic_bias_event(struct snd_soc_dapm_widget *w,
 {
 	struct snd_soc_codec *codec = w->codec;
 	struct aic31xx_priv *aic31xx = snd_soc_codec_get_drvdata(codec);
+
 	switch (event) {
 	case SND_SOC_DAPM_POST_PMU:
 		/* change mic bias voltage to user defined */
-- 
1.7.9.5

