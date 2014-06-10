Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205AbaFJUcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:32:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35003 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbaFJTrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:47:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 084/160] ARM: tegra: remove UART5/UARTE from tegra124.dtsi
Date: Tue, 10 Jun 2014 12:45:24 -0700
Message-Id: <1402429600-20477-85-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 862f0eea38409ff0d7f226c1245b787e3f0e2607 upstream.

Tegra124 only has 4 UARTs. Parts of the documentation hint at a fifth
UART, but this appears to be left-over from earlier SoC documentation.
Remove the non-existent DT node for UART5.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
[ kamal: backport to 3.13-stable ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/boot/dts/tegra124.dtsi | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
index b741300..96ee0da 100644
--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -87,14 +87,6 @@
 		status = "disabled";
 	};
 
-	serial@70006400 {
-		compatible = "nvidia,tegra124-uart", "nvidia,tegra20-uart";
-		reg = <0x70006400 0x40>;
-		reg-shift = <2>;
-		interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
-		status = "disabled";
-	};
-
 	rtc@7000e000 {
 		compatible = "nvidia,tegra124-rtc", "nvidia,tegra20-rtc";
 		reg = <0x7000e000 0x100>;
-- 
1.9.1

