Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116Ab3CHOCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 09:02:37 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12445 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab3CHOCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 09:02:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 08 Mar 2013 05:56:16 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] ARM: DT: tegra20/tegra30: Correct clock id for UARTB
Date: Fri, 8 Mar 2013 19:30:45 +0530
Message-ID: <1362751245-32432-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UARTB clock bit in CAR register is 7. Correcting this
in DTS file.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra20.dtsi |    2 +-
 arch/arm/boot/dts/tegra30.dtsi |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index bbbe2de..b89fea2 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -260,7 +260,7 @@
 		reg-shift = <2>;
 		interrupts = <0 37 0x04>;
 		nvidia,dma-request-selector = <&apbdma 9>;
-		clocks = <&tegra_car 96>;
+		clocks = <&tegra_car 7>;
 		status = "disabled";
 	};
 
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index eddd0f9..0c9532b 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -247,7 +247,7 @@
 		reg-shift = <2>;
 		interrupts = <0 37 0x04>;
 		nvidia,dma-request-selector = <&apbdma 9>;
-		clocks = <&tegra_car 160>;
+		clocks = <&tegra_car 7>;
 		status = "disabled";
 	};
 
-- 
1.7.1.1

