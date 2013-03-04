Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab3CDTBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:01:31 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4917 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758790Ab3CDTB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:01:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 04 Mar 2013 11:01:06 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>, Anton Vorontsov <cbou@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH v2 3/4] power_supply: tps65090-charger: Add binding doc
Date: Mon, 4 Mar 2013 14:01:48 -0500
Message-ID: <1362423709-29596-4-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362423709-29596-1-git-send-email-rklein@nvidia.com>
References: <1362423709-29596-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds the binding documentation for the tps65090-charger.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
v2:
 - no changes since v1

 .../devicetree/bindings/power_supply/tps65090.txt  |   23 ++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/tps65090.txt

diff --git a/Documentation/devicetree/bindings/power_supply/tps65090.txt b/Documentation/devicetree/bindings/power_supply/tps65090.txt
new file mode 100644
index 0000000..56370c7
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/tps65090.txt
@@ -0,0 +1,23 @@
+TPS65090 Frontend PMU with Switchmode Charger
+
+Required Properties:
+-compatible: "ti,tps65090"
+-reg: I2C slave address
+-interrupts: the interrupt output to which this device connects
+
+Optional Properties:
+-ti,enable-low-current-chrg: Enables charging when a low current is detected
+ while the default logic is to stop charging.
+
+Example:
+
+	tps65090@48 {
+		compatible = "ti,tps65090";
+		reg = <0x48>;
+		interrupts = <0 88 0x4>;
+
+		ti,enable-low-current-chrg;
+
+		regulators {
+			...
+		};
-- 
1.7.9.5

