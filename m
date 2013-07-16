Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab3GPQl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:41:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33602 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932940Ab3GPQlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:41:52 -0400
From: Nishanth Menon <nm@ti.com>
To: Graeme Gregory <gg@slimlogic.co.uk>, Mark Brown <broonie@kernel.org>
CC: J Keerthy <j-keerthy@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 2/2] regulator: palmas-pmic: doc: remove ti,tstep
Date: Tue, 16 Jul 2013 11:41:10 -0500
Message-ID: <1373992870-20725-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373992870-20725-1-git-send-email-nm@ti.com>
References: <20130716161939.GR22506@sirena.org.uk>
 <1373992870-20725-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 28d1e8cd671a53d6b4f967abbbc2a55f7bd333f6
(regulator: palma: add ramp delay support through regulator constraints)

Removed the regulator's ti,step option from driver without updating the
documentation.

So, remove from documentation and example as well.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 .../devicetree/bindings/regulator/palmas-pmic.txt  |    2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
index 04d67f0..30b0581 100644
--- a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
+++ b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
@@ -33,7 +33,6 @@ Optional nodes:
 	       ti,roof-floor - control voltage selection by pin(boolean)
 	       ti,mode-sleep - mode to adopt in pmic sleep 0 - off, 1 - auto,
 	       2 - eco, 3 - forced pwm
-	       ti,tstep - slope control 0 - Jump, 1 10mV/us, 2 5mV/us, 3 2.5mV/us
 	       ti,smps-range - OTP has the wrong range set for the hardware so override
 	       0 - low range, 1 - high range.
 
@@ -59,7 +58,6 @@ pmic {
 			ti,warm-reset;
 			ti,roof-floor;
 			ti,mode-sleep = <0>;
-			ti,tstep = <0>;
 			ti,smps-range = <1>;
 		};
 
-- 
1.7.9.5

