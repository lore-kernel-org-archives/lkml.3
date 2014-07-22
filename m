Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaGVOSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:18:53 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37934 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaGVOSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:18:52 -0400
From: Kiran Padwal <kiran.padwal21@gmail.com>
To: tj@kernel.org
Cc: lee.jones@linaro.org, kiran.padwal21@gmail.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ahci: st: Make of_device_id array const
Date: Tue, 22 Jul 2014 19:45:43 +0530
Message-Id: <1406038543-26545-1-git-send-email-kiran.padwal21@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const.

Signed-off-by: Kiran Padwal <kiran.padwal21@gmail.com>
---
 drivers/ata/ahci_st.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/ahci_st.c b/drivers/ata/ahci_st.c
index 2595598..29821b9 100644
--- a/drivers/ata/ahci_st.c
+++ b/drivers/ata/ahci_st.c
@@ -221,7 +221,7 @@ static int st_ahci_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(st_ahci_pm_ops, st_ahci_suspend, st_ahci_resume);
 
-static struct of_device_id st_ahci_match[] = {
+static const struct of_device_id st_ahci_match[] = {
 	{ .compatible = "st,ahci", },
 	{},
 };
-- 
1.7.9.5

