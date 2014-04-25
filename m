Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbaDYBvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:51:23 -0400
Received: from smtprelay0145.hostedemail.com ([216.40.44.145]:44299 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750820AbaDYBvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:51:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3351:3866:4321:4605:5007:6114:6119:6261:6642:8603:10004:10026:10848:11026:11232:11473:11657:11658:11914:12043:12296:12517:12519:12555:12699:12737:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: seed97_6233acf58350f
X-Filterd-Recvd-Size: 2090
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/5] iwlegacy: Convert /n to \n
Date: Thu, 24 Apr 2014 18:51:00 -0700
Message-Id: <80376e433ad62c5792b72ef5a338df1771bc9975.1398390579.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1398390579.git.joe@perches.com>
References: <cover.1398390579.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a newline character appropriately.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/iwlegacy/3945.c     | 2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index d37a6fd..b598e28 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -573,7 +573,7 @@ il3945_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 		rx_status.flag |= RX_FLAG_SHORTPRE;
 
 	if ((unlikely(rx_stats->phy_count > 20))) {
-		D_DROP("dsp size out of range [0,20]: %d/n",
+		D_DROP("dsp size out of range [0,20]: %d\n",
 		       rx_stats->phy_count);
 		return;
 	}
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 888ad5c..c159c05 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -670,7 +670,7 @@ il4965_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 	}
 
 	if ((unlikely(phy_res->cfg_phy_cnt > 20))) {
-		D_DROP("dsp size out of range [0,20]: %d/n",
+		D_DROP("dsp size out of range [0,20]: %d\n",
 		       phy_res->cfg_phy_cnt);
 		return;
 	}
-- 
1.8.1.2.459.gbcd45b4.dirty

