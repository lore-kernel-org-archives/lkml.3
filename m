Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965116Ab3DJROj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:14:39 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3944 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965035Ab3DJROi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:14:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 10 Apr 2013 10:14:37 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH] mfd: tps65090: Add compatible string for charger subnode
Date: Wed, 10 Apr 2013 13:14:55 -0400
Message-ID: <1365614095-5846-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the of_compatible value for the tps65090 charger
subnode used when loading the driver to find its properties
and of_node.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/mfd/tps65090.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index 88846ae..fbd6ee6 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -72,6 +72,7 @@ static struct mfd_cell tps65090s[] = {
 		.name = "tps65090-charger",
 		.num_resources = ARRAY_SIZE(charger_resources),
 		.resources = &charger_resources[0],
+		.of_compatible = "ti,tps65090-charger",
 	},
 };
 
-- 
1.7.9.5

