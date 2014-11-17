Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaKQUva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 15:51:30 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:45955 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752549AbaKQUv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 15:51:28 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtYNAFpealRXQyyZ/2dsb2JhbABbgw6BLrhwBQF1mhWBGxcBAQEBAX2EXyOBGjeIRQHCT5AeLIY+imQdhDUFnkyBNI4KhzyBRwE4IIFdPDCCSwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>, dccp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] dccp: kerneldoc warning fixes
Date: Mon, 17 Nov 2014 21:51:21 +0100
Message-Id: <1416257481-5690-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/dccp/feat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dccp/feat.c b/net/dccp/feat.c
index 9733ddb..1704948 100644
--- a/net/dccp/feat.c
+++ b/net/dccp/feat.c
@@ -478,7 +478,7 @@ static struct dccp_feat_entry *
  * @fn_list: feature-negotiation list to update
  * @feat: one of %dccp_feature_numbers
  * @local: whether local (1) or remote (0) @feat_num is meant
- * @needs_mandatory: whether to use Mandatory feature negotiation options
+ * @mandatory: whether to use Mandatory feature negotiation options
  * @fval: pointer to NN/SP value to be inserted (will be copied)
  */
 static int dccp_feat_push_change(struct list_head *fn_list, u8 feat, u8 local,
@@ -1050,7 +1050,7 @@ static u8 dccp_feat_prefer(u8 preferred_value, u8 *array, u8 array_len)
 
 /**
  * dccp_feat_reconcile  -  Reconcile SP preference lists
- *  @fval: SP list to reconcile into
+ *  @fv: SP list to reconcile into
  *  @arr: received SP preference list
  *  @len: length of @arr in bytes
  *  @is_server: whether this side is the server (and @fv is the server's list)
-- 
1.9.3

