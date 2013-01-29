Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab3A2M7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:59:10 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11061 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744Ab3A2M65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:58:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 29 Jan 2013 04:58:12 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/7] ARM: DT: tegra114: add APB DMA controller DT entry
Date: Tue, 29 Jan 2013 18:26:19 +0530
Message-ID: <1359464183-6255-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1359464183-6255-1-git-send-email-ldewangan@nvidia.com>
References: <1359464183-6255-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NVIDIA's Tegra114 has 32 channels APB DMA controller. Add DT entry for
APB DMA controllers and make it compatible with "nvidia,tegra114-apbdma".

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra114.dtsi |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index 9ce1a68..74f6a77 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -37,6 +37,43 @@
 		reg = <0x6000c004 0x14c>;
 	};
 
+	apbdma: dma {
+		compatible = "nvidia,tegra114-apbdma";
+		reg = <0x6000a000 0x1400>;
+		interrupts = <0 104 0x04
+			      0 105 0x04
+			      0 106 0x04
+			      0 107 0x04
+			      0 108 0x04
+			      0 109 0x04
+			      0 110 0x04
+			      0 111 0x04
+			      0 112 0x04
+			      0 113 0x04
+			      0 114 0x04
+			      0 115 0x04
+			      0 116 0x04
+			      0 117 0x04
+			      0 118 0x04
+			      0 119 0x04
+			      0 128 0x04
+			      0 129 0x04
+			      0 130 0x04
+			      0 131 0x04
+			      0 132 0x04
+			      0 133 0x04
+			      0 134 0x04
+			      0 135 0x04
+			      0 136 0x04
+			      0 137 0x04
+			      0 138 0x04
+			      0 139 0x04
+			      0 140 0x04
+			      0 141 0x04
+			      0 142 0x04
+			      0 143 0x04>;
+	};
+
 	gpio: gpio {
 		compatible = "nvidia,tegra114-gpio", "nvidia,tegra30-gpio";
 		reg = <0x6000d000 0x1000>;
-- 
1.7.1.1

