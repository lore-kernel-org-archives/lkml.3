Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750980Ab3HSGfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 02:35:16 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:18086 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab3HSGfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 02:35:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 18 Aug 2013 23:35:13 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ian.campbell@citrix.com>
CC: <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Bill Huang <bilhuang@nvidia.com>
Subject: [PATCH 1/1] ARM: tegra: configure power off for Dalmore
Date: Sun, 18 Aug 2013 23:33:48 -0700
Message-ID: <1376894028-30060-1-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT property to tell the regulator to register pm_power_off to make
"shutdown" work.

Signed-off-by: Bill Huang <bilhuang@nvidia.com>
---
 arch/arm/boot/dts/tegra114-dalmore.dts |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index 45056a2..6023028 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -845,6 +845,8 @@
 			#interrupt-cells = <2>;
 			interrupt-controller;
 
+			ti,system-power-controller;
+
 			palmas_gpio: gpio {
 				compatible = "ti,palmas-gpio";
 				gpio-controller;
-- 
1.7.9.5

