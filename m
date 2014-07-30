Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaG3PIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:08:38 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59421 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbaG3PHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:07:21 -0400
From: Robert Richter <rric@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Robert Richter <rrichter@cavium.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 3/5] arm64, thunder: document devicetree bindings for Cavium Thunder SoC
Date: Wed, 30 Jul 2014 17:06:32 +0200
Message-Id: <1406732794-20920-4-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406732794-20920-1-git-send-email-rric@kernel.org>
References: <1406732794-20920-1-git-send-email-rric@kernel.org>
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
index 1fe72a0778cd..922e4970309d 100644
--- a/Documentation/devicetree/bindings/arm/cpus.txt
+++ b/Documentation/devicetree/bindings/arm/cpus.txt
@@ -163,6 +163,7 @@ nodes to be present and contain the properties described below.
 			    "arm,cortex-r4"
 			    "arm,cortex-r5"
 			    "arm,cortex-r7"
+			    "cavium,thunder"
 			    "faraday,fa526"
 			    "intel,sa110"
 			    "intel,sa1100"
-- 
2.0.1

