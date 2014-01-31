Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbaAaPHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:07:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722AbaAaPHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:07:53 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>, linux-driver@qlogic.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 29/34] qlge: Get rid of an redundant assignment
Date: Fri, 31 Jan 2014 16:08:48 +0100
Message-Id: <2df50eba05a3f7cb0532d2ebd151de24a4853d68.1391172839.git.agordeev@redhat.com>
In-Reply-To: <cover.1391172839.git.agordeev@redhat.com>
References: <cover.1391172839.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
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

