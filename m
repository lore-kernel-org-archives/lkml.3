Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965367Ab3FTLDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:03:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39984 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965291Ab3FTLDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:03:44 -0400
From: J Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>, <sameo@linux.intel.com>
CC: <broonie@kernel.org>, <j-keerthy@ti.com>, <ldewangan@nvidia.com>,
        <grant.likely@secretlab.ca>, <swarren@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <gg@slimlogic.co.uk>
Subject: [PATCH 4/4] regulator: Palmas: Add TPS659038 support
Date: Thu, 20 Jun 2013 16:32:15 +0530
Message-ID: <1371726135-9891-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add TPS659038 support.

Signed-off-by: J Keerthy <j-keerthy@ti.com>
Acked-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/palmas-regulator.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

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

