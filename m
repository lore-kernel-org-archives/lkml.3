Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaGVKxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:53:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48464 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbaGVKxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:53:01 -0400
Date: Tue, 22 Jul 2014 11:52:56 +0100
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: perex@perex.cz, tiwai@suse.de, broonie@kernel.org
Cc: alsa-devel@alsa-project.org, lars@metafoo.de,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lgirdwood@gmail.com, Li.Xiubo@freescale.com
Subject: [PATCH 3/3] ASoC: wm8997: Set symmetric samplebits on AIFs
Message-ID: <20140722105256.GD19663@opensource.wolfsonmicro.com>
References: <20140722105022.GB19663@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722105022.GB19663@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Different playback and capture bits-per-sample
are not supported on the AIFs

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/wm8997.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/wm8997.c b/sound/soc/codecs/wm8997.c
index bb9b47b..ab33fe5 100644
--- a/sound/soc/codecs/wm8997.c
+++ b/sound/soc/codecs/wm8997.c
@@ -967,6 +967,7 @@ static struct snd_soc_dai_driver wm8997_dai[] = {
 		 },
 		.ops = &arizona_dai_ops,
 		.symmetric_rates = 1,
+		.symmetric_samplebits = 1,
 	},
 	{
 		.name = "wm8997-aif2",
@@ -988,6 +989,7 @@ static struct snd_soc_dai_driver wm8997_dai[] = {
 		 },
 		.ops = &arizona_dai_ops,
 		.symmetric_rates = 1,
+		.symmetric_samplebits = 1,
 	},
 	{
 		.name = "wm8997-slim1",
-- 
1.7.2.5

