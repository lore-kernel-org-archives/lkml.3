Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaILRuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:50:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46762 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaILRuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:50:14 -0400
From: Robert Richter <rric@kernel.org>
To: Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>,
        devicetree@vger.kernel.org
Subject: [PATCH v3 2/4] arm64, thunder: Document devicetree bindings for Cavium Thunder SoC
Date: Fri, 12 Sep 2014 19:49:45 +0200
Message-Id: <1410544187-15876-3-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410544187-15876-1-git-send-email-rric@kernel.org>
References: <1410544187-15876-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>

This patch adds documentation for the devicetree bindings used by the
DT files of Cavium Thunder SoC platforms.

Signed-off-by: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 Documentation/devicetree/bindings/arm/cavium-thunder.txt | 10 ++++++++++
 Documentation/devicetree/bindings/arm/cpus.txt           |  1 +
 2 files changed, 11 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/cavium-thunder.txt

diff --git a/Documentation/devicetree/bindings/arm/cavium-thunder.txt b/Documentation/devicetree/bindings/arm/cavium-thunder.txt
new file mode 100644
index 000000000000..6f63a5866902
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/cavium-thunder.txt
@@ -0,0 +1,10 @@
+Cavium Thunder platform device tree bindings
+--------------------------------------------
+
+Boards with Cavium's Thunder SoC shall have following properties.
+
+Root Node
+---------
+Required root node properties:
+
+  - compatible = "cavium,thunder-88xx";
diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
index 298e2f6b33c6..578796a2cfa9 100644
--- a/Documentation/devicetree/bindings/arm/cpus.txt
+++ b/Documentation/devicetree/bindings/arm/cpus.txt
@@ -166,6 +166,7 @@ nodes to be present and contain the properties described below.
 			    "arm,cortex-r5"
 			    "arm,cortex-r7"
 			    "brcm,brahma-b15"
+			    "cavium,thunder"
 			    "faraday,fa526"
 			    "intel,sa110"
 			    "intel,sa1100"
-- 
2.1.0

