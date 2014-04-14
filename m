Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbaDNIEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:04:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414AbaDNIEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:04:38 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v2 RESEND 19/23] pmcraid: Get rid of a redundant assignment
Date: Mon, 14 Apr 2014 10:05:43 +0200
Message-Id: <4000044a6582a5e60a3ed61aae60186d70eabc94.1397461652.git.agordeev@redhat.com>
In-Reply-To: <cover.1397461652.git.agordeev@redhat.com>
References: <cover.1397461652.git.agordeev@redhat.com>
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

