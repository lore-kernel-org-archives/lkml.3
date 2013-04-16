Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934781Ab3DPJKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:10:20 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:38976 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933899Ab3DPJKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:10:18 -0400
From: Girish K S <girishks2000@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org
Subject: [PATCH] ahci: sata: add support for exynos5440 sata
Date: Tue, 16 Apr 2013 14:40:04 +0530
Message-Id: <1366103404-14105-1-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the compatible string of the exynos5440 sata controller
compliant with the ahci 1.3 and sata 3.0 specification.

Signed-off-by: Girish K S <ks.giri@samsung.com>
---
 drivers/ata/ahci_platform.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 7a8a284..c06f021 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -327,6 +327,7 @@ static SIMPLE_DEV_PM_OPS(ahci_pm_ops, ahci_suspend, ahci_resume);
 
 static const struct of_device_id ahci_of_match[] = {
 	{ .compatible = "snps,spear-ahci", },
+	{ .compatible = "samsung,exynos5440-ahci", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ahci_of_match);
-- 
1.6.6.rc2

