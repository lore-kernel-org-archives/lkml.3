Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965104Ab3DJLv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:51:57 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12022 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965070Ab3DJLvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:51:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 10 Apr 2013 04:50:22 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] ARM: tegra: dts: dalmore: enable spi4
Date: Wed, 10 Apr 2013 17:18:03 +0530
Message-ID: <1365594483-20651-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1365594483-20651-1-git-send-email-ldewangan@nvidia.com>
References: <1365594483-20651-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable SPI4 and add Winbond SPI flash W25Q32DW device
on CS0 line.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra114-dalmore.dts |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index 12198d1..295a1be 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -823,6 +823,16 @@
 		};
 	};
 
+	spi@7000da00 {
+		status = "okay";
+		spi-max-frequency = <25000000>;
+		spi-flash@0 {
+			compatible = "winbond,w25q32dw";
+			reg = <0>;
+			spi-max-frequency = <20000000>;
+		};
+	};
+
 	kbc {
 		status = "okay";
 		nvidia,debounce-delay-ms = <640>;
-- 
1.7.1.1

