Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965763AbaH1K6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:58:52 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:50849 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936526AbaH1K6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:58:51 -0400
From: Gyungoh Yoo <gyungoh@gmail.com>
X-Google-Original-From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: jack.yoo@skyworksinc.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] Adding SKY81452 regulator device tree bindings document
Date: Thu, 28 Aug 2014 19:58:38 +0900
Message-Id: <1409223518-23566-1-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409222307-23225-1-git-send-email-jack.yoo@skyworksinc.com>
References: <1409222307-23225-1-git-send-email-jack.yoo@skyworksinc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
Added 'compatible' attribute in child drivers

---
 .../bindings/regulator/sky81452-regulator.txt          | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/sky81452-regulator.txt

diff --git a/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt b/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
new file mode 100644
index 0000000..7b9ff18
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
@@ -0,0 +1,18 @@
+SKY81452 voltage regulator
+
+Required properties:
+- compatible	: Must be "skyworks,sky81452-regulator"
+- any required generic properties defined in regulator.txt
+
+Optional properties:
+- any available generic properties defined in regulator.txt
+
+Example:
+
+	regulator {
+		compatible = "skyworks,sky81452-regulator";
+		/* generic regulator properties */
+		regulator-name = "touch_en";
+		regulator-min-microvolt = <4500000>;
+		regulator-max-microvolt = <8000000>;
+	};
-- 
1.9.1

