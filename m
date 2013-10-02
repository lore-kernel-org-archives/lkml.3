Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab3JBRsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:48:47 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:26950 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754836Ab3JBRsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:48:43 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, Andy King <acking@vmware.com>,
        Jon Mason <jon.mason@intel.com>,
        Matt Porter <mporter@kernel.crashing.org>, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, x86@kernel.org, linux-ide@vger.kernel.org,
        iss_storagedev@hp.com, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-driver@qlogic.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org
Subject: [PATCH RFC 65/77] qlge: Remove a redundant assignment
Date: Wed,  2 Oct 2013 12:49:21 +0200
Message-Id: <2d9997f8ec6637dd41c10363785754698f6aa173.1380703263.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1380703262.git.agordeev@redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/ethernet/qlogic/qlge/qlge_main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
index 2553cf4..ac54cb0 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -3287,7 +3287,6 @@ static void ql_enable_msix(struct ql_adapter *qdev)
 			qdev->msi_x_entry = NULL;
 			netif_warn(qdev, ifup, qdev->ndev,
 				   "MSI-X Enable failed, trying MSI.\n");
-			qdev->intr_count = 1;
 			qlge_irq_type = MSI_IRQ;
 		} else if (err == 0) {
 			set_bit(QL_MSIX_ENABLED, &qdev->flags);
-- 
1.7.7.6

