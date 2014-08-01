Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaHANux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:50:53 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44470 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaHANuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:50:52 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] of: Add vendor prefix for Sharp Microelectronics
Date: Fri,  1 Aug 2014 15:50:44 +0200
Message-Id: <1406901044-32654-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Use "sharp" as the vendor prefix for Sharp Microelectronics in device
tree compatible strings.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 81cc5bb8c821..b833b10da988 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -121,6 +121,7 @@ samsung	Samsung Semiconductor
 sbs	Smart Battery System
 schindler	Schindler
 seagate	Seagate Technology PLC
+sharp	Sharp Microelectronics
 sil	Silicon Image
 silabs	Silicon Laboratories
 simtek
-- 
2.0.3

