Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab3JNQrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:47:04 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:47252 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab3JNQrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:47:01 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <ebenard@eukrea.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/3] ARM: at91/dt/trivial: before sama5d3, Atmel MPU were using at91 prefix
Date: Mon, 14 Oct 2013 18:46:36 +0200
Message-ID: <a7f43a96aaf83c3348dc631c71c54729f9d0e9e0.1381769174.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <ba9872c3bb29c9a06f06caa8e0b4528329f07675.1381769174.git.nicolas.ferre@atmel.com>
References: <ba9872c3bb29c9a06f06caa8e0b4528329f07675.1381769174.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the sha/aes/tdes compatibility string to match common
case for the at91sam9g45 family which is to keep the at91 prefix.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/sama5d3.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index b2aabff..99bd4a6 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -342,19 +342,19 @@
 			};
 
 			sha@f8034000 {
-				compatible = "atmel,sam9g46-sha";
+				compatible = "atmel,at91sam9g46-sha";
 				reg = <0xf8034000 0x100>;
 				interrupts = <42 IRQ_TYPE_LEVEL_HIGH 0>;
 			};
 
 			aes@f8038000 {
-				compatible = "atmel,sam9g46-aes";
+				compatible = "atmel,at91sam9g46-aes";
 				reg = <0xf8038000 0x100>;
 				interrupts = <43 IRQ_TYPE_LEVEL_HIGH 0>;
 			};
 
 			tdes@f803c000 {
-				compatible = "atmel,sam9g46-tdes";
+				compatible = "atmel,at91sam9g46-tdes";
 				reg = <0xf803c000 0x100>;
 				interrupts = <44 IRQ_TYPE_LEVEL_HIGH 0>;
 			};
-- 
1.8.2.2

