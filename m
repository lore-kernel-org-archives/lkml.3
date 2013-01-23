Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab3AWJvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:51:38 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:34712 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab3AWJtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:49:18 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <richard.genoud@gmail.com>, <linux-arm@overkiz.com>,
        <manabian@gmail.com>, <dgilbert@interlog.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Josh Wu <josh.wu@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 4/9] ARM: at91: fix gpios on i2c-gpio for RM9200 DT
Date: Wed, 23 Jan 2013 10:48:51 +0100
Message-ID: <334c9e8d6d05be132792a855dcc637773d44cad3.1358934163.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1358934163.git.nicolas.ferre@atmel.com>
References: <cover.1358934163.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joachim Eastwood <manabian@gmail.com>

Signed-off-by: Joachim Eastwood <manabian@gmail.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91rm9200.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91rm9200.dtsi b/arch/arm/boot/dts/at91rm9200.dtsi
index e154f24..222047f 100644
--- a/arch/arm/boot/dts/at91rm9200.dtsi
+++ b/arch/arm/boot/dts/at91rm9200.dtsi
@@ -336,8 +336,8 @@
 
 	i2c@0 {
 		compatible = "i2c-gpio";
-		gpios = <&pioA 23 0 /* sda */
-			 &pioA 24 0 /* scl */
+		gpios = <&pioA 25 0 /* sda */
+			 &pioA 26 0 /* scl */
 			>;
 		i2c-gpio,sda-open-drain;
 		i2c-gpio,scl-open-drain;
-- 
1.8.0

