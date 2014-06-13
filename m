Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaFMFry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 01:47:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16670 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaFMFrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 01:47:53 -0400
X-AuditID: cbfee68f-b7fef6d000003970-0e-539a908712f5
From: Shahina Shaik <shahina.s@samsung.com>
To: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, broonie@kernel.org, lgirdwood@gmail.com
Cc: sharab.shaik@gmail.com, shahina.s@gmail.com
Subject: [PATCH 1/2] SOUND: TLV320AIC32x4: Fixed Coding style Issues
Date: Fri, 13 Jun 2014 11:18:47 +0530
Message-id: <1402638528-5787-1-git-send-email-shahina.s@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkVrd9wqxgg9U3OC2uXDzEZDH14RM2
	i29XOpgsLu+aw2bRuauf1WLpkz+MFt+OT2C0eLn5DZMDh8eGz01sHjtn3WX32LSqk81j39tl
	bB6bT1d7fN4kF8AWxWWTkpqTWZZapG+XwJXx+dBKloKr3BV3Ty5hb2D8xNnFyMkhIWAi8ffl
	SUYIW0ziwr31bF2MXBxCAksZJa6+uswOU7R8fj8ziC0ksIhRYs8ZaYiiXiaJR1/uAXVzcLAJ
	aEu8n+cEUiMi0M4ocexWMojNLKAvsfDhdTYQW1jARWLnjhNgy1gEVCXePlnPCmLzAsW3N84C
	GyMhoCAxZ5INyHgJgX52iRkbD7BC1AtIfJt8iAWiRlZi0wFmiNMkJQ6uuMEygVFwASPDKkbR
	1ILkguKk9CJjveLE3OLSvHS95PzcTYzAID7971n/Dsa7B6wPMSYDjZvILCWanA+MgrySeENj
	MyMLUxNTYyNzSzPShJXEee8/TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwBh1u/2vJK+L
	Xc2F3IjbX55+OekgGjrFcGbTD6HuL8kXJ314/+RCcFG+sTxLup7r36qNiu5rji/9/XDBt4/p
	XwzeJbV+6t6Xf7y8/Ly4ZfGZ2UvX8JwOPGujZatnInblt+eE1/H69TH8lmVrO97oiW+ULDDK
	4jq0OmfRkVY/75y5+7mm+K7hjVNiKc5INNRiLipOBADKMoKDeAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t9jAd32CbOCDdq1La5cPMRkMfXhEzaL
	b1c6mCwu75rDZtG5q5/VYumTP4wW345PYLR4ufkNkwOHx4bPTWweO2fdZffYtKqTzWPf22Vs
	HptPV3t83iQXwBbVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk
	4hOg65aZA3SPkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj86GVLAVX
	uSvunlzC3sD4ibOLkZNDQsBEYvn8fmYIW0ziwr31bCC2kMAiRok9Z6S7GLmA7F4miUdf7jF2
	MXJwsAloS7yf5wRSIyLQzihx7FYyiM0soC+x8OF1sF5hAReJnTtOMILYLAKqEm+frGcFsXmB
	4tsbZ4GNkRBQkJgzyWYCI/cCRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMER8kx6B+Oq
	BotDjAIcjEo8vAHvZwYLsSaWFVfmHmKU4GBWEuG91zArWIg3JbGyKrUoP76oNCe1+BBjMtDy
	icxSosn5wOjNK4k3NDYxNzU2tTSxMDGzJE1YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbG
	FXf3tK3mnputqHB6tQ3rrY3SoYIzJ2iu84r83ZDfkL18duqe06/TXQT2vWJd6NCf4XLM9baj
	ecTvxYU9P5vL46zdWdfWzBWMmhwbsozt9/dL4ca5R8Qep3NVTvn67fI99x2bGW/bdD/+FrDt
	Ea9Awrb3Z3t/7Gaec9/FeLbWhZClLluVn55+qMRSnJFoqMVcVJwIAEPIFg/UAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shahina Shaik <sharab.shaik@gmail.com>

Fixed a brace coding style issue in the tlv320aic32x4.c

Signed-off-by: Shahina Shaik <sharab.shaik@gmail.com>
---
 sound/soc/codecs/tlv320aic32x4.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index 1d9b117..1e50f15 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -626,21 +626,18 @@ static int aic32x4_probe(struct snd_soc_codec *codec)
 		snd_soc_write(codec, AIC32X4_MICBIAS, AIC32X4_MICBIAS_LDOIN |
 						      AIC32X4_MICBIAS_2075V);
 	}
-	if (aic32x4->power_cfg & AIC32X4_PWR_AVDD_DVDD_WEAK_DISABLE) {
+	if (aic32x4->power_cfg & AIC32X4_PWR_AVDD_DVDD_WEAK_DISABLE)
 		snd_soc_write(codec, AIC32X4_PWRCFG, AIC32X4_AVDDWEAKDISABLE);
-	}
 
 	tmp_reg = (aic32x4->power_cfg & AIC32X4_PWR_AIC32X4_LDO_ENABLE) ?
 			AIC32X4_LDOCTLEN : 0;
 	snd_soc_write(codec, AIC32X4_LDOCTL, tmp_reg);
 
 	tmp_reg = snd_soc_read(codec, AIC32X4_CMMODE);
-	if (aic32x4->power_cfg & AIC32X4_PWR_CMMODE_LDOIN_RANGE_18_36) {
+	if (aic32x4->power_cfg & AIC32X4_PWR_CMMODE_LDOIN_RANGE_18_36)
 		tmp_reg |= AIC32X4_LDOIN_18_36;
-	}
-	if (aic32x4->power_cfg & AIC32X4_PWR_CMMODE_HP_LDOIN_POWERED) {
+	if (aic32x4->power_cfg & AIC32X4_PWR_CMMODE_HP_LDOIN_POWERED)
 		tmp_reg |= AIC32X4_LDOIN2HP;
-	}
 	snd_soc_write(codec, AIC32X4_CMMODE, tmp_reg);
 
 	/* Mic PGA routing */
-- 
1.7.9.5

