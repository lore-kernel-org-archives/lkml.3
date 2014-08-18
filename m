Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaHRIzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:55:08 -0400
Received: from p50936449.dip0.t-ipconnect.de ([80.147.100.73]:30499 "EHLO
	dhcp-27-160.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751269AbaHRIzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:55:05 -0400
X-Greylist: delayed 10355 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2014 04:55:02 EDT
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v3 12/13] pmcraid: Get rid of a redundant assignment
Date: Mon, 18 Aug 2014 08:01:52 +0200
Message-Id: <8058dca6525ca29845019ea9922c37f3416c0c7a.1408335523.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1408335523.git.agordeev@redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/pmcraid.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 6f3275d..6e575ed 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4746,7 +4746,6 @@ pmcraid_isr_legacy:
 	pinstance->hrrq_vector[0].drv_inst = pinstance;
 	pinstance->hrrq_vector[0].vector = pdev->irq;
 	pinstance->num_hrrq = 1;
-	rc = 0;
 
 	rc = request_irq(pdev->irq, pmcraid_isr, IRQF_SHARED,
 			 PMCRAID_DRIVER_NAME, &pinstance->hrrq_vector[0]);
-- 
1.9.3

