Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3LEWmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 17:42:52 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:61878 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab3LEWmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 17:42:49 -0500
X-IronPort-AV: E=Sophos;i="4.93,836,1378882800"; 
   d="scan'208";a="185180"
From: Tim Kryger <tim.kryger@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Device Tree List <devicetree@vger.kernel.org>,
        ARM Linux List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Subject: [PATCH] ARM: dts: Leave sdio1 as disabled on bcm28155-ap
Date: Thu, 5 Dec 2013 14:42:46 -0800
Message-ID: <1386283366-7273-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sdio1 interface pins are routed to an unpopulated daughter card
connector on the bcm28155-ap board.  Thus there is no need to mark
this interface as enabled.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 arch/arm/boot/dts/bcm28155-ap.dts | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
index 08e47c2..d2e7769 100644
--- a/arch/arm/boot/dts/bcm28155-ap.dts
+++ b/arch/arm/boot/dts/bcm28155-ap.dts
@@ -27,11 +27,6 @@
 		status = "okay";
 	};
 
-	sdio1: sdio@3f180000 {
-		max-frequency = <48000000>;
-		status = "okay";
-	};
-
 	sdio2: sdio@3f190000 {
 		non-removable;
 		max-frequency = <48000000>;
-- 
1.8.0.1

