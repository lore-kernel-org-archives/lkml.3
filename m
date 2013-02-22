Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3BVIKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:10:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:42752 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3BVIKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:10:11 -0500
X-AuditID: cbfee68f-b7f656d000000d78-1d-512727e12759
From: Boojin Kim <boojin.kim@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, alsa-devel@alsa-project.org
Cc: "'Vinod Koul'" <vinod.koul@intel.com>, "'Dan Williams'" <djbw@fb.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Sangbeom Kim'" <sbkim73@samsung.com>
References: 
In-reply-to: 
Subject: [PATCH v2 4/4] ASoC: samsung: add to configure dma maxburst size
Date: Fri, 22 Feb 2013 17:10:10 +0900
Message-id: <001c01ce10d4$088ea3c0$19abeb40$%kim@samsung.com>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Q0zRNgYHsZtryQK2Zcgnt7X5e4wAABD9gAAAJYXAAACCDgA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t8zQ92H6uqBBp3/LCwu75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDIWrxEt+MNa0dK1i72B8R9LFyMnh4SAicSHvRvZIGwx
	iQv31gPZXBxCAssYJVb8WsTYxcgBVrRihgdEfBGjxLan25ggnL+MEj/P7mYG6WYT0JSY8X06
	O4gtIrCZUWLy6yyQImaB00wSCy63M4NMEhLglljdHARSwynAI7HuTydYWFjAU+LdixiQMIuA
	qsTE79vYQcK8ArYSr08ZQpygLvHory7EcCeJl0segy1iFhCR2PfiHSPIIgmB72wSU49OYYIY
	IyDxbfIhFoheWYlNB5ghXpSUOLjiBssERtFZSNoXMDKuYhRNLUguKE5KLzLWK07MLS7NS9dL
	zs/dxAgJ5v4djHcPWB9iTAYaPZFZSjQ5HxgNeSXxhsbGJmYmpibmlqbmpqQJK4nzyl+SCRQS
	SE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAWGZUIPmmeNZ838IPTn5PZ61M+jRdoONwZE5Xxg4n
	FUujuzc5pz9Q2bP+YoBLxyoxi02bpeb0zrqavDpJaMKncyzfp0YrpUXWFjrHdPZq22x9dvfl
	1c7eNa8/fWU+fPNty+SlAkxmc2Nz3Axi9cRFgg5Y1Tew8Wv9/s77o+PV+dhFaQ92nc7UVWIp
	zkg01GIuKk4EAI/AC258AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t9jAd2H6uqBBrt6jC0u75rDZjHj/D4m
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzFq8RLfjDWtHS
	tYu9gfEfSxcjB4eEgInEihkeXYycQKaYxIV769m6GLk4hAQWMUpse7qNCcL5yyjx8+xuZpAq
	NgFNiRnfp7OD2CICmxklJr/OAiliFjjNJLHgcjszyFQhAW6J1c1BIDWcAjwS6/50goWFBTwl
	3r2IAQmzCKhKTPy+jR0kzCtgK/H6lCHEOeoSj/7qQgx3kni55DHYImYBEYl9L94xTmDkn4XE
	XcDIuIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOFaeSe1gXNlgcYhRgINRiYe3wUUtUIg1
	say4MvcQowQHs5II7yIF9UAh3pTEyqrUovz4otKc1OJDjMlA901klhJNzgfGcV5JvKGxiZmR
	pZGZhZGJuTlpwkrivIynngQICaQnlqRmp6YWpBbBbGHi4JRqYOxLe/Hjt1Z9mK1qeNuCT+Ib
	fshu8xeTU5KM45N95rmgYOLXVI2Zh1OFd8ye/e3Fn/ho6Q/r3Yun9kueP7VhVuzF9+s622bs
	m3rGb561H2PG7IwHHPY2U++1qQU537zJX2GrsNbuT+ak2369on0BvXfzzy4zMNW78t/+Zya/
	V0gOz5Zo81wLFyWW4oxEQy3mouJEAFUvlKzZAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds to configure dma maxburst size.

Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
---
 sound/soc/samsung/dma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
index 21b7926..bd4faa0 100644
--- a/sound/soc/samsung/dma.c
+++ b/sound/soc/samsung/dma.c
@@ -172,6 +172,7 @@ static int dma_hw_params(struct snd_pcm_substream *substream,
 			(substream->stream == SNDRV_PCM_STREAM_PLAYBACK
 			? DMA_MEM_TO_DEV : DMA_DEV_TO_MEM);
 		config.width = prtd->params->dma_size;
+		config.maxburst = 1;
 		config.fifo = prtd->params->dma_addr;
 		prtd->params->ch = prtd->params->ops->request(
 				prtd->params->channel, &req, rtd->cpu_dai->dev,
--
1.7.5.4



