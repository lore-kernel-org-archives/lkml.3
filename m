Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaKZPPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:15:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59525 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753452AbaKZPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:15:08 -0500
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org, broonie@kernel.org
Cc: cw00.choi@samsung.com, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, ckeepax@opensource.wolfsonmicro.com
Subject: [PATCH V2 6/6] ASoC: arizona: Add support for WM8280/WM8281
Date: Wed, 26 Nov 2014 15:13:08 +0000
Message-Id: <1417014788-8311-7-git-send-email-rf@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1417014788-8311-1-git-send-email-rf@opensource.wolfsonmicro.com>
References: <1417014788-8311-1-git-send-email-rf@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Acked-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/codecs/arizona.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/arizona.c b/sound/soc/codecs/arizona.c
index 9550d74..55b5e22 100644
--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -281,6 +281,7 @@ int arizona_init_gpio(struct snd_soc_codec *codec)
 
 	switch (arizona->type) {
 	case WM5110:
+	case WM8280:
 		snd_soc_dapm_disable_pin(&codec->dapm, "DRC2 Signal Activity");
 		break;
 	default:
@@ -1669,6 +1670,7 @@ static int arizona_calc_fratio(struct arizona_fll *fll,
 
 	switch (fll->arizona->type) {
 	case WM5110:
+	case WM8280:
 		if (fll->arizona->rev < 3 || sync)
 			return init_ratio;
 		break;
-- 
1.7.2.5

