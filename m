Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab3LBUOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:14:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3LBTRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alistair Popple <alistair@popple.id.au>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.12 056/212] ahci: add support for IBM Akebono platform device
Date: Mon,  2 Dec 2013 11:14:07 -0800
Message-Id: <20131202191254.396768627@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alistair Popple <alistair@popple.id.au>

commit 2435dcb98cfe13c246aa27df393e22bc24bbcd20 upstream.

The new IBM Akebono board has a PPC476GTR SoC with an AHCI compliant
SATA controller. This patch adds a compatible property for the new SoC
to the AHCI platform driver.

Signed-off-by: Alistair Popple <alistair@popple.id.au>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci_platform.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -328,6 +328,7 @@ static SIMPLE_DEV_PM_OPS(ahci_pm_ops, ah
 static const struct of_device_id ahci_of_match[] = {
 	{ .compatible = "snps,spear-ahci", },
 	{ .compatible = "snps,exynos5440-ahci", },
+	{ .compatible = "ibm,476gtr-ahci", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ahci_of_match);


