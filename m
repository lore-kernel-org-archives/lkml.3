Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbaCQPGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 11:06:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58940 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932903AbaCQPGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 11:06:35 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] ARM: berlin2q: add the Marvell Armada 1500 pro in the documentation
Date: Mon, 17 Mar 2014 16:06:27 +0100
Message-Id: <1395068788-19786-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395068788-19786-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1395068788-19786-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 Documentation/arm/Marvell/README                         | 5 +++++
 Documentation/devicetree/bindings/arm/marvell,berlin.txt | 1 +
 2 files changed, 6 insertions(+)

diff --git a/Documentation/arm/Marvell/README b/Documentation/arm/Marvell/README
index 5a930c1528ad..eb6f212625f9 100644
--- a/Documentation/arm/Marvell/README
+++ b/Documentation/arm/Marvell/README
@@ -224,6 +224,11 @@ Berlin family (Digital Entertainment)
 		Core:		Marvell PJ4B (ARMv7), Tauros3 L2CC
 		Homepage:	http://www.marvell.com/digital-entertainment/armada-1500/
 		Product Brief:	http://www.marvell.com/digital-entertainment/armada-1500/assets/Marvell-ARMADA-1500-Product-Brief.pdf
+	88DE3114, Armada 1500 Pro
+		Design name:	BG2-Q
+		Core:		Quad Core ARM Cortex-A9, PL310 L2CC
+		Homepage:	http://www.marvell.com/digital-entertainment/armada-1500-pro/
+		Product Brief:	http://www.marvell.com/digital-entertainment/armada-1500-pro/assets/Marvell_ARMADA_1500_PRO-01_product_brief.pdf
 	88DE????
 		Design name:	BG3
 		Core:		ARM Cortex-A15, CA15 integrated L2CC
diff --git a/Documentation/devicetree/bindings/arm/marvell,berlin.txt b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
index 737afa5f8148..86b7f60c74fc 100644
--- a/Documentation/devicetree/bindings/arm/marvell,berlin.txt
+++ b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
@@ -11,6 +11,7 @@ In addition, the above compatible shall be extended with the specific
 SoC and board used. Currently known SoC compatibles are:
     "marvell,berlin2"      for Marvell Armada 1500 (BG2, 88DE3100),
     "marvell,berlin2cd"    for Marvell Armada 1500-mini (BG2CD, 88DE3005)
+    "marvell,berlin2q"     for Marvell Armada 1500-pro (BG2Q, 88DE3114)
     "marvell,berlin2ct"    for Marvell Armada ? (BG2CT, 88DE????)
     "marvell,berlin3"      for Marvell Armada ? (BG3, 88DE????)
 
-- 
1.8.3.2

