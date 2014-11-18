Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbaKRUZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:25:34 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52213 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbaKRUZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:25:30 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        Sean Young <sean@mess.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v3 1/3] media: rc: meson: document device tree bindings
Date: Tue, 18 Nov 2014 21:22:33 +0100
Message-Id: <1416342155-26820-2-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416342155-26820-1-git-send-email-b.galvani@gmail.com>
References: <1416342155-26820-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds binding documentation for the infrared remote control
receiver available in Amlogic Meson SoCs.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 Documentation/devicetree/bindings/media/meson-ir.txt | 14 ++++++++++++++
 1 file changed, 14 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/meson-ir.txt

diff --git a/Documentation/devicetree/bindings/media/meson-ir.txt b/Documentation/devicetree/bindings/media/meson-ir.txt
new file mode 100644
index 0000000..407848e
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/meson-ir.txt
@@ -0,0 +1,14 @@
+* Amlogic Meson IR remote control receiver
+
+Required properties:
+ - compatible	: should be "amlogic,meson6-ir"
+ - reg		: physical base address and length of the device registers
+ - interrupts	: a single specifier for the interrupt from the device
+
+Example:
+
+	ir-receiver@c8100480 {
+		compatible= "amlogic,meson6-ir";
+		reg = <0xc8100480 0x20>;
+		interrupts = <0 15 1>;
+	};
-- 
1.9.1

