Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaENTPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:15:30 -0400
Received: from smtprelay0011.hostedemail.com ([216.40.44.11]:48033 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752463AbaENTPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:15:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3351:3876:3877:4321:5007:6114:6261:6642:10004:10026:10848:11026:11657:11658:11914:12043:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: burst50_85c01ed208057
X-Filterd-Recvd-Size: 1565
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ti: Remove trailing semicolon from do {...} while (0) macro
Date: Wed, 14 May 2014 12:15:13 -0700
Message-Id: <de49b7a2734337157b439afe30c39e9b40bc6e0f.1400094804.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1400094804.git.joe@perches.com>
References: <cover.1400094804.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These should not have trailing semicolons so remove them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/ti/cpsw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index e3d8710..da57d33 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -143,13 +143,13 @@ do {								\
 		u32 i;		\
 		for (i = 0; i < priv->num_irqs; i++) \
 			enable_irq(priv->irqs_table[i]); \
-	} while (0);
+	} while (0)
 #define cpsw_disable_irq(priv)	\
 	do {			\
 		u32 i;		\
 		for (i = 0; i < priv->num_irqs; i++) \
 			disable_irq_nosync(priv->irqs_table[i]); \
-	} while (0);
+	} while (0)
 
 #define cpsw_slave_index(priv)				\
 		((priv->data.dual_emac) ? priv->emac_port :	\
-- 
1.8.1.2.459.gbcd45b4.dirty

