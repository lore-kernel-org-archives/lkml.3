Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbaDBAnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:43:31 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58926 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320AbaDBAnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:43:12 -0400
Date: Wed, 2 Apr 2014 10:43:05 +1000
From: Toby Smith <toby@tismith.id.au>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: netlogic: fix missing a blank line after
 declarations
Message-ID: <20140402004305.GA27948@toby0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl issues with missing blank line after declarations.

Signed-off-by: Toby Smith <toby@tismith.id.au>
---
 drivers/staging/netlogic/xlr_net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/netlogic/xlr_net.c b/drivers/staging/netlogic/xlr_net.c
index c83e337..75d7c63 100644
--- a/drivers/staging/netlogic/xlr_net.c
+++ b/drivers/staging/netlogic/xlr_net.c
@@ -268,6 +268,7 @@ static void xlr_make_tx_desc(struct nlm_fmn_msg *msg, unsigned long addr,
 	unsigned long physkb = virt_to_phys(skb);
 	int cpu_core = nlm_core_id();
 	int fr_stn_id = cpu_core * 8 + XLR_FB_STN;	/* FB to 6th bucket */
+
 	msg->msg0 = (((u64)1 << 63)	|	/* End of packet descriptor */
 		((u64)127 << 54)	|	/* No Free back */
 		(u64)skb->len << 40	|	/* Length of data */
-- 
1.8.3.2

