Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab3I0Wj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 18:39:56 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2418 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab3I0Wju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 18:39:50 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Wendy Ng" <wendy.ng@broadcom.com>
To: "Rob Herring" <rob.herring@calxeda.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>
cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Christian Daudt" <bcm@fixthebug.org>,
        "Markus Mayer" <mmayer@broadcom.com>,
        "Wendy Ng" <wendy.ng@broadcom.com>
Subject: [PATCH v2 3/3] ARM: bcm281xx: Add thermal driver to device
 tree.
Date: Fri, 27 Sep 2013 15:37:34 -0700
Message-ID: <1380321454-16216-4-git-send-email-wendy.ng@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380321454-16216-1-git-send-email-wendy.ng@broadcom.com>
References: <1380321454-16216-1-git-send-email-wendy.ng@broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7E58D7B40UO11863344-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the device tree node for Broadcom bcm281xx SoCs thermal
driver.

Signed-off-by: Wendy Ng <wendy.ng@broadcom.com>
Reviewed-by: Markus Mayer <mmayer@broadcom.com>
Reviewed-by: Christian Daudt <csd@broadcom.com>
---
 arch/arm/boot/dts/bcm11351-brt.dts |    4 +++-
 arch/arm/boot/dts/bcm11351.dtsi    |    6 ++++++
 arch/arm/boot/dts/bcm28155-ap.dts  |    4 ++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm11351-brt.dts b/arch/arm/boot/dts/bcm11351-brt.dts
index 9d36eb4..0771b6b 100644
--- a/arch/arm/boot/dts/bcm11351-brt.dts
+++ b/arch/arm/boot/dts/bcm11351-brt.dts
@@ -43,5 +43,7 @@
 		status = "okay";
 	};
 
-
+	thermal@34008000 {
+		status = "okay";
+	};
 };
diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index 05a5aab..aa13353 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -96,4 +96,10 @@
 		status = "disabled";
 	};
 
+	thermal@34008000 {
+		compatible = "brcm,bcm11351-thermal", "brcm,kona-thermal";
+		reg = <0x34008000 0x0024>;
+		thermal-name = "bcm_kona_therm";
+		status = "disabled";
+	};
 };
diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
index 96ae67a..a39aa47 100644
--- a/arch/arm/boot/dts/bcm28155-ap.dts
+++ b/arch/arm/boot/dts/bcm28155-ap.dts
@@ -42,4 +42,8 @@
 		max-frequency = <48000000>;
 		status = "okay";
 	};
+
+	thermal@34008000 {
+		status = "okay";
+	};
 };
-- 
1.7.9.5


