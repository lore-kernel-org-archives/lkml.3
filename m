Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaKJRDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:03:03 -0500
Received: from bsmtp4.bon.at ([195.3.86.186]:45740 "EHLO lbmfmo03.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752244AbaKJRDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:03:00 -0500
X-Greylist: delayed 1577 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Nov 2014 12:02:59 EST
From: Radek Dostal <radek.dostal@streamunlimited.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com, arnd@arndb.de,
        Radek Dostal <radek.dostal@streamunlimited.com>
Subject: [PATCH] ARM: dts: bcm63138: change "interupts" to "interrupts"
Date: Mon, 10 Nov 2014 17:35:58 +0100
Message-Id: <1415637358-24378-1-git-send-email-radek.dostal@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all other nodes in bcm63138.dtsi use "interrupts", this had to be just a typo
which never got noticed, even it may have quite some consequences.

Signed-off-by: Radek Dostal <radek.dostal@streamunlimited.com>
---
 Hi all,

 when running git grep with typo, I spotted this typo inDT binding, which 
 looks obviously wrong to me. Sorry I do not have the board to test it, but 
 I am pretty sure the patch is correct.

 I hope I included, right people get_maintainer.pl showed bit too many.

 Thanks,
 Radek

 arch/arm/boot/dts/bcm63138.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm63138.dtsi b/arch/arm/boot/dts/bcm63138.dtsi
index f3bb2dd..d2d8e94 100644
--- a/arch/arm/boot/dts/bcm63138.dtsi
+++ b/arch/arm/boot/dts/bcm63138.dtsi
@@ -102,7 +102,7 @@
 		twd_watchdog: watchdog@1e620 {
 			compatible = "arm,cortex-a9-twd-wdt";
 			reg = <0x1e620 0x20>;
-			interupts = <GIC_PPI 14 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_PPI 14 IRQ_TYPE_LEVEL_HIGH>;
 		};
 	};
 
-- 
1.7.9.5

