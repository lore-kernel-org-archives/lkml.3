Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbbANLxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:53:49 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:60223 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbbANLxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:53:45 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: alsa-devel@alsa-project.org
Cc: Peter Rosin <peda@axentia.se>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@linaro.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] ASoC: pcm512x: Change register default to match actual content after reset
Date: Wed, 14 Jan 2015 12:52:46 +0100
Message-Id: <1421236370-19826-4-git-send-email-peda@lysator.liu.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421236370-19826-1-git-send-email-peda@lysator.liu.se>
References: <1421236370-19826-1-git-send-email-peda@lysator.liu.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 sound/soc/codecs/pcm512x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/pcm512x.c b/sound/soc/codecs/pcm512x.c
index 355a8543c8b1..78dc3306d2f2 100644
--- a/sound/soc/codecs/pcm512x.c
+++ b/sound/soc/codecs/pcm512x.c
@@ -78,7 +78,7 @@ static const struct reg_default pcm512x_reg_defaults[] = {
 	{ PCM512x_DIGITAL_VOLUME_2,  0x30 },
 	{ PCM512x_DIGITAL_VOLUME_3,  0x30 },
 	{ PCM512x_DIGITAL_MUTE_1,    0x22 },
-	{ PCM512x_DIGITAL_MUTE_2,    0x00 },
+	{ PCM512x_DIGITAL_MUTE_2,    0x02 },
 	{ PCM512x_DIGITAL_MUTE_3,    0x07 },
 	{ PCM512x_OUTPUT_AMPLITUDE,  0x00 },
 	{ PCM512x_ANALOG_GAIN_CTRL,  0x00 },
-- 
1.7.10.4

