Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaETJEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:04:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58336 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750879AbaETJEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:04:41 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/7] ata: ahci_platform: add the Marvell Berlin AHCI compatible
Date: Tue, 20 May 2014 11:04:32 +0200
Message-Id: <1400576675-25265-5-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400576675-25265-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1400576675-25265-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Marvell Berlin AHCI has all his specific in the PHY driver. It then
only need to use the libahci functions to work properly.

Add its compatible into the libahci_platform driver.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 drivers/ata/ahci_platform.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index ef67e79944f9..bc050aabf206 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -76,6 +76,7 @@ static const struct of_device_id ahci_of_match[] = {
 	{ .compatible = "snps,exynos5440-ahci", },
 	{ .compatible = "ibm,476gtr-ahci", },
 	{ .compatible = "snps,dwc-ahci", },
+	{ .compatible = "marvell,berlin-ahci", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ahci_of_match);
-- 
1.9.1

