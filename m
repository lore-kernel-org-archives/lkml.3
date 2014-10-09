Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaJITaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:30:19 -0400
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:45258
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752055AbaJITaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:30:08 -0400
From: John Crispin <blogic@openwrt.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: [PATCH 4/4] MIPS: ralink: always enable pinctrl on ralink SoC
Date: Thu,  9 Oct 2014 04:55:27 +0200
Message-Id: <1412823327-10296-5-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1412823327-10296-1-git-send-email-blogic@openwrt.org>
References: <1412823327-10296-1-git-send-email-blogic@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Crispin <blogic@openwrt.org>
---
 arch/mips/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 574c430..2d255e8 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -451,6 +451,8 @@ config RALINK
 	select CLKDEV_LOOKUP
 	select ARCH_HAS_RESET_CONTROLLER
 	select RESET_CONTROLLER
+	select PINCTRL
+	select PINCTRL_RT2880
 
 config SGI_IP22
 	bool "SGI IP22 (Indy/Indigo2)"
-- 
1.7.10.4

