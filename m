Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3A2NAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:00:06 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5707 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3A2M6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:58:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 29 Jan 2013 04:56:25 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 5/7] ARM: DT: tegra114: Add i2c controller DT entry
Date: Tue, 29 Jan 2013 18:26:21 +0530
Message-ID: <1359464183-6255-6-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1359464183-6255-1-git-send-email-ldewangan@nvidia.com>
References: <1359464183-6255-1-git-send-email-ldewangan@nvidia.com>
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
 arch/arm/boot/dts/tegra114.dtsi |   45 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index 210b4a7..74d18b2 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -129,6 +129,51 @@
 		status = "disabled";
 	};
 
+	i2c@7000c000 {
+		compatible = "nvidia,tegra114-i2c";
+		reg = <0x7000c000 0x100>;
+		interrupts = <0 38 0x04>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	i2c@7000c400 {
+		compatible = "nvidia,tegra114-i2c";
+		reg = <0x7000c400 0x100>;
+		interrupts = <0 84 0x04>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	i2c@7000c500 {
+		compatible = "nvidia,tegra114-i2c";
+		reg = <0x7000c500 0x100>;
+		interrupts = <0 92 0x04>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	i2c@7000c700 {
+		compatible = "nvidia,tegra114-i2c";
+		reg = <0x7000c700 0x100>;
+		interrupts = <0 120 0x04>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	i2c@7000d000 {
+		compatible = "nvidia,tegra114-i2c";
+		reg = <0x7000d000 0x100>;
+		interrupts = <0 53 0x04>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
 	rtc {
 		compatible = "nvidia,tegra114-rtc", "nvidia,tegra20-rtc";
 		reg = <0x7000e000 0x100>;
-- 
1.7.1.1

