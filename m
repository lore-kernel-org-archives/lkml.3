Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbaKEQo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:44:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbaKEQoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:44:25 -0500
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: Sangbeom Kim <sbkim73@samsung.com>, alsa-devel@alsa-project.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ASoC: samsung: Add MODULE_DEVICE_TABLE for Snow
Date: Wed,  5 Nov 2014 17:44:52 +0100
Message-Id: <1415205892-5553-1-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables the snd_soc_snow module to be auto-loaded.

Fixes: da5993df2374 ("ASoC: samsung: Add sound card driver for Snow board")
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 Tested using patches for Spring, but should apply to Snow/Peach-pi equally.
 Rebased onto sound.git for-next branch.

 sound/soc/samsung/snow.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/samsung/snow.c b/sound/soc/samsung/snow.c
index 0acf5d0eed53..72118a77dd5b 100644
--- a/sound/soc/samsung/snow.c
+++ b/sound/soc/samsung/snow.c
@@ -110,6 +110,7 @@ static const struct of_device_id snow_of_match[] = {
 	{ .compatible = "google,snow-audio-max98095", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, snow_of_match);
 
 static struct platform_driver snow_driver = {
 	.driver = {
-- 
2.1.2

