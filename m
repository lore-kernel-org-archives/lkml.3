Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaLCMCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:02:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38805 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaLCMCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:02:39 -0500
From: Ravikumar Kattekola <rk@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Ravikumar Kattekola <rk@ti.com>
Subject: [PATCH 1/2] ARM: dts: dra7-evm: Fix typo in SMPS6 (VDD_GPU) max voltage
Date: Wed, 3 Dec 2014 17:33:56 +0530
Message-ID: <1417608237-12258-2-git-send-email-rk@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417608237-12258-1-git-send-email-rk@ti.com>
References: <1417608237-12258-1-git-send-email-rk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max expected voltage for VDD_GPU, connected to SMPS6, is 1.25V.
Correct regulator max voltage constraint to meet this requirement.

Document reference: DRA74 Data Manual, SPRS857M - Dec 2012,
		    Revised Oct 2014.

Fixes: c56a831ca47e ("ARM: dts: DRA7: Add TPS659038 PMIC nodes")

Signed-off-by: Ravikumar Kattekola <rk@ti.com>
---
 arch/arm/boot/dts/dra7-evm.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index 736092b..b6b9286 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -304,7 +304,7 @@
 					/* VDD_GPU - over VDD_SMPS6 */
 					regulator-name = "smps6";
 					regulator-min-microvolt = <850000>;
-					regulator-max-microvolt = <12500000>;
+					regulator-max-microvolt = <1250000>;
 					regulator-always-on;
 					regulator-boot-on;
 				};
-- 
1.7.9.5

