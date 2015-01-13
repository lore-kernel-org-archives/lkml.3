Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbbAMSMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:12:53 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36655 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752976AbbAMSMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:12:43 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Bo Shen <voice.shen@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Martin Reimann <martin.reimann@egnite.de>,
        Tim Schendekehl <tim.schendekehl@egnite.de>
Subject: [PATCH v3 6/6] ARM: at91/dt: ethernut5: use at91sam9xe.dtsi
Date: Tue, 13 Jan 2015 19:12:26 +0100
Message-Id: <1421172746-18727-7-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421172746-18727-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421172746-18727-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ethernut5 is actually based on an at91sam9xe, use the correct dts include.

Cc: Martin Reimann <martin.reimann@egnite.de>
Cc: Tim Schendekehl <tim.schendekehl@egnite.de>
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/ethernut5.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ethernut5.dts b/arch/arm/boot/dts/ethernut5.dts
index 8f941c2db7c6..243044343ee8 100644
--- a/arch/arm/boot/dts/ethernut5.dts
+++ b/arch/arm/boot/dts/ethernut5.dts
@@ -6,7 +6,7 @@
  * Licensed under GPLv2.
  */
 /dts-v1/;
-#include "at91sam9260.dtsi"
+#include "at91sam9xe.dtsi"
 
 / {
 	model = "Ethernut 5";
-- 
2.1.0

