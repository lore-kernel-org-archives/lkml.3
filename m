Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab3A2NAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:00:34 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5703 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab3A2M6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:58:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 29 Jan 2013 04:58:33 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 4/7] ARM: DT: tegra114: add pinmux DT entry
Date: Tue, 29 Jan 2013 18:26:20 +0530
Message-ID: <1359464183-6255-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1359464183-6255-1-git-send-email-ldewangan@nvidia.com>
References: <1359464183-6255-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT entry for pinmux and drive configuration addresses.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra114.dtsi |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index 74f6a77..210b4a7 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -91,6 +91,12 @@
 		interrupt-controller;
 	};
 
+	pinmux: pinmux {
+		compatible = "nvidia,tegra114-pinmux";
+		reg = <0x70000868 0x148		/* Pad control registers */
+		       0x70003000 0x40c>;	/* Mux registers */
+	};
+
 	serial@70006000 {
 		compatible = "nvidia,tegra114-uart", "nvidia,tegra20-uart";
 		reg = <0x70006000 0x40>;
-- 
1.7.1.1

