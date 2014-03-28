Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaC1VUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:20:40 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:41960 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbaC1VUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:20:38 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 1/2] dt/bindings: add binding for ARM Versatile character LCD
Date: Fri, 28 Mar 2014 16:20:28 -0500
Message-Id: <1396041629-28820-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Add binding doc for Versatile platforms character LCD controller
interface.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 Documentation/devicetree/bindings/misc/arm-charlcd.txt | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/misc/arm-charlcd.txt

diff --git a/Documentation/devicetree/bindings/misc/arm-charlcd.txt b/Documentation/devicetree/bindings/misc/arm-charlcd.txt
new file mode 100644
index 0000000..e28e2aa
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/arm-charlcd.txt
@@ -0,0 +1,18 @@
+ARM Versatile Character LCD
+-----------------------------------------------------
+This binding defines the character LCD interface found on ARM Versatile AB
+and PB reference platforms.
+
+Required properties:
+- compatible : "arm,versatile-clcd"
+- reg : Location and size of character LCD registers
+
+Optional properties:
+- interrupts - single interrupt for character LCD. The character LCD can
+  operate in polled mode without an interrupt.
+
+Example:
+	lcd@10008000 {
+		compatible = "arm,versatile-lcd";
+		reg = <0x10008000 0x1000>;
+	};
-- 
1.8.3.2

