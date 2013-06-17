Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab3FQMQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:16:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48035 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825Ab3FQMQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:16:56 -0400
From: J Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <broonie@kernel.org>, <j-keerthy@ti.com>, <ldewangan@nvidia.com>,
        <sameo@linux.intel.com>, <grant.likely@secretlab.ca>,
        <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <gg@slimlogic.co.uk>
Subject: [PATCH 4/4] regulator: Palmas: Add TPS659038 support
Date: Mon, 17 Jun 2013 17:39:14 +0530
Message-ID: <1371470954-9124-5-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371470954-9124-1-git-send-email-j-keerthy@ti.com>
References: <1371470954-9124-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

