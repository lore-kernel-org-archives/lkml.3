Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905Ab3EFXlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:41:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760302Ab3EFXNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:13:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [ 010/104] ARM: at91/trivial: typos in compatible property
Date: Mon,  6 May 2013 16:11:29 -0700
Message-Id: <20130506230044.649875075@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 2a5a461f179509142c661d79f878855798b85201 upstream.

- unneeded whitespace
- missing double quote

Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/at91sam9g15.dtsi |    2 +-
 arch/arm/boot/dts/at91sam9g25.dtsi |    2 +-
 arch/arm/boot/dts/at91sam9g35.dtsi |    2 +-
 arch/arm/boot/dts/at91sam9x25.dtsi |    2 +-
 arch/arm/boot/dts/at91sam9x35.dtsi |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm/boot/dts/at91sam9g15.dtsi
+++ b/arch/arm/boot/dts/at91sam9g15.dtsi
@@ -10,7 +10,7 @@
 
 / {
 	model = "Atmel AT91SAM9G15 SoC";
-	compatible = "atmel, at91sam9g15, atmel,at91sam9x5";
+	compatible = "atmel,at91sam9g15", "atmel,at91sam9x5";
 
 	ahb {
 		apb {
--- a/arch/arm/boot/dts/at91sam9g25.dtsi
+++ b/arch/arm/boot/dts/at91sam9g25.dtsi
@@ -10,7 +10,7 @@
 
 / {
 	model = "Atmel AT91SAM9G25 SoC";
-	compatible = "atmel, at91sam9g25, atmel,at91sam9x5";
+	compatible = "atmel,at91sam9g25", "atmel,at91sam9x5";
 
 	ahb {
 		apb {
--- a/arch/arm/boot/dts/at91sam9g35.dtsi
+++ b/arch/arm/boot/dts/at91sam9g35.dtsi
@@ -10,7 +10,7 @@
 
 / {
 	model = "Atmel AT91SAM9G35 SoC";
-	compatible = "atmel, at91sam9g35, atmel,at91sam9x5";
+	compatible = "atmel,at91sam9g35", "atmel,at91sam9x5";
 
 	ahb {
 		apb {
--- a/arch/arm/boot/dts/at91sam9x25.dtsi
+++ b/arch/arm/boot/dts/at91sam9x25.dtsi
@@ -10,7 +10,7 @@
 
 / {
 	model = "Atmel AT91SAM9X25 SoC";
-	compatible = "atmel, at91sam9x25, atmel,at91sam9x5";
+	compatible = "atmel,at91sam9x25", "atmel,at91sam9x5";
 
 	ahb {
 		apb {
--- a/arch/arm/boot/dts/at91sam9x35.dtsi
+++ b/arch/arm/boot/dts/at91sam9x35.dtsi
@@ -10,7 +10,7 @@
 
 / {
 	model = "Atmel AT91SAM9X35 SoC";
-	compatible = "atmel, at91sam9x35, atmel,at91sam9x5";
+	compatible = "atmel,at91sam9x35", "atmel,at91sam9x5";
 
 	ahb {
 		apb {


