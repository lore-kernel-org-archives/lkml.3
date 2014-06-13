Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaFMFsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 01:48:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32892 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaFMFry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 01:47:54 -0400
X-AuditID: cbfee690-b7fb56d000003439-bb-539a90889399
From: Shahina Shaik <shahina.s@samsung.com>
To: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, broonie@kernel.org, lgirdwood@gmail.com
Cc: sharab.shaik@gmail.com, shahina.s@gmail.com
Subject: [PATCH 2/2] SOUND: TLV320AIC32x4: Fixed Coding Style Issues
Date: Fri, 13 Jun 2014 11:18:48 +0530
Message-id: <1402638528-5787-2-git-send-email-shahina.s@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1402638528-5787-1-git-send-email-shahina.s@samsung.com>
References: <1402638528-5787-1-git-send-email-shahina.s@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkRrdjwqxgg6VbxS2uXDzEZDH14RM2
	i29XOpgsLu+aw2bRuauf1WLpkz+MFt+OT2C0eLn5DZMDh8eGz01sHjtn3WX32LSqk81j39tl
	bB6bT1d7fN4kF8AWxWWTkpqTWZZapG+XwJXxqmsKe8Fk7op59+6yNzBe4+xi5OSQEDCRuPHu
	ATOELSZx4d56ti5GLg4hgaWMEqeub2SCKdq6dSEzRGIRo8SattcsEE4vk8SPD0eAMhwcbALa
	Eu/nOYE0iAi0M0ocu5UMYjML6EssfHidDcQWFnCRWLv4ESOIzSKgKrHk3HbWLkZ2Dl6g+B5F
	kCESAgoScybZgBRwCrhK3Nn2hB3EFgIqeHhwCtgFEgLr2CV2vP7LAjFFQOLb5EMsEL2yEpsO
	QL0iKXFwxQ2WCYzCCxgZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmIEhvzpf88m7GC8d8D6
	EGMy0LiJzFKiyfnAmMkriTc0NjOyMDUxNTYytzQjTVhJnFftUVKQkEB6YklqdmpqQWpRfFFp
	TmrxIUYmDk6pBsYpSwVuVNj3/WW4aNLS9N/XPjBAqWjaLx/tI+c+J771eanxr6t02y69Q3Hb
	phz/tc1yT+dcm9M3lshqHmnaGvbu50pBq2NiEycrbay58XiqSnWhFF+o7OeMOYti38ntMpyq
	ZcXFp/b05+ErVxv+3dgkwDNx6a4p6+fyGL/p0JtzND3sd1OZttNxJZbijERDLeai4kQAZzQ/
	kY8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jAd2OCbOCDR4/47W4cvEQk8XUh0/Y
	LL5d6WCyuLxrDptF565+VoulT/4wWnw7PoHR4uXmN0wOHB4bPjexeeycdZfdY9OqTjaPfW+X
	sXlsPl3t8XmTXABbVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqt
	kotPgK5bZg7QQUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjFddU9gL
	JnNXzLt3l72B8RpnFyMnh4SAicTWrQuZIWwxiQv31rN1MXJxCAksYpRY0/aaBcLpZZL48eEI
	UBUHB5uAtsT7eU4gDSIC7YwSx24lg9jMAvoSCx9eZwOxhQVcJNYufsQIYrMIqEosObedtYuR
	nYMXKL5HEWSIhICCxJxJNiAFnAKuEne2PWEHsYWACh4enMI8gZF3ASPDKkbR1ILkguKk9Fwj
	veLE3OLSvHS95PzcTYzgiHomvYNxVYPFIUYBDkYlHt6A9zODhVgTy4orcw8xSnAwK4nw3muY
	FSzEm5JYWZValB9fVJqTWnyIMRnopInMUqLJ+cBozyuJNzQ2MTc1NrU0sTAxsyRNWEmc92Cr
	daCQQHpiSWp2ampBahHMFiYOTqkGxt4zrqwMHyK33Dw5+/vMu5NmtfO87o9Yn5ieff8wv0X6
	GzYhIa7LT+d5PX56NTvttrZVfmSL2VelO0f2HXr5d82zbU463TPqTX9dcXLpM5vMuvfkxOOr
	Vnn/YLHhM2U8nf9vr6WokdV+p6050f56B/7cWuklw5cQ1xQSJyCR+3R33LO02hOSXEosxRmJ
	hlrMRcWJADLRUSLsAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shahina Shaik <sharab.shaik@gmail.com>

Fixed Coding style issues of lines over 80 characters.

Signed-off-by: Shahina Shaik <sharab.shaik@gmail.com>
---
 sound/soc/codecs/tlv320aic32x4.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index 1e50f15..89e41d2 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -642,13 +642,17 @@ static int aic32x4_probe(struct snd_soc_codec *codec)
 
 	/* Mic PGA routing */
 	if (aic32x4->micpga_routing & AIC32X4_MICPGA_ROUTE_LMIC_IN2R_10K)
-		snd_soc_write(codec, AIC32X4_LMICPGANIN, AIC32X4_LMICPGANIN_IN2R_10K);
+		snd_soc_write(codec, AIC32X4_LMICPGANIN,
+				AIC32X4_LMICPGANIN_IN2R_10K);
 	else
-		snd_soc_write(codec, AIC32X4_LMICPGANIN, AIC32X4_LMICPGANIN_CM1L_10K);
+		snd_soc_write(codec, AIC32X4_LMICPGANIN,
+				AIC32X4_LMICPGANIN_CM1L_10K);
 	if (aic32x4->micpga_routing & AIC32X4_MICPGA_ROUTE_RMIC_IN1L_10K)
-		snd_soc_write(codec, AIC32X4_RMICPGANIN, AIC32X4_RMICPGANIN_IN1L_10K);
+		snd_soc_write(codec, AIC32X4_RMICPGANIN,
+				AIC32X4_RMICPGANIN_IN1L_10K);
 	else
-		snd_soc_write(codec, AIC32X4_RMICPGANIN, AIC32X4_RMICPGANIN_CM1R_10K);
+		snd_soc_write(codec, AIC32X4_RMICPGANIN,
+				AIC32X4_RMICPGANIN_CM1R_10K);
 
 	aic32x4_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
-- 
1.7.9.5

