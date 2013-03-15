Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab3COS5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:57:51 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2666 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab3COS5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:57:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 15 Mar 2013 11:50:56 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] ARM: tegra: fix register address of slink controller
Date: Sat, 16 Mar 2013 00:25:30 +0530
Message-ID: <1363373730-10703-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo on register address of slink3 controller where register
address is wrongly set as 0x7000d480 but it is 0x7000d800.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra20.dtsi |    2 +-
 arch/arm/boot/dts/tegra30.dtsi |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 0bfd823..4084da0 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -385,7 +385,7 @@
 
 	spi@7000d800 {
 		compatible = "nvidia,tegra20-slink";
-		reg = <0x7000d480 0x200>;
+		reg = <0x7000d800 0x200>;
 		interrupts = <0 83 0x04>;
 		nvidia,dma-request-selector = <&apbdma 17>;
 		#address-cells = <1>;
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index c371651..f302ace 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -372,7 +372,7 @@
 
 	spi@7000d800 {
 		compatible = "nvidia,tegra30-slink", "nvidia,tegra20-slink";
-		reg = <0x7000d480 0x200>;
+		reg = <0x7000d800 0x200>;
 		interrupts = <0 83 0x04>;
 		nvidia,dma-request-selector = <&apbdma 17>;
 		#address-cells = <1>;
-- 
1.7.1.1

