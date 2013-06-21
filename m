Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161277Ab3FUHco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:32:44 -0400
Received: from 17.mo3.mail-out.ovh.net ([87.98.178.58]:34610 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933901Ab3FUHcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:32:43 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yang Wenyou <Wenyou.Yang@atmel.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: [PATCH v2 4/4] ARM: at91/dt: add watchdog properties to kizbox board
Date: Fri, 21 Jun 2013 09:32:29 +0200
Message-Id: <1371799949-3887-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371799176-3408-1-git-send-email-b.brezillon@overkiz.com>
References: <1371799176-3408-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 123567514932115640
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrjeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrjeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add watchdog specific config for kizbox board.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/kizbox.dts |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/kizbox.dts b/arch/arm/boot/dts/kizbox.dts
index 02df191..928f6ee 100644
--- a/arch/arm/boot/dts/kizbox.dts
+++ b/arch/arm/boot/dts/kizbox.dts
@@ -53,6 +53,12 @@
 				status = "okay";
 			};
 
+			watchdog@fffffd40 {
+				timeout-sec = <15>;
+				atmel,max-heartbeat-sec = <16>;
+				atmel,min-heartbeat-sec = <0>;
+				status = "okay";
+			};
 		};
 
 		nand0: nand@40000000 {
-- 
1.7.9.5

