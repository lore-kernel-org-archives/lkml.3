Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab3GEQNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:13:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:45858 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412Ab3GEQMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:12:55 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [RFC 2/2] temporary disable first instance
Date: Fri,  5 Jul 2013 18:12:44 +0200
Message-Id: <1373040764-3711-3-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373040764-3711-1-git-send-email-bigeasy@linutronix.de>
References: <1373040764-3711-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so testing is little easier.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/arm/boot/dts/am335x-evm.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index dc236f4..0b2f592 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -183,7 +183,7 @@
 			status = "okay";
 
 			usb0@47401000 {
-				status = "okay";
+				status = "no";
 			};
 
 			usb1@47401800 {
-- 
1.8.3.2

