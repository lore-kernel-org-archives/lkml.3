Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbaJUQSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:18:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36220 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656AbaJUQSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:18:42 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        "Franklin Cooper Jr." <fcooper@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH] ARM: dts: DRA7: Add aliases for all serial ports
Date: Tue, 21 Oct 2014 11:18:15 -0500
Message-ID: <1413908295-699-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add serial port aliases for consoles > 6.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 9cc9843..208dd83 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -34,6 +34,10 @@
 		serial3 = &uart4;
 		serial4 = &uart5;
 		serial5 = &uart6;
+		serial6 = &uart7;
+		serial7 = &uart8;
+		serial8 = &uart9;
+		serial9 = &uart10;
 	};
 
 	timer {
-- 
1.7.9.5

