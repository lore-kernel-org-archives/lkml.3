Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3IRNB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:01:28 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16392 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3IRNB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:01:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Sep 2013 06:01:26 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@nvidia.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH REPOST] ARM: tegra: use dt-binding header for key code
Date: Wed, 18 Sep 2013 18:52:32 +0530
Message-ID: <1379510552-23401-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In place of hardcoding the key code in DTS file and comment the
key code as side notes, use the key code macro defines in the
dt-bindings/input/input.h directly.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Reposting this patch as it was sent earlier when merge window was closed.

 arch/arm/boot/dts/tegra114-dalmore.dts |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index 6023028..05a3aae 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -1,5 +1,6 @@
 /dts-v1/;
 
+#include <dt-bindings/input/input.h>
 #include "tegra114.dtsi"
 
 / {
@@ -1081,26 +1082,26 @@
 		home {
 			label = "Home";
 			gpios = <&gpio TEGRA_GPIO(I, 5) GPIO_ACTIVE_LOW>;
-			linux,code = <102>; /* KEY_HOME */
+			linux,code = <KEY_HOME>;
 		};
 
 		power {
 			label = "Power";
 			gpios = <&gpio TEGRA_GPIO(Q, 0) GPIO_ACTIVE_LOW>;
-			linux,code = <116>; /* KEY_POWER */
+			linux,code = <KEY_POWER>;
 			gpio-key,wakeup;
 		};
 
 		volume_down {
 			label = "Volume Down";
 			gpios = <&gpio TEGRA_GPIO(R, 1) GPIO_ACTIVE_LOW>;
-			linux,code = <114>; /* KEY_VOLUMEDOWN */
+			linux,code = <KEY_VOLUMEDOWN>;
 		};
 
 		volume_up {
 			label = "Volume Up";
 			gpios = <&gpio TEGRA_GPIO(R, 2) GPIO_ACTIVE_LOW>;
-			linux,code = <115>; /* KEY_VOLUMEUP */
+			linux,code = <KEY_VOLUMEUP>;
 		};
 	};
 
-- 
1.7.1.1

