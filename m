Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbaG3VbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:31:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaG3VbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:31:07 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3] Documentation: devicetree: Fix tps65090 typos in example
Date: Wed, 30 Jul 2014 23:29:27 +0200
Message-Id: <1406755767-5910-1-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specification and existing device trees use vsys-l{1,2}-supply,
not vsys_l{1,2}-supply. Fix the example to match the specification.

Reviewed-by: Doug Anderson <dianders@chromium.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Fixes: 21d2202158e9 ("mfd: tps65090: add DT support for tps65090")
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v2 -> v3:
 * Added Fixes header
 * + regulator and mfd maintainers
 
 v1 -> v2:
 * More verbose commit message (requested by Mark Rutland)
 
 Documentation/devicetree/bindings/regulator/tps65090.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/tps65090.txt b/Documentation/devicetree/bindings/regulator/tps65090.txt
index 340980239ea9..ca69f5e3040c 100644
--- a/Documentation/devicetree/bindings/regulator/tps65090.txt
+++ b/Documentation/devicetree/bindings/regulator/tps65090.txt
@@ -45,8 +45,8 @@ Example:
 		infet5-supply = <&some_reg>;
 		infet6-supply = <&some_reg>;
 		infet7-supply = <&some_reg>;
-		vsys_l1-supply = <&some_reg>;
-		vsys_l2-supply = <&some_reg>;
+		vsys-l1-supply = <&some_reg>;
+		vsys-l2-supply = <&some_reg>;
 
 		regulators {
 			dcdc1 {
-- 
1.9.3

