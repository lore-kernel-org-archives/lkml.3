Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3AXLM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:12:27 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5747 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab3AXLMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:12:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 24 Jan 2013 03:11:27 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, Jason Cooper <jason@lakedaemon.net>,
        Shawn Guo <shawn.guo@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        Kukjin Kim <kgene.kim@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [v4 4/6] ARM: dt: tegra114: Add new board, Dalmore
Date: Thu, 24 Jan 2013 13:10:24 +0200
Message-ID: <1359025829-22306-5-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359025829-22306-1-git-send-email-hdoyu@nvidia.com>
References: <1359025829-22306-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new evaluation board, Dalmore for Tegra 114 family.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/boot/dts/Makefile             |    3 ++-
 arch/arm/boot/dts/tegra114-dalmore.dts |   21 +++++++++++++++++++++
 2 files changed, 23 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/tegra114-dalmore.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index e44da40..88ea9fc 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -143,7 +143,8 @@ dtb-$(CONFIG_ARCH_TEGRA) += tegra20-harmony.dtb \
 	tegra20-ventana.dtb \
 	tegra20-whistler.dtb \
 	tegra30-cardhu-a02.dtb \
-	tegra30-cardhu-a04.dtb
+	tegra30-cardhu-a04.dtb \
+	tegra114-dalmore.dtb
 dtb-$(CONFIG_ARCH_VEXPRESS) += vexpress-v2p-ca5s.dtb \
 	vexpress-v2p-ca9.dtb \
 	vexpress-v2p-ca15-tc1.dtb \
diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
new file mode 100644
index 0000000..a30aca6
--- /dev/null
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -0,0 +1,21 @@
+/dts-v1/;
+
+/include/ "tegra114.dtsi"
+
+/ {
+	model = "NVIDIA Tegra114 Dalmore evaluation board";
+	compatible = "nvidia,dalmore", "nvidia,tegra114";
+
+	memory {
+		reg = <0x80000000 0x40000000>;
+	};
+
+	serial@70006300 {
+		status = "okay";
+		clock-frequency = <408000000>;
+	};
+
+	pmc {
+		nvidia,invert-interrupt;
+	};
+};
-- 
1.7.9.5

