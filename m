Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaBSPdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:33:20 -0500
Received: from top.free-electrons.com ([176.31.233.9]:50024 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754137AbaBSPdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:33:17 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        b.brezillon@overkiz.com,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 7/8] ARM: at91/dt: define main clk frequency of at91sam9rlek
Date: Wed, 19 Feb 2014 16:32:30 +0100
Message-Id: <1392823951-26053-8-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392823951-26053-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1392823951-26053-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the main clock frequency for the new main clock node in
at91sam9rlek.dts

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9rlek.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9rlek.dts b/arch/arm/boot/dts/at91sam9rlek.dts
index aa76b1d7285a..813ca76a19cd 100644
--- a/arch/arm/boot/dts/at91sam9rlek.dts
+++ b/arch/arm/boot/dts/at91sam9rlek.dts
@@ -68,6 +68,12 @@
 				};
 			};
 
+			pmc: pmc@fffffc00 {
+				main: mainck {
+					clock-frequency = <12000000>;
+				};
+			};
+
 			watchdog@fffffd40 {
 				status = "okay";
 			};
-- 
1.8.3.2

