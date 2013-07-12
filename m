Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab3GLHu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:50:59 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14705 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231Ab3GLHu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:50:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 12 Jul 2013 00:49:30 -0700
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <swarren@wwwdotorg.org>, <linux@roeck-us.net>,
        <thierry.reding@gmail.com>
CC: <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v3 2/2] ARM: dt: t114 dalmore: add dt entry for nct1008
Date: Fri, 12 Jul 2013 15:49:24 +0800
Message-ID: <1373615364-18559-3-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373615364-18559-1-git-send-email-wni@nvidia.com>
References: <1373615364-18559-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable thermal sensor nct1008 for t114 dalmore.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/boot/dts/tegra114-dalmore.dts |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index cb640eb..47ec7eb 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -738,6 +738,13 @@
 			realtek,ldo1-en-gpios =
 				<&gpio TEGRA_GPIO(V, 3) GPIO_ACTIVE_HIGH>;
 		};
+
+		nct1008 {
+			compatible = "onnn,nct1008";
+			reg = <0x4c>;
+			interrupt-parent = <&gpio>;
+			interrupts = <TEGRA_GPIO(O, 4) IRQ_TYPE_LEVEL_LOW>;
+		};
 	};
 
 	i2c@7000d000 {
-- 
1.7.9.5

