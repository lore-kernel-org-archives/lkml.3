Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbbAMJmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:42:05 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:57129 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbbAMJmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:42:02 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] gpio/Kconfig: Fix X86 arch name
Date: Tue, 13 Jan 2015 10:41:57 +0100
Message-Id: <1421142117-16371-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X86 Kconfig symbol is X86, not ARCH_X86.

Fixes: c586b3075d5b47d8 (gpio/xilinx: Add support for X86 Arch)
Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/gpio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 1eff81c..ef421ac 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -368,7 +368,7 @@ config GPIO_XGENE
 
 config GPIO_XILINX
 	tristate "Xilinx GPIO support"
-	depends on OF_GPIO && (PPC_OF || MICROBLAZE || ARCH_ZYNQ || ARCH_X86)
+	depends on OF_GPIO && (PPC_OF || MICROBLAZE || ARCH_ZYNQ || X86)
 	help
 	  Say yes here to support the Xilinx FPGA GPIO device
 
-- 
2.1.4

