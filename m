Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbbA1UyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:54:24 -0500
Received: from mail-oi0-f42.google.com ([209.85.218.42]:42300 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbbA1UyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:54:20 -0500
From: Rob Herring <robh@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 1/3] dt/bindings: Add binding for Versatile system registers
Date: Wed, 28 Jan 2015 11:56:30 -0600
Message-Id: <1422467792-2065-2-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422467792-2065-1-git-send-email-robh@kernel.org>
References: <1422467792-2065-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding for Versatile board system registers found in the FPGA of the
Versatile/AB and Versatile/PB boards.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org
---
 Documentation/devicetree/bindings/arm/versatile-sysreg.txt | 10 ++++++++++
 1 file changed, 10 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/versatile-sysreg.txt

diff --git a/Documentation/devicetree/bindings/arm/versatile-sysreg.txt b/Documentation/devicetree/bindings/arm/versatile-sysreg.txt
new file mode 100644
index 0000000..a4f1526
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/versatile-sysreg.txt
@@ -0,0 +1,10 @@
+ARM Versatile system registers
+--------------------------------------
+
+This is a system control registers block, providing multiple low level
+platform functions like board detection and identification, software
+interrupt generation, MMC and NOR Flash control etc.
+
+Required node properties:
+- compatible value : = "arm,versatile-sysreg", "syscon"
+- reg : physical base address and the size of the registers window
-- 
2.1.0

