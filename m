Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab3FNFY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:24:58 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:38417 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796Ab3FNFXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:23:50 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <yizhang@marvell.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V2 2/9] mfd: 88pm80x: fix driver name for 88pm800 and 88pm805
Date: Fri, 14 Jun 2013 01:21:46 -0400
Message-ID: <1371187313-5776-3-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
References: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

88pm800 has same driver name as 88pm805. Fix it.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/mfd/88pm800.c |    2 +-
 drivers/mfd/88pm805.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index b2f9f0f..0801049 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -569,7 +569,7 @@ static int pm800_remove(struct i2c_client *client)
 
 static struct i2c_driver pm800_driver = {
 	.driver = {
-		.name = "88PM80X",
+		.name = "88PM800",
 		.owner = THIS_MODULE,
 		.pm = &pm80x_pm_ops,
 		},
diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
index 65d7ac09..d32b544 100644
--- a/drivers/mfd/88pm805.c
+++ b/drivers/mfd/88pm805.c
@@ -276,7 +276,7 @@ static int pm805_remove(struct i2c_client *client)
 
 static struct i2c_driver pm805_driver = {
 	.driver = {
-		.name = "88PM80X",
+		.name = "88PM805",
 		.owner = THIS_MODULE,
 		.pm = &pm80x_pm_ops,
 		},
-- 
1.7.4.1

