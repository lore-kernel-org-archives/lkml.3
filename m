Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549Ab3EWQB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:01:26 -0400
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:47844 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360Ab3EWQBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:01:25 -0400
X-Greylist: delayed 24192 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2013 12:01:25 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH] ARM: at91/dt: fix macb pinctrl_macb_rmii_mii_alt definition
Date: Thu, 23 May 2013 18:01:21 +0200
Message-Id: <1369324881-31428-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 4466444930740302956
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PA24 pin is wrongly assigned to peripheral B.
In the current config there is 2 ETX3 pins (PA11 and PA24) and
no ETXER pin (PA22).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91sam9260.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index 70b5ccb..84c4bef 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -264,7 +264,7 @@
 						atmel,pins =
 							<0 10 0x2 0x0	/* PA10 periph B */
 							 0 11 0x2 0x0	/* PA11 periph B */
-							 0 24 0x2 0x0	/* PA24 periph B */
+							 0 22 0x2 0x0	/* PA22 periph B */
 							 0 25 0x2 0x0	/* PA25 periph B */
 							 0 26 0x2 0x0	/* PA26 periph B */
 							 0 27 0x2 0x0	/* PA27 periph B */
-- 
1.7.9.5

