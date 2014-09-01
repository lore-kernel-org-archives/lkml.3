Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaIAXz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 19:55:26 -0400
Received: from 7.mo6.mail-out.ovh.net ([46.105.59.196]:50925 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752162AbaIAXzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 19:55:25 -0400
X-Greylist: delayed 4198 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Sep 2014 19:55:24 EDT
From: =?UTF-8?q?Ga=C3=ABl=20PORTAY?= <gael.portay@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?utf-8?q?Ga=C3=ABl=20PORTAY?= <gael.portay@gmail.com>
Subject: [PATCH] ARM: at91/dt: sam9g20: set at91sam9g20 pllb driver
Date: Mon,  1 Sep 2014 23:29:46 +0200
Message-Id: <1409606986-32455-1-git-send-email-gael.portay@gmail.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 16525395882887314796
X-Ovh-Remote: 109.190.157.19 (19-157-190-109.dsl.ovh.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedruddtucdltddurdefjeefrddttddmucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedruddtucdltddurdefjeefrddttddmucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The at91sam9g20 SOC uses its own pllb implementation which is different
from the one inherited from at91sam9260 SOC.

Signed-off-by: Gaël PORTAY <gael.portay@gmail.com>
---
 arch/arm/boot/dts/at91sam9g20.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/at91sam9g20.dtsi b/arch/arm/boot/dts/at91sam9g20.dtsi
index 31f7652..4e0abbd 100644
--- a/arch/arm/boot/dts/at91sam9g20.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20.dtsi
@@ -40,6 +40,7 @@
 				};
 
 				pllb: pllbck {
+					compatible = "atmel,at91sam9g20-clk-pllb";
 					atmel,clk-input-range = <2000000 32000000>;
 					atmel,pll-clk-output-ranges = <30000000 100000000 0 0>;
 				};
-- 
1.9.3

