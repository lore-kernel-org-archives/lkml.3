Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3EHHPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 03:15:36 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:35413 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab3EHHPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 03:15:32 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 5/6] ASoC: ux500: Swap even/odd AD slot definitions
Date: Wed,  8 May 2013 09:14:20 +0200
Message-Id: <1367997261-32048-6-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AD slots definitions for ab8500 codec were erroneously swapped between
even and odd channels.  Fix this by swapping the definitions to be
coherent with the channel number.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 sound/soc/codecs/ab8500-codec.h | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.h b/sound/soc/codecs/ab8500-codec.h
index 114f69a..306d0bc 100644
--- a/sound/soc/codecs/ab8500-codec.h
+++ b/sound/soc/codecs/ab8500-codec.h
@@ -348,25 +348,25 @@
 
 /* AB8500_ADSLOTSELX */
 #define AB8500_ADSLOTSELX_AD_OUT1_TO_SLOT_ODD	0x00
-#define AB8500_ADSLOTSELX_AD_OUT2_TO_SLOT_ODD	0x01
-#define AB8500_ADSLOTSELX_AD_OUT3_TO_SLOT_ODD	0x02
-#define AB8500_ADSLOTSELX_AD_OUT4_TO_SLOT_ODD	0x03
-#define AB8500_ADSLOTSELX_AD_OUT5_TO_SLOT_ODD	0x04
-#define AB8500_ADSLOTSELX_AD_OUT6_TO_SLOT_ODD	0x05
-#define AB8500_ADSLOTSELX_AD_OUT7_TO_SLOT_ODD	0x06
-#define AB8500_ADSLOTSELX_AD_OUT8_TO_SLOT_ODD	0x07
-#define AB8500_ADSLOTSELX_ZEROES_TO_SLOT_ODD	0x08
-#define AB8500_ADSLOTSELX_TRISTATE_TO_SLOT_ODD	0x0F
+#define AB8500_ADSLOTSELX_AD_OUT2_TO_SLOT_ODD	0x10
+#define AB8500_ADSLOTSELX_AD_OUT3_TO_SLOT_ODD	0x20
+#define AB8500_ADSLOTSELX_AD_OUT4_TO_SLOT_ODD	0x30
+#define AB8500_ADSLOTSELX_AD_OUT5_TO_SLOT_ODD	0x40
+#define AB8500_ADSLOTSELX_AD_OUT6_TO_SLOT_ODD	0x50
+#define AB8500_ADSLOTSELX_AD_OUT7_TO_SLOT_ODD	0x60
+#define AB8500_ADSLOTSELX_AD_OUT8_TO_SLOT_ODD	0x70
+#define AB8500_ADSLOTSELX_ZEROES_TO_SLOT_ODD	0x80
+#define AB8500_ADSLOTSELX_TRISTATE_TO_SLOT_ODD	0xF0
 #define AB8500_ADSLOTSELX_AD_OUT1_TO_SLOT_EVEN	0x00
-#define AB8500_ADSLOTSELX_AD_OUT2_TO_SLOT_EVEN	0x10
-#define AB8500_ADSLOTSELX_AD_OUT3_TO_SLOT_EVEN	0x20
-#define AB8500_ADSLOTSELX_AD_OUT4_TO_SLOT_EVEN	0x30
-#define AB8500_ADSLOTSELX_AD_OUT5_TO_SLOT_EVEN	0x40
-#define AB8500_ADSLOTSELX_AD_OUT6_TO_SLOT_EVEN	0x50
-#define AB8500_ADSLOTSELX_AD_OUT7_TO_SLOT_EVEN	0x60
-#define AB8500_ADSLOTSELX_AD_OUT8_TO_SLOT_EVEN	0x70
-#define AB8500_ADSLOTSELX_ZEROES_TO_SLOT_EVEN	0x80
-#define AB8500_ADSLOTSELX_TRISTATE_TO_SLOT_EVEN	0xF0
+#define AB8500_ADSLOTSELX_AD_OUT2_TO_SLOT_EVEN	0x01
+#define AB8500_ADSLOTSELX_AD_OUT3_TO_SLOT_EVEN	0x02
+#define AB8500_ADSLOTSELX_AD_OUT4_TO_SLOT_EVEN	0x03
+#define AB8500_ADSLOTSELX_AD_OUT5_TO_SLOT_EVEN	0x04
+#define AB8500_ADSLOTSELX_AD_OUT6_TO_SLOT_EVEN	0x05
+#define AB8500_ADSLOTSELX_AD_OUT7_TO_SLOT_EVEN	0x06
+#define AB8500_ADSLOTSELX_AD_OUT8_TO_SLOT_EVEN	0x07
+#define AB8500_ADSLOTSELX_ZEROES_TO_SLOT_EVEN	0x08
+#define AB8500_ADSLOTSELX_TRISTATE_TO_SLOT_EVEN	0x0F
 #define AB8500_ADSLOTSELX_EVEN_SHIFT		0
 #define AB8500_ADSLOTSELX_ODD_SHIFT		4
 
-- 
1.8.2

