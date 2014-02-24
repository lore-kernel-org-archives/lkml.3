Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaBXIHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:07:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbaBXIBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:01:18 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v2 19/23] pmcraid: Get rid of a redundant assignment
Date: Mon, 24 Feb 2014 09:02:19 +0100
Message-Id: <803a115f59bf558c891ed05277384f61506c89d5.1393191330.git.agordeev@redhat.com>
In-Reply-To: <cover.1393191330.git.agordeev@redhat.com>
References: <cover.1393191330.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/pmcraid.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index be8ce54..c06af7f 100644
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
1.7.7.6

