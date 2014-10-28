Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbaJ1S6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:58:19 -0400
Received: from down.free-electrons.com ([37.187.137.238]:35824 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752787AbaJ1S6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:58:18 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] pinctrl: at91: fix compilation
Date: Tue, 28 Oct 2014 19:58:06 +0100
Message-Id: <1414522686-5755-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add macros introduced by 4334ac2db2be9e278c95fd15260c1f49f698ffc5 that
were missed when copying the header.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/pinctrl/pinctrl-at91.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-at91.h b/drivers/pinctrl/pinctrl-at91.h
index c837c66ea360..79b957f1dfa2 100644
--- a/drivers/pinctrl/pinctrl-at91.h
+++ b/drivers/pinctrl/pinctrl-at91.h
@@ -63,4 +63,10 @@
 #define PIO_FRLHSR	0xd8	/* Fall/Rise - Low/High Status Register */
 #define PIO_SCHMITT	0x100	/* Schmitt Trigger Register */
 
+#define SAMA5D3_PIO_DRIVER1		0x118  /*PIO Driver 1 register offset*/
+#define SAMA5D3_PIO_DRIVER2		0x11C  /*PIO Driver 2 register offset*/
+
+#define AT91SAM9X5_PIO_DRIVER1	0x114  /*PIO Driver 1 register offset*/
+#define AT91SAM9X5_PIO_DRIVER2	0x118  /*PIO Driver 2 register offset*/
+
 #endif
-- 
2.1.0

