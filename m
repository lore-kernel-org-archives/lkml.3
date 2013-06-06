Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab3FFI0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:26:04 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:57213 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757892Ab3FFI0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:26:02 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-pcmcia@lists.infradead.org>, <linux@dominikbrodowski.net>,
        <manabian@gmail.com>, <fabio.porcedda@gmail.com>,
        <laurent.navet@gmail.com>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v3 4/7] pcmcia: at91_cf: clean up header includes
Date: Thu, 6 Jun 2013 10:24:17 +0200
Message-ID: <049152805bb97b6721b494bda83d4eeaebc66371.1370506678.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1370506678.git.nicolas.ferre@atmel.com>
References: <cover.1370506678.git.nicolas.ferre@atmel.com>
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
1.8.2.2

