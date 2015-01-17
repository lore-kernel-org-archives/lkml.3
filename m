Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbbAQP04 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 10:26:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42056 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752663AbbAQP0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 10:26:11 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: broonie@kernel.org, cw00.choi@samsung.com, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, rf@opensource.wolfsonmicro.com
Subject: [RESEND PATCH 6/6] ASoC: arizona: Add support for WM8280/WM8281
Date: Sat, 17 Jan 2015 15:21:27 +0000
Message-Id: <1421508087-22311-7-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1421508087-22311-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1421508087-22311-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Acked-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/arizona.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/arizona.c b/sound/soc/codecs/arizona.c
index 0c05e7a..2eb0a47 100644
--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -276,6 +276,7 @@ int arizona_init_gpio(struct snd_soc_codec *codec)
 
 	switch (arizona->type) {
 	case WM5110:
+	case WM8280:
 		snd_soc_dapm_disable_pin(&codec->dapm, "DRC2 Signal Activity");
 		break;
 	default:
@@ -1647,6 +1648,7 @@ static int arizona_calc_fratio(struct arizona_fll *fll,
 
 	switch (fll->arizona->type) {
 	case WM5110:
+	case WM8280:
 		if (fll->arizona->rev < 3 || sync)
 			return init_ratio;
 		break;
-- 
1.7.2.5

