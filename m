Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab3F1IjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:39:20 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:45823 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab3F1IjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:39:17 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Bo Shen <voice.shen@atmel.com>, Josh Wu <josh.wu@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91/DT: fix at91sam9n12ek memory node
Date: Fri, 28 Jun 2013 10:39:15 +0200
Message-ID: <1372408755-7946-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9n12ek.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
index d59b70c..3d77dbe 100644
--- a/arch/arm/boot/dts/at91sam9n12ek.dts
+++ b/arch/arm/boot/dts/at91sam9n12ek.dts
@@ -14,11 +14,11 @@
 	compatible = "atmel,at91sam9n12ek", "atmel,at91sam9n12", "atmel,at91sam9";
 
 	chosen {
-		bootargs = "mem=128M console=ttyS0,115200 root=/dev/mtdblock1 rw rootfstype=jffs2";
+		bootargs = "console=ttyS0,115200 root=/dev/mtdblock1 rw rootfstype=jffs2";
 	};
 
 	memory {
-		reg = <0x20000000 0x10000000>;
+		reg = <0x20000000 0x8000000>;
 	};
 
 	clocks {
-- 
1.8.2.2

