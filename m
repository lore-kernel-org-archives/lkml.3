Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3LSQ0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:26:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:54425 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab3LSQ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:26:08 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>, devicetree@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/2] of: add vendor prefix for Mentor Graphics
Date: Thu, 19 Dec 2013 17:25:50 +0100
Message-Id: <1387470351-4696-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.5.1
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prefix is currently used for the musb driver.

Acked-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 8c75d85..cb5c438 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -43,6 +43,7 @@ linux	Linux-specific binding
 lsi	LSI Corp. (LSI Logic)
 marvell	Marvell Technology Group Ltd.
 maxim	Maxim Integrated Products
+mentor	Mentor Graphics
 microchip	Microchip Technology Inc.
 mosaixtech	Mosaix Technologies, Inc.
 national	National Semiconductor
-- 
1.8.5.1

