Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965029Ab3DJLvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:51:39 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10736 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759698Ab3DJLvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:51:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 10 Apr 2013 04:49:54 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] ARM: tegra: dalmore: populate key mapping
Date: Wed, 10 Apr 2013 17:17:33 +0530
Message-ID: <1365594454-20614-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keys on Dalmore interfaced through Tegra KBC controller
in key matrix topology.

Add the key mapping for the keys.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
The system is booted on Dalmore SKU1000 with the fastboot.

 arch/arm/boot/dts/tegra114-dalmore.dts |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index 72c1f27..12198d1 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -823,6 +823,18 @@
 		};
 	};
 
+	kbc {
+		status = "okay";
+		nvidia,debounce-delay-ms = <640>;
+		nvidia,repeat-delay-ms = <1>;
+		nvidia,kbc-row-pins = <0 1 2>;
+		nvidia,kbc-col-pins = <11 12 13>;
+		linux,keymap = < 0x00000074	/* KEY_POWER */
+				 0x00010066	/* KEY_HOME */
+				 0x01010072	/* KEY_VOLUMEDOWN */
+				 0x02010073>;	/* KEY_VOLUMEUP */
+	};
+
 	pmc {
 		nvidia,invert-interrupt;
 	};
-- 
1.7.1.1

