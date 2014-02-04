Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaBDX16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:27:58 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:35312 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaBDX14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:27:56 -0500
X-IronPort-AV: E=Sophos;i="4.95,782,1384329600"; 
   d="scan'208";a="12735235"
From: Tim Kryger <tim.kryger@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Device Tree List <devicetree@vger.kernel.org>,
        ARM Linux List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] ARM: dts: Leave sdio1 as disabled on bcm28155-ap
Date: Tue, 4 Feb 2014 15:27:40 -0800
Message-ID: <1391556460-24218-1-git-send-email-tim.kryger@linaro.org>
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

Changes since v1:
  - Rebased on v3.14-rc1

 arch/arm/boot/dts/bcm28155-ap.dts | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
index 5ff2382..3604554 100644
--- a/arch/arm/boot/dts/bcm28155-ap.dts
+++ b/arch/arm/boot/dts/bcm28155-ap.dts
@@ -49,11 +49,6 @@
 		clock-frequency = <400000>;
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

