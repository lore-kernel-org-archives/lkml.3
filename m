Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526Ab3CVOYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:24:11 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:57004 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab3CVOYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:24:08 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 4/4] ARM: at91: remove partial parameter in bootargs for at91sam9x5ek.dtsi
Date: Fri, 22 Mar 2013 15:23:36 +0100
Message-ID: <5a15207e14a48d92754a4bce9a5ef6117b493f6d.1363960549.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1363960549.git.nicolas.ferre@atmel.com>
References: <cover.1363960549.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the malformed "mem=" bootargs parameter in at91sam9x5ek.dtsi

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: stable <stable@vger.kernel.org> # 3.8+
---
 arch/arm/boot/dts/at91sam9x5ek.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
index f7841f6..a0b4ff9 100644
--- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
@@ -13,7 +13,7 @@
 	compatible = "atmel,at91sam9x5ek", "atmel,at91sam9x5", "atmel,at91sam9";
 
 	chosen {
-		bootargs = "128M console=ttyS0,115200 root=/dev/mtdblock1 rw rootfstype=ubifs ubi.mtd=1 root=ubi0:rootfs";
+		bootargs = "console=ttyS0,115200 root=/dev/mtdblock1 rw rootfstype=ubifs ubi.mtd=1 root=ubi0:rootfs";
 	};
 
 	ahb {
-- 
1.8.0

