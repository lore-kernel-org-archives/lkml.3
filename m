Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324AbaFILAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 07:00:17 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:42445 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126AbaFIK71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:59:27 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 4/4] ARM: sunxi: dt: Add DT bindings documentation for SUNXI Security System
Date: Mon,  9 Jun 2014 12:59:11 +0200
Message-Id: <1402311551-19564-5-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1402311551-19564-1-git-send-email-clabbe.montjoie@gmail.com>
References: <1402311551-19564-1-git-send-email-clabbe.montjoie@gmail.com>
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

