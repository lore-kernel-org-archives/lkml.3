Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbaGVKu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:50:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48424 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524AbaGVKu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:50:26 -0400
Date: Tue, 22 Jul 2014 11:50:22 +0100
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: perex@perex.cz, tiwai@suse.de, broonie@kernel.org
Cc: lgirdwood@gmail.com, Li.Xiubo@freescale.com, lars@metafoo.de,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ASoC: wm5110: Set symmetric samplebits on AIFs
Message-ID: <20140722105022.GB19663@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Different playback and capture bits-per-sample
are not supported on the AIFs

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/wm5110.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index 62ef544..2f2ec26 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -1485,6 +1485,7 @@ static struct snd_soc_dai_driver wm5110_dai[] = {
 		 },
 		.ops = &arizona_dai_ops,
 		.symmetric_rates = 1,
+		.symmetric_samplebits = 1,
 	},
 	{
 		.name = "wm5110-aif2",
@@ -1506,6 +1507,7 @@ static struct snd_soc_dai_driver wm5110_dai[] = {
 		 },
 		.ops = &arizona_dai_ops,
 		.symmetric_rates = 1,
+		.symmetric_samplebits = 1,
 	},
 	{
 		.name = "wm5110-aif3",
@@ -1527,6 +1529,7 @@ static struct snd_soc_dai_driver wm5110_dai[] = {
 		 },
 		.ops = &arizona_dai_ops,
 		.symmetric_rates = 1,
+		.symmetric_samplebits = 1,
 	},
 	{
 		.name = "wm5110-slim1",
-- 
1.7.2.5

