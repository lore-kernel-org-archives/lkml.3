Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbaDNSul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:50:41 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:42451 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbaDNSuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:50:37 -0400
From: Matt Porter <mporter@linaro.org>
To: Devicetree List <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Tim Kryger <tim.kryger@linaro.org>, Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 1/4] mfd: bcm590xx: update binding with additional BCM59056 regulators
Date: Mon, 14 Apr 2014 14:50:25 -0400
Message-Id: <1397501428-8857-2-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1397501428-8857-1-git-send-email-mporter@linaro.org>
References: <1397501428-8857-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BCM59056 supports GPLDO1-6 and VBUS regulators in a secondary
I2C slave address space. Add these regulators to the list of valid
regulator node names for BCM59056.

Signed-off-by: Matt Porter <mporter@linaro.org>
---
 Documentation/devicetree/bindings/mfd/bcm590xx.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mfd/bcm590xx.txt b/Documentation/devicetree/bindings/mfd/bcm590xx.txt
index 1fe30e2..be51a15 100644
--- a/Documentation/devicetree/bindings/mfd/bcm590xx.txt
+++ b/Documentation/devicetree/bindings/mfd/bcm590xx.txt
@@ -19,7 +19,9 @@ Optional child nodes:
   The valid regulator node names for BCM59056 are:
   	rfldo, camldo1, camldo2, simldo1, simldo2, sdldo, sdxldo,
 	mmcldo1, mmcldo2, audldo, micldo, usbldo, vibldo,
-	csr, iosr1, iosr2, msr, sdsr1, sdsr2, vsr
+	csr, iosr1, iosr2, msr, sdsr1, sdsr2, vsr,
+	gpldo1, gpldo2, gpldo3, gpldo4, gpldo5, gpldo6,
+	vbus
 
 Example:
 	pmu: bcm59056@8 {
-- 
1.8.4

