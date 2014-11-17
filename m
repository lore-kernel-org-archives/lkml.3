Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaKQOmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:42:12 -0500
Received: from bsmtp4.bon.at ([195.3.86.186]:29061 "EHLO bsmtp4.bon.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbaKQOmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:42:10 -0500
From: Radek Dostal <radek.dostal@streamunlimited.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com, arnd@arndb.de,
        trivial@kernel.org, Radek Dostal <radek.dostal@streamunlimited.com>
Subject: [PATCH RESEND] ARM: dts: bcm63138: change "interupts" to "interrupts"
Date: Mon, 17 Nov 2014 15:41:18 +0100
Message-Id: <1416235278-15759-1-git-send-email-radek.dostal@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <5460F9EF.5010605@gmail.com>
References: <5460F9EF.5010605@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all other nodes in bcm63138.dtsi use "interrupts", this had to be just a typo
which never got noticed, even it may have quite some consequences.

Signed-off-by: Radek Dostal <radek.dostal@streamunlimited.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Dear all,

 resending the previous patch with added Acked-by from Florian Fainelli. I
 did not hear anything back for almost a week. Additionally CC to
 trivial@kernel.org as it may qualify for it.

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

