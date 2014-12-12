Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaLLWJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 17:09:44 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52190 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbaLLWIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 17:08:49 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        jogo@openwrt.org, arnd@arndb.de, computersforpeace@gmail.com,
        linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 22/23] MIPS: BMIPS: Update DT bindings to reflect new SoC support
Date: Fri, 12 Dec 2014 14:07:13 -0800
Message-Id: <1418422034-17099-23-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1418422034-17099-1-git-send-email-cernekee@gmail.com>
References: <1418422034-17099-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an entry for each supported Broadcom SoC.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 Documentation/devicetree/bindings/mips/brcm/cm-dsl.txt | 11 -----------
 Documentation/devicetree/bindings/mips/brcm/soc.txt    | 12 ++++++++++++
 2 files changed, 12 insertions(+), 11 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/mips/brcm/cm-dsl.txt
 create mode 100644 Documentation/devicetree/bindings/mips/brcm/soc.txt

diff --git a/Documentation/devicetree/bindings/mips/brcm/cm-dsl.txt b/Documentation/devicetree/bindings/mips/brcm/cm-dsl.txt
deleted file mode 100644
index 8a139cb..0000000
diff --git a/Documentation/devicetree/bindings/mips/brcm/soc.txt b/Documentation/devicetree/bindings/mips/brcm/soc.txt
new file mode 100644
index 0000000..f011443
--- /dev/null
+++ b/Documentation/devicetree/bindings/mips/brcm/soc.txt
@@ -0,0 +1,12 @@
+* Broadcom cable/DSL/settop platforms
+
+Required properties:
+
+- compatible: "brcm,bcm3384", "brcm,bcm33843"
+              "brcm,bcm3384-viper", "brcm,bcm33843-viper"
+              "brcm,bcm6328", "brcm,bcm6368",
+              "brcm,bcm7125", "brcm,bcm7346", "brcm,bcm7360",
+              "brcm,bcm7420", "brcm,bcm7425"
+
+The experimental -viper variants are for running Linux on the 3384's
+BMIPS4355 cable modem CPU instead of the BMIPS5000 application processor.
-- 
2.1.1

