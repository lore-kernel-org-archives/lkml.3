Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab3LSPzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:55:54 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:32886 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab3LSPzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:55:46 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, broonie@kernel.org, alsa-devel@alsa-project.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/11] ASoC: ux500_pcm: Take out pointless dev_dbg() call
Date: Thu, 19 Dec 2013 15:55:06 +0000
Message-Id: <1387468508-12286-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_pcm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/sound/soc/ux500/ux500_pcm.c b/sound/soc/ux500/ux500_pcm.c
index 8b53f22..3d1c342 100644
--- a/sound/soc/ux500/ux500_pcm.c
+++ b/sound/soc/ux500/ux500_pcm.c
@@ -65,14 +65,10 @@ static struct dma_chan *ux500_pcm_request_chan(struct snd_soc_pcm_runtime *rtd,
 	struct snd_pcm_substream *substream)
 {
 	struct snd_soc_dai *dai = rtd->cpu_dai;
-	struct device *dev = dai->dev;
 	u16 per_data_width, mem_data_width;
 	struct stedma40_chan_cfg *dma_cfg;
 	struct ux500_msp_dma_params *dma_params;
 
-	dev_dbg(dev, "%s: MSP %d (%s): Enter.\n", __func__, dai->id,
-		snd_pcm_stream_str(substream));
-
 	dma_params = snd_soc_dai_get_dma_data(dai, substream);
 	dma_cfg = dma_params->dma_cfg;
 
-- 
1.8.3.2

