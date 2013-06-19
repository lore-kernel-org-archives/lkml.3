Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab3FSF7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 01:59:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50755 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444Ab3FSF7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 01:59:07 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <broonie@kernel.org>, <j-keerthy@ti.com>, <ldewangan@nvidia.com>,
        <sameo@linux.intel.com>, <grant.likely@secretlab.ca>,
        <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <gg@slimlogic.co.uk>
Subject: [PATCH v3 4/4] regulator: Palmas: Add TPS659038 support
Date: Wed, 19 Jun 2013 11:27:50 +0530
Message-ID: <1371621470-22279-5-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Keerthy <j-keerthy@ti.com>

Add TPS659038 support.

Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 .../devicetree/bindings/regulator/palmas-pmic.txt  |    1 +
 drivers/regulator/palmas-regulator.c               |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
index d5a3086..5115cd7 100644
--- a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
+++ b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
@@ -7,6 +7,7 @@ Required properties:
   ti,twl6037-pmic
   ti,tps65913-pmic
   ti,tps65914-pmic
+  ti,tps659038-pmic
 and also the generic series names
   ti,palmas-pmic
 - interrupt-parent : The parent interrupt controller which is palmas.
diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 1ae1e83..d0c8785 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -1054,6 +1054,7 @@ static struct of_device_id of_palmas_match_tbl[] = {
 	{ .compatible = "ti,tps65913-pmic", },
 	{ .compatible = "ti,tps65914-pmic", },
 	{ .compatible = "ti,tps80036-pmic", },
+	{ .compatible = "ti,tps659038-pmic", },
 	{ /* end */ }
 };
 
-- 
1.7.5.4

