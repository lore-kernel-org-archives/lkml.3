Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaBJVZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:25:38 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:56542 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702AbaBJVZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:25:33 -0500
Message-ID: <1392067531.27939.19.camel@x220>
Subject: [PATCH] ASoC: smdk_wm8994: Fix typo "wm8894"
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Mon, 10 Feb 2014 22:25:31 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Feb 2014 21:25:31.0529 (UTC) FILETIME=[A0720F90:01CF26A6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) This typo was introduced in commit 0d47acc4ffaa ("ASoC: smdk_wm8994:
Make driver name more unique").

1) So currently there's a difference between platform_drive.driver.name
and the (sub)string used in MODULE_ALIAS(). If I'd understand the
platform_driver interface I might have been able to say whether that
difference is only cosmetic or might actually break stuff. But I don't
understand it so I can't say. I can't even say whether this typo shows
up in some interface to user space.

2) Entirely untested.

 sound/soc/samsung/smdk_wm8994.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/samsung/smdk_wm8994.c b/sound/soc/samsung/smdk_wm8994.c
index d38ae98..682eb4f 100644
--- a/sound/soc/samsung/smdk_wm8994.c
+++ b/sound/soc/samsung/smdk_wm8994.c
@@ -202,7 +202,7 @@ static int smdk_audio_probe(struct platform_device *pdev)
 
 static struct platform_driver smdk_audio_driver = {
 	.driver		= {
-		.name	= "smdk-audio-wm8894",
+		.name	= "smdk-audio-wm8994",
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(samsung_wm8994_of_match),
 		.pm	= &snd_soc_pm_ops,
-- 
1.8.5.3

