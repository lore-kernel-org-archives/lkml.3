Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693Ab3GDJKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:10:39 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11260 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab3GDJKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:10:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 04 Jul 2013 02:11:43 -0700
From: Wei Ni <wni@nvidia.com>
To: <swarren@wwwdotorg.org>, <acourbot@nvidia.com>, <linux@arm.linux.org.uk>
CC: <MLongnecker@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH 1/2] ARM: dt: t30 cardhu: add dt entry for lm90
Date: Thu, 4 Jul 2013 17:09:38 +0800
Message-ID: <1372928979-26938-2-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372928979-26938-1-git-send-email-wni@nvidia.com>
References: <1372928979-26938-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable thermal sensor lm90 for t30 cardhu.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/boot/dts/tegra30-cardhu.dtsi |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index f65b53d..8778c94 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -286,6 +286,13 @@
 				};
 			};
 		};
+
+		nct1008: nct1008 {
+			compatible = "lm90,nct1008";
+			reg = <0x4c>;
+			interrupt-parent = <&gpio>;
+			interrupts = <TEGRA_GPIO(CC, 2) IRQ_TYPE_LEVEL_LOW>;
+		};
 	};
 
 	spi@7000da00 {
-- 
1.7.9.5

