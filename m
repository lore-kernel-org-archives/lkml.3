Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab3BSEAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 23:00:19 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:56615 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab3BSEAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 23:00:11 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: andrew.smirnov@gmail.com
Cc: hverkuil@xs4all.nl, broonie@opensource.wolfsonmicro.com,
        mchehab@redhat.com, sameo@linux.intel.com, perex@perex.cz,
        tiwai@suse.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 7/7] sound/soc/codecs: Cosmetic changes to SI476X codec driver
Date: Mon, 18 Feb 2013 19:59:35 -0800
Message-Id: <1361246375-8848-8-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361246375-8848-1-git-send-email-andrew.smirnov@gmail.com>
References: <1361246375-8848-1-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Add appropriate license header
- Change email address in MODULE_AUTHOR
- Remove trailing whitespaces

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
---
 sound/soc/codecs/si476x.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/si476x.c b/sound/soc/codecs/si476x.c
index 30aebbe..68b648a 100644
--- a/sound/soc/codecs/si476x.c
+++ b/sound/soc/codecs/si476x.c
@@ -1,3 +1,22 @@
+/*
+ * sound/soc/codecs/si476x.c -- Codec driver for SI476X chips
+ *
+ * Copyright (C) 2012 Innovative Converged Devices(ICD)
+ * Copyright (C) 2013 Andrey Smirnov
+ *
+ * Author: Andrey Smirnov <andrew.smirnov@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <sound/pcm.h>
@@ -156,7 +175,7 @@ static int si476x_codec_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		dev_err(codec_dai->codec->dev, "Failed to set output format\n");
 		return err;
 	}
-	
+
 	return 0;
 }
 
@@ -197,7 +216,7 @@ static int si476x_codec_hw_params(struct snd_pcm_substream *substream,
 
 	err = snd_soc_update_bits(dai->codec, SI476X_DIGITAL_IO_OUTPUT_FORMAT,
 				  SI476X_DIGITAL_IO_OUTPUT_WIDTH_MASK,
-				  (width << SI476X_DIGITAL_IO_SLOT_SIZE_SHIFT) | 
+				  (width << SI476X_DIGITAL_IO_SLOT_SIZE_SHIFT) |
 				  (width << SI476X_DIGITAL_IO_SAMPLE_SIZE_SHIFT));
 	if (err < 0) {
 		dev_err(dai->codec->dev, "Failed to set output width\n");
@@ -266,6 +285,6 @@ static struct platform_driver si476x_platform_driver = {
 };
 module_platform_driver(si476x_platform_driver);
 
-MODULE_AUTHOR("Andrey Smirnov <andrey.smirnov@convergeddevices.net>");
+MODULE_AUTHOR("Andrey Smirnov <andrew.smirnov@gmail.com>");
 MODULE_DESCRIPTION("ASoC Si4761/64 codec driver");
 MODULE_LICENSE("GPL");
-- 
1.7.10.4

