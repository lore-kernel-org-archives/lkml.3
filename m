Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbaIXNsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:48:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51021 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbaIXNsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:48:09 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/22] MAINTAINERS: Add phy-stih41x-usb.c to ARCH/STI architecture
Date: Wed, 24 Sep 2014 19:17:18 +0530
Message-ID: <1411566440-19169-21-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411566440-19169-1-git-send-email-kishon@ti.com>
References: <1411566440-19169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Griffin <peter.griffin@linaro.org>

This patch adds the new phy-sti41x-usb.c PHY driver found on
STMicroelectronics stih41x consumer electronics SoC's into the STI
arch section of the maintainers file.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 93fd8af..a5cdbe9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1399,6 +1399,7 @@ F:	drivers/i2c/busses/i2c-st.c
 F:	drivers/tty/serial/st-asc.c
 F:	drivers/mmc/host/sdhci-st.c
 F:	drivers/phy/phy-stih407-usb.c
+F:	drivers/phy/phy-stih41x-usb.c
 
 ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-- 
1.7.9.5

