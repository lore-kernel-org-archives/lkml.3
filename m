Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaFDLre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:47:34 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10130 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaFDLrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:47:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 04 Jun 2014 04:42:21 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <tj@kernel.org>,
        <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>, <devicetree@vger.kernel.org>
Subject: [PATCH 1/9] of: Add NVIDIA Tegra SATA controller binding
Date: Wed, 4 Jun 2014 14:32:31 +0300
Message-ID: <1401881559-18469-2-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree binding documentation for the SATA
controller found on NVIDIA Tegra SoCs.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Cc: devicetree@vger.kernel.org
---
 .../devicetree/bindings/ata/tegra-sata.txt         | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ata/tegra-sata.txt

diff --git a/Documentation/devicetree/bindings/ata/tegra-sata.txt b/Documentation/devicetree/bindings/ata/tegra-sata.txt
new file mode 100644
index 0000000..70e3119
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/tegra-sata.txt
@@ -0,0 +1,29 @@
+Tegra124 SoC SATA AHCI controller
+
+Required properties :
+ - compatible : Should be "nvidia,tegra124-ahci".
+ - reg : Defines the following set of registers, in the order listed:
+   - AHCI register set (SATA BAR5)
+   - SATA register set
+ - interrupts : Defines the interrupt used by SATA
+ - clocks : Defines the clocks listed in the clock-names property.
+ - clock-names : The following clock names must be present:
+   - sata
+   - sata-oob
+   - cml1
+   - pll_e
+ - resets : Defines the resets listed in the reset-names property
+ - reset-names : The following reset names must be present:
+   - sata
+   - sata-oob
+   - sata-cold
+ - phys : Defines the phys listed in the phy-names property
+ - phy-names : The following phy names must be present:
+   - sata-phy : XUSB PADCTL SATA PHY
+ - hvdd-supply : Defines the SATA HVDD regulator
+ - vddio-supply : Defines the SATA VDDIO regulator
+ - avdd-supply : Defines the SATA AVDD regulator
+
+Optional properties:
+ - target-supply : Defines a regulator for a power output connector
+                   for SATA devices.
-- 
1.8.1.5

