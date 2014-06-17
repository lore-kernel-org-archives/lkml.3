Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965518AbaFQQo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:44:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48055 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965461AbaFQQlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:41:55 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 1/6] ARM: at91/dt: define sam9261ek slow crystal frequency
Date: Tue, 17 Jun 2014 18:41:43 +0200
Message-Id: <1403023308-20533-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403023308-20533-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1403023308-20533-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define at91sam9261ek's slow crystal frequencies.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9261ek.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9261ek.dts b/arch/arm/boot/dts/at91sam9261ek.dts
index c6683ea8b743..aa35a7aec9a8 100644
--- a/arch/arm/boot/dts/at91sam9261ek.dts
+++ b/arch/arm/boot/dts/at91sam9261ek.dts
@@ -20,6 +20,10 @@
 		reg = <0x20000000 0x4000000>;
 	};
 
+	slow_xtal {
+		clock-frequency = <32768>;
+	};
+
 	main_xtal {
 		clock-frequency = <18432000>;
 	};
-- 
1.9.1

