Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaDYBvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:51:16 -0400
Received: from smtprelay0051.hostedemail.com ([216.40.44.51]:59347 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750820AbaDYBvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:51:13 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1534:1539:1566:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3865:3867:4321:4385:5007:6261:9040:10004:10026:10848:11026:11657:11658:11914:12043:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: trade05_61ac9bc31e208
X-Filterd-Recvd-Size: 1584
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>, linux-driver@qlogic.com,
        netdev@vger.kernel.org
Subject: [PATCH 1/5] qlge: Convert /n to \n
Date: Thu, 24 Apr 2014 18:50:59 -0700
Message-Id: <0cfcf37f20b78a2bc3cde9f56aa27ca53a802184.1398390579.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1398390579.git.joe@perches.com>
References: <cover.1398390579.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a newline character appropriately.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/qlogic/qlge/qlge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
index 0a1d76a..6e36fe1 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -3595,7 +3595,7 @@ static int ql_request_irq(struct ql_adapter *qdev)
 	}
 	return status;
 err_irq:
-	netif_err(qdev, ifup, qdev->ndev, "Failed to get the interrupts!!!/n");
+	netif_err(qdev, ifup, qdev->ndev, "Failed to get the interrupts!!!\n");
 	ql_free_irq(qdev);
 	return status;
 }
-- 
1.8.1.2.459.gbcd45b4.dirty

