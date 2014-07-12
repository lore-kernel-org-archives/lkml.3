Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaGLM7a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 08:59:30 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47768 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaGLM7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 08:59:23 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v4 2/3] ARM: sunxi: dt: Add DT bindings documentation for SUNXI Security System
Date: Sat, 12 Jul 2014 14:59:12 +0200
Message-Id: <1405169953-13695-3-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1405169953-13695-1-git-send-email-clabbe.montjoie@gmail.com>
References: <1405169953-13695-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds documentation for Device-Tree bindings for the Security
System cryptographic accelerator driver.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 Documentation/devicetree/bindings/crypto/sunxi-ss.txt | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/sunxi-ss.txt

diff --git a/Documentation/devicetree/bindings/crypto/sunxi-ss.txt b/Documentation/devicetree/bindings/crypto/sunxi-ss.txt
new file mode 100644
index 0000000..a566803
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/sunxi-ss.txt
@@ -0,0 +1,9 @@
+* Allwinner Security System found on A20 SoC
+
+Required properties:
+- compatible : Should be "allwinner,sun7i-a20-crypto".
+- reg: Should contain the Security System register location and length.
+- interrupts: Should contain the IRQ line for the Security System.
+- clocks : A phandle to the functional clock node of the Security System module
+- clock-names : Name of the functional clock, should be "ahb" and "mod".
+
-- 
1.8.5.5

