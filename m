Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487Ab3GPQly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:41:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33601 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821Ab3GPQlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:41:51 -0400
From: Nishanth Menon <nm@ti.com>
To: Graeme Gregory <gg@slimlogic.co.uk>, Mark Brown <broonie@kernel.org>
CC: J Keerthy <j-keerthy@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 1/2] regulator: palmas-pmic: doc: fix typo for sleep-mode
Date: Tue, 16 Jul 2013 11:41:09 -0500
Message-ID: <1373992870-20725-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373992870-20725-1-git-send-email-nm@ti.com>
References: <20130716161939.GR22506@sirena.org.uk>
 <1373992870-20725-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 3c870e3f9d9d98f1ab98614b3b1fd5c79287d361
(regulator: palmas: Change the DT node property names to follow the convention)

Missed updating mode-sleep from sleep-mode. Fix the same.

Documentation example seems proper for this property.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 .../devicetree/bindings/regulator/palmas-pmic.txt  |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
index d5a3086..04d67f0 100644
--- a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
+++ b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
@@ -31,7 +31,7 @@ Optional nodes:
 	       Optional sub-node properties:
 	       ti,warm-reset - maintain voltage during warm reset(boolean)
 	       ti,roof-floor - control voltage selection by pin(boolean)
-	       ti,sleep-mode - mode to adopt in pmic sleep 0 - off, 1 - auto,
+	       ti,mode-sleep - mode to adopt in pmic sleep 0 - off, 1 - auto,
 	       2 - eco, 3 - forced pwm
 	       ti,tstep - slope control 0 - Jump, 1 10mV/us, 2 5mV/us, 3 2.5mV/us
 	       ti,smps-range - OTP has the wrong range set for the hardware so override
-- 
1.7.9.5

