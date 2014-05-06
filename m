Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaEFRKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:10:52 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:35858 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaEFRKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:10:45 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Heiko Stuebner <heiko@sntech.de>
Cc: Matthias Brugger <matthias.bgg@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 2/2] ARM: dts: rockchip: add root compatible properties
Date: Tue,  6 May 2014 19:10:11 +0200
Message-Id: <1399396211-25353-2-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399396211-25353-1-git-send-email-b.galvani@gmail.com>
References: <1399396211-25353-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing 'compatible' property to device tree root node of

 - rk3066a-bqcurie2.dts
 - rk3188-radxarock.dts

and document the new values.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---

v2:
 - use mundoreader prefix instead of bq as suggested by Heiko Stuebner

 Documentation/devicetree/bindings/arm/rockchip.txt |   10 ++++++++++
 arch/arm/boot/dts/rk3066a-bqcurie2.dts             |    1 +
 arch/arm/boot/dts/rk3188-radxarock.dts             |    1 +
 3 files changed, 12 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip.txt

diff --git a/Documentation/devicetree/bindings/arm/rockchip.txt b/Documentation/devicetree/bindings/arm/rockchip.txt
new file mode 100644
index 0000000..857f126
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/rockchip.txt
@@ -0,0 +1,10 @@
+Rockchip platforms device tree bindings
+---------------------------------------
+
+- bq Curie 2 tablet:
+    Required root node properties:
+      - compatible = "mundoreader,bq-curie2", "rockchip,rk3066a";
+
+- Radxa Rock board:
+    Required root node properties:
+      - compatible = "radxa,rock", "rockchip,rk3188";
diff --git a/arch/arm/boot/dts/rk3066a-bqcurie2.dts b/arch/arm/boot/dts/rk3066a-bqcurie2.dts
index 035df40..afb3273 100644
--- a/arch/arm/boot/dts/rk3066a-bqcurie2.dts
+++ b/arch/arm/boot/dts/rk3066a-bqcurie2.dts
@@ -18,6 +18,7 @@
 
 / {
 	model = "bq Curie 2";
+	compatible = "mundoreader,bq-curie2", "rockchip,rk3066a";
 
 	memory {
 		reg = <0x60000000 0x40000000>;
diff --git a/arch/arm/boot/dts/rk3188-radxarock.dts b/arch/arm/boot/dts/rk3188-radxarock.dts
index 3ba1968..a5eee55 100644
--- a/arch/arm/boot/dts/rk3188-radxarock.dts
+++ b/arch/arm/boot/dts/rk3188-radxarock.dts
@@ -17,6 +17,7 @@
 
 / {
 	model = "Radxa Rock";
+	compatible = "radxa,rock", "rockchip,rk3188";
 
 	memory {
 		reg = <0x60000000 0x80000000>;
-- 
1.7.10.4

