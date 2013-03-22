Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472Ab3CVOYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:24:03 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:56956 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab3CVOX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:23:59 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/4] ARM: at91/trivial: typos in compatible property
Date: Fri, 22 Mar 2013 15:23:34 +0100
Message-ID: <df0e644fa686115c042dce7152c17fdcbd71ed0f.1363960549.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1363960549.git.nicolas.ferre@atmel.com>
References: <cover.1363960549.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- unneeded whitespace
- missing double quote

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: stable <stable@vger.kernel.org> # 3.8+
---
 arch/arm/boot/dts/at91sam9g15.dtsi | 2 +-
 arch/arm/boot/dts/at91sam9g25.dtsi | 2 +-
 arch/arm/boot/dts/at91sam9g35.dtsi | 2 +-
 arch/arm/boot/dts/at91sam9x25.dtsi | 2 +-
 arch/arm/boot/dts/at91sam9x35.dtsi | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9g15.dtsi b/arch/arm/boot/dts/at91sam9g15.dtsi
index fbe7a70..28467fd 100644
--- a/arch/arm/boot/dts/at91sam9g15.dtsi
+++ b/arch/arm/boot/dts/at91sam9g15.dtsi
@@ -10,7 +10,7 @@
 
 / {
 	model = "Atmel AT91SAM9G15 SoC";
-	compatible = "atmel, at91sam9g15, atmel,at91sam9x5";
+	compatible = "atmel,at91sam9g15", "atmel,at91sam9x5";
 
 	ahb {
 		apb {
diff --git a/arch/arm/boot/dts/at91sam9g25.dtsi b/arch/arm/boot/dts/at91sam9g25.dtsi
index 05a718f..5fd32df 100644
--- a/arch/arm/boot/dts/at91sam9g25.dtsi
+++ b/arch/arm/boot/dts/at91sam9g25.dtsi
@@ -10,7 +10,7 @@
 
 / {
 	model = "Atmel AT91SAM9G25 SoC";
-	compatible = "atmel, at91sam9g25, atmel,at91sam9x5";
+	compatible = "atmel,at91sam9g25", "atmel,at91sam9x5";
 
 	ahb {
 		apb {
diff --git a/arch/arm/boot/dts/at91sam9g35.dtsi b/arch/arm/boot/dts/at91sam9g35.dtsi
index f9d14a7..d6fa8af 100644
--- a/arch/arm/boot/dts/at91sam9g35.dtsi
+++ b/arch/arm/boot/dts/at91sam9g35.dtsi
@@ -10,7 +10,7 @@
 
 / {
 	model = "Atmel AT91SAM9G35 SoC";
-	compatible = "atmel, at91sam9g35, atmel,at91sam9x5";
+	compatible = "atmel,at91sam9g35", "atmel,at91sam9x5";
 
 	ahb {
 		apb {
diff --git a/arch/arm/boot/dts/at91sam9x25.dtsi b/arch/arm/boot/dts/at91sam9x25.dtsi
index 54eb33b..9ac2bc2 100644
--- a/arch/arm/boot/dts/at91sam9x25.dtsi
+++ b/arch/arm/boot/dts/at91sam9x25.dtsi
@@ -10,7 +10,7 @@
 
 / {
 	model = "Atmel AT91SAM9X25 SoC";
-	compatible = "atmel, at91sam9x25, atmel,at91sam9x5";
+	compatible = "atmel,at91sam9x25", "atmel,at91sam9x5";
 
 	ahb {
 		apb {
diff --git a/arch/arm/boot/dts/at91sam9x35.dtsi b/arch/arm/boot/dts/at91sam9x35.dtsi
index fb102d6..ba67d83 100644
--- a/arch/arm/boot/dts/at91sam9x35.dtsi
+++ b/arch/arm/boot/dts/at91sam9x35.dtsi
@@ -10,7 +10,7 @@
 
 / {
 	model = "Atmel AT91SAM9X35 SoC";
-	compatible = "atmel, at91sam9x35, atmel,at91sam9x5";
+	compatible = "atmel,at91sam9x35", "atmel,at91sam9x5";
 
 	ahb {
 		apb {
-- 
1.8.0

