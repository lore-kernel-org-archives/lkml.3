Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab3CLWK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:10:26 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15125 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab3CLWKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:10:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 12 Mar 2013 15:10:04 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [Patch v3 3/4] power_supply: tps65090-charger: Add binding doc
Date: Tue, 12 Mar 2013 18:08:08 -0400
Message-ID: <1363126089-9071-4-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363126089-9071-1-git-send-email-rklein@nvidia.com>
References: <1363126089-9071-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds the binding documentation for the tps65090-charger.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
v3:
 - no changes since v2
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

