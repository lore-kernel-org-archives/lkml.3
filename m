Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169Ab3CHN4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:56:08 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9913 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973Ab3CHNy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:54:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 08 Mar 2013 05:54:53 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pdeschrijver@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/5] ARM: DT: tegra114: Add i2c controller DT entry
Date: Fri, 8 Mar 2013 19:22:59 +0530
Message-ID: <1362750782-15174-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1362750782-15174-1-git-send-email-ldewangan@nvidia.com>
References: <1362750782-15174-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NVIDIA's Tegra114 has 5 i2c controllers. These controllers have
additional feature/configurations to make it functional over
Tegra30's i2c controller driver.

Add DT entry for i2c controllers and make it compatible with
"nvidia,tegra114-i2c".

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra114.dtsi |   55 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index b73b8a6..14afbc8 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -135,6 +135,61 @@
 		clocks = <&tegra_car 65>;
 	};
 
+	i2c@7000c000 {
+		compatible = "nvidia,tegra114-i2c";
+		reg = <0x7000c000 0x100>;
+		interrupts = <0 38 0x04>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+		clocks = <&tegra_car 12>;
+		clock-names = "div-clk";
+	};
+
+	i2c@7000c400 {
+		compatible = "nvidia,tegra114-i2c";
+		reg = <0x7000c400 0x100>;
+		interrupts = <0 84 0x04>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+		clocks = <&tegra_car 54>;
+		clock-names = "div-clk";
+	};
+
+	i2c@7000c500 {
+		compatible = "nvidia,tegra114-i2c";
+		reg = <0x7000c500 0x100>;
+		interrupts = <0 92 0x04>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+		clocks = <&tegra_car 67>;
+		clock-names = "div-clk";
+	};
+
+	i2c@7000c700 {
+		compatible = "nvidia,tegra114-i2c";
+		reg = <0x7000c700 0x100>;
+		interrupts = <0 120 0x04>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+		clocks = <&tegra_car 103>;
+		clock-names = "div-clk";
+	};
+
+	i2c@7000d000 {
+		compatible = "nvidia,tegra114-i2c";
+		reg = <0x7000d000 0x100>;
+		interrupts = <0 53 0x04>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+		clocks = <&tegra_car 47>;
+		clock-names = "div-clk";
+	};
+
 	sdhci@78000000 {
 		compatible = "nvidia,tegra114-sdhci", "nvidia,tegra30-sdhci";
 		reg = <0x78000000 0x200>;
-- 
1.7.1.1

