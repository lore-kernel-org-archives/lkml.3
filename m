Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbaCCKKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 05:10:03 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:53504 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbaCCKJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 05:09:58 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com
Cc: plagnioj@jcrosoft.com, b.brezillon@overkiz.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregory.clement@free-electrons.com, devicetree@vger.kernel.org,
        thomas.petazzoni@free-electrons.com,
        alexandre.belloni@free-electrons.com,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v5 2/9] dt: bindings: at91: Add a new binding for the bus matrix
Date: Mon,  3 Mar 2014 11:05:55 +0100
Message-Id: <1393841162-25339-3-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393841162-25339-1-git-send-email-jjhiblot@traphandler.com>
References: <1393841162-25339-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This binding is used to initialize the bus matrix base address.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 Documentation/devicetree/bindings/arm/atmel-at91.txt | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.txt b/Documentation/devicetree/bindings/arm/atmel-at91.txt
index 16f60b4..bf9cb13 100644
--- a/Documentation/devicetree/bindings/arm/atmel-at91.txt
+++ b/Documentation/devicetree/bindings/arm/atmel-at91.txt
@@ -105,3 +105,17 @@ Example:
 		compatible = "atmel,at91sam9260-rstc";
 		reg = <0xfffffd00 0x10>;
 	};
+
+Bus Matrix controller
+
+required properties:
+- compatible: Should be "atmel,<chip>-bus-matrix".
+  <chip> can be "at91sam9260".
+- reg: Should contain registers location and length
+
+Example:
+
+	matrix: matrix@ffffee00 {
+		compatible = "atmel,at91sam9260-bus-matrix";
+		reg = <0xffffee00 0x200>;
+	};
-- 
1.9.0

