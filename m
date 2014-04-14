Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbaDNJyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:54:43 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:42701 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaDNJym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:54:42 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, Mark Brown <broonie@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v4 1/2] ASoC: sam9g20_wm8731: remove useless mach/gpio.h
Date: Mon, 14 Apr 2014 11:54:38 +0200
Message-ID: <cb4eece4e6fadca4627a869bfe6efb3d41c66700.1397468934.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This include file is about to disapear. In addition it is
useless for this code. So it is time to remove it.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi Mark,

This patch is needed before we integrate the folling one. It will allow us to
remove the mach/gpio.h header file for AT91 and will be a move forward in the
single zImage direction.

So, can you have a look and if you agree, we may add both in arm-soc during
the 3.15-rc phase...

 Thanks, bye

 sound/soc/atmel/sam9g20_wm8731.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/atmel/sam9g20_wm8731.c b/sound/soc/atmel/sam9g20_wm8731.c
index 174bd546c08b..bb1149126c54 100644
--- a/sound/soc/atmel/sam9g20_wm8731.c
+++ b/sound/soc/atmel/sam9g20_wm8731.c
@@ -48,7 +48,6 @@
 
 #include <asm/mach-types.h>
 #include <mach/hardware.h>
-#include <mach/gpio.h>
 
 #include "../codecs/wm8731.h"
 #include "atmel-pcm.h"
-- 
1.8.2.2

