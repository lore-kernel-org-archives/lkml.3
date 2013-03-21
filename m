Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab3CULk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:40:59 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:7835 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757636Ab3CULk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:40:57 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-pcmcia@lists.infradead.org>, <linux@dominikbrodowski.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>, <manabian@gmail.com>,
        <fabio.porcedda@gmail.com>, <laurent.navet@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 4/7] pcmcia: at91_cf: clean up header includes
Date: Thu, 21 Mar 2013 12:40:14 +0100
Message-ID: <6016c8edd48eeb6f1c20c6f6463f47fc2ee7bb06.1363865228.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1363865228.git.nicolas.ferre@atmel.com>
References: <cover.1363865228.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joachim Eastwood <manabian@gmail.com>

Use includes from linux/ instead of asm/ and remove a
unnecessary mach/ include.

Signed-off-by: Joachim Eastwood <manabian@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/pcmcia/at91_cf.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index 43bc342..bce8a64 100644
--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -18,13 +18,11 @@
 #include <linux/slab.h>
 #include <linux/gpio.h>
 #include <linux/platform_data/atmel.h>
+#include <linux/io.h>
+#include <linux/sizes.h>
 
 #include <pcmcia/ss.h>
 
-#include <mach/hardware.h>
-#include <asm/io.h>
-#include <asm/sizes.h>
-
 #include <mach/at91rm9200_mc.h>
 #include <mach/at91_ramc.h>
 
-- 
1.8.0

