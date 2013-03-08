Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934194Ab3CHNzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:55:12 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9922 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934169Ab3CHNzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:55:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 08 Mar 2013 05:48:46 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pdeschrijver@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 4/5] ARM: DT: tegra114: add KBC controller DT entry
Date: Fri, 8 Mar 2013 19:23:01 +0530
Message-ID: <1362750782-15174-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1362750782-15174-1-git-send-email-ldewangan@nvidia.com>
References: <1362750782-15174-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NVIDIA's Tegra114 SoCs have the matrix keyboard controller which
supports 11x8 type of matrix. The number of rows and columns
are configurable.

Add DT entry for KBC controller.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra114.dtsi |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index 686e33f..18fbd49 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -248,6 +248,14 @@
 		clocks = <&tegra_car 4>;
 	};
 
+	kbc {
+		compatible = "nvidia,tegra20-kbc";
+		reg = <0x7000e200 0x100>;
+		interrupts = <0 85 0x04>;
+		clocks = <&tegra_car 36>;
+		status = "disabled";
+	};
+
 	pmc {
 		compatible = "nvidia,tegra114-pmc";
 		reg = <0x7000e400 0x400>;
-- 
1.7.1.1

