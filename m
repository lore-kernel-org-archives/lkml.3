Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaCXIcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:32:15 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:44406 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaCXIcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:32:12 -0400
From: Boris BREZILLON <brezillonboris@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [PATCH v2 11/11] ARM: at91/dt: define sam9rlek crystal frequencies
Date: Mon, 24 Mar 2014 09:27:23 +0100
Message-Id: <1395649643-9146-12-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395649643-9146-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1395649643-9146-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define at91sam9rlek crystal frequencies.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9rlek.dts |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9rlek.dts b/arch/arm/boot/dts/at91sam9rlek.dts
index cddb378..85b68b9 100644
--- a/arch/arm/boot/dts/at91sam9rlek.dts
+++ b/arch/arm/boot/dts/at91sam9rlek.dts
@@ -25,6 +25,14 @@
 		#size-cells = <1>;
 		ranges;
 
+		slow_xtal: slow_xtal {
+			clock-frequency = <32768>;
+		};
+
+		main_xtal: main_xtal {
+			clock-frequency = <12000000>;
+		};
+
 		main_clock: clock {
 			compatible = "atmel,osc", "fixed-clock";
 			clock-frequency = <12000000>;
-- 
1.7.9.5

