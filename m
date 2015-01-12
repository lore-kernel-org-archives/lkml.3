Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbbALTCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:02:10 -0500
Received: from down.free-electrons.com ([37.187.137.238]:56947 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756514AbbALTCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:02:05 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 3/6] ARM: at91/dt: at91rm9200ek: enable RTC
Date: Mon, 12 Jan 2015 20:01:54 +0100
Message-Id: <1421089317-12607-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421089317-12607-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421089317-12607-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the RTC on the at91rm9200ek.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91rm9200ek.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/at91rm9200ek.dts b/arch/arm/boot/dts/at91rm9200ek.dts
index 43eb779dd6f6..2a5d21247d7e 100644
--- a/arch/arm/boot/dts/at91rm9200ek.dts
+++ b/arch/arm/boot/dts/at91rm9200ek.dts
@@ -77,6 +77,10 @@
 			dbgu: serial@fffff200 {
 				status = "okay";
 			};
+
+			rtc: rtc@fffffe00 {
+				status = "okay";
+			};
 		};
 
 		usb0: ohci@00300000 {
-- 
2.1.0

