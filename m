Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab3DRNBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:01:31 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:4359 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158Ab3DRNB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:01:29 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <dgilbert@interlog.com>, <robertcnelson@gmail.com>,
        <tanzilli@acmesystems.it>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/5] ARM: at91/at91-ariag25.dts: add RTC node
Date: Thu, 18 Apr 2013 15:01:10 +0200
Message-ID: <e9b6608c125ef499d095a65e6b2f7c8b06d3f469.1366289869.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1366289869.git.nicolas.ferre@atmel.com>
References: <cover.1366289869.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91-ariag25.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/at91-ariag25.dts b/arch/arm/boot/dts/at91-ariag25.dts
index c7aebba..1de619c 100644
--- a/arch/arm/boot/dts/at91-ariag25.dts
+++ b/arch/arm/boot/dts/at91-ariag25.dts
@@ -138,6 +138,10 @@
 					};
 				};
 			};
+
+			rtc@fffffeb0 {
+				status = "okay";
+			};
 		};
 
 		usb0: ohci@00600000 {
-- 
1.8.0

