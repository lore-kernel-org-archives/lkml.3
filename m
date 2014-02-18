Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbaBRKOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:14:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336AbaBRKLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:11:09 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>, linux-driver@qlogic.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH net-next 29/35] qlge: Get rid of an redundant assignment
Date: Tue, 18 Feb 2014 11:11:58 +0100
Message-Id: <bffe424063b212553530f64b3282e260e2a37074.1392717503.git.agordeev@redhat.com>
In-Reply-To: <cover.1392717502.git.agordeev@redhat.com>
References: <cover.1392717502.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Shahed Shaikh <shahed.shaikh@qlogic.com>
Cc: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
Cc: Ron Mercer <ron.mercer@qlogic.com>
Cc: linux-driver@qlogic.com
Cc: netdev@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/net/ethernet/qlogic/qlge/qlge_main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
index ce2cfdd..82bace5 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -3346,7 +3346,6 @@ static void ql_enable_msix(struct ql_adapter *qdev)
 			qdev->msi_x_entry = NULL;
 			netif_warn(qdev, ifup, qdev->ndev,
 				   "MSI-X Enable failed, trying MSI.\n");
-			qdev->intr_count = 1;
 			qlge_irq_type = MSI_IRQ;
 		} else if (err == 0) {
 			set_bit(QL_MSIX_ENABLED, &qdev->flags);
-- 
1.7.7.6

