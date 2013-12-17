Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab3LQJga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:36:30 -0500
Received: from 18.mo3.mail-out.ovh.net ([87.98.172.162]:48902 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751790Ab3LQJg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:36:27 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Arnd Bergmann <arnd@arndb.de>, Rob Landley <rob@landley.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH] mmc: atmel-mci: document clock properties
Date: Tue, 17 Dec 2013 10:36:17 +0100
Message-Id: <1387272977-4523-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 1956532563910359044
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the clock properties required by the atmel-mci driver.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 .../devicetree/bindings/mmc/atmel-hsmci.txt        |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/atmel-hsmci.txt b/Documentation/devicetree/bindings/mmc/atmel-hsmci.txt
index 0a85c70..07ad020 100644
--- a/Documentation/devicetree/bindings/mmc/atmel-hsmci.txt
+++ b/Documentation/devicetree/bindings/mmc/atmel-hsmci.txt
@@ -13,6 +13,9 @@ Required properties:
 - #address-cells: should be one. The cell is the slot id.
 - #size-cells: should be zero.
 - at least one slot node
+- clock-names: tuple listing input clock names.
+	Required elements: "mci_clk"
+- clocks: phandles to input clocks.
 
 The node contains child nodes for each slot that the platform uses
 
@@ -24,6 +27,8 @@ mmc0: mmc@f0008000 {
 	interrupts = <12 4>;
 	#address-cells = <1>;
 	#size-cells = <0>;
+	clock-names = "mci_clk";
+	clocks = <&mci0_clk>;
 
 	[ child node definitions...]
 };
-- 
1.7.9.5

