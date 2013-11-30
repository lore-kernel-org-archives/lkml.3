Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3K3P0v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 10:26:51 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:45266 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3K3P0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 10:26:23 -0500
From: Marek Belisko <marek@goldelico.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH v2 2/2] misc: bmp085: devicetree irq update.
Date: Sat, 30 Nov 2013 16:26:01 +0100
Message-Id: <1385825161-5194-3-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385825161-5194-1-git-send-email-marek@goldelico.com>
References: <1385825161-5194-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document irq handling for bmp085.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 Documentation/devicetree/bindings/misc/bmp085.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/misc/bmp085.txt b/Documentation/devicetree/bindings/misc/bmp085.txt
index 91dfda2..d7a6deb 100644
--- a/Documentation/devicetree/bindings/misc/bmp085.txt
+++ b/Documentation/devicetree/bindings/misc/bmp085.txt
@@ -8,6 +8,8 @@ Optional properties:
 - temp-measurement-period: temperature measurement period (milliseconds)
 - default-oversampling: default oversampling value to be used at startup,
   value range is 0-3 with rising sensitivity.
+- interrupt-parent: should be the phandle for the interrupt controller
+- interrupts: interrupt mapping for IRQ
 
 Example:
 
@@ -17,4 +19,6 @@ pressure@77 {
 	chip-id = <10>;
 	temp-measurement-period = <100>;
 	default-oversampling = <2>;
+	interrupt-parent = <&gpio0>;
+	interrupts = <25 IRQ_TYPE_EDGE_RISING>;
 };
-- 
1.8.3.2

