Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3GDJMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:12:09 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8382 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab3GDJMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:12:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 04 Jul 2013 02:10:17 -0700
From: Wei Ni <wni@nvidia.com>
To: <swarren@wwwdotorg.org>, <acourbot@nvidia.com>, <linux@arm.linux.org.uk>
CC: <MLongnecker@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH 2/2] ARM: dt: t114 dalmore: add dt entry for lm90
Date: Thu, 4 Jul 2013 17:09:39 +0800
Message-ID: <1372928979-26938-3-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372928979-26938-1-git-send-email-wni@nvidia.com>
References: <1372928979-26938-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable thermal sensor lm90 for t114 dalmore.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/boot/dts/tegra114-dalmore.dts |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index cb640eb..8325797 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -738,6 +738,13 @@
 			realtek,ldo1-en-gpios =
 				<&gpio TEGRA_GPIO(V, 3) GPIO_ACTIVE_HIGH>;
 		};
+
+		nct1008: nct1008 {
+			compatible = "lm90,nct1008";
+			reg = <0x4c>;
+			interrupt-parent = <&gpio>;
+			interrupts = <TEGRA_GPIO(O, 4) IRQ_TYPE_LEVEL_LOW>;
+		};
 	};
 
 	i2c@7000d000 {
-- 
1.7.9.5

