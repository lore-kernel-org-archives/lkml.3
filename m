Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbaGONVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:21:10 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50535 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759161AbaGONVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:21:06 -0400
From: Samarth Parikh <samarthp@ymail.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: added missing semicolon in at25 dts example
Date: Tue, 15 Jul 2014 18:50:49 +0530
Message-Id: <1405430449-21283-1-git-send-email-samarthp@ymail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a missing semicolon ";" in device tree structure
example of "EEPROMs (SPI) compatible with Atmel at25" in
documentation of device tree bindings.

Signed-off-by: Samarth Parikh <samarthp@ymail.com>
---
 Documentation/devicetree/bindings/misc/at25.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/misc/at25.txt b/Documentation/devicetree/bindings/misc/at25.txt
index 1d34471..cf830bd 100644
--- a/Documentation/devicetree/bindings/misc/at25.txt
+++ b/Documentation/devicetree/bindings/misc/at25.txt
@@ -24,7 +24,7 @@ Additional compatible properties are also allowed.
 Example:
 	at25@0 {
 		compatible = "atmel,at25", "st,m95256";
-		reg = <0>
+		reg = <0>;
 		spi-max-frequency = <5000000>;
 		spi-cpha;
 		spi-cpol;
-- 
1.9.1

