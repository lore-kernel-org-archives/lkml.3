Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaGTOa6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:30:58 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:62322 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753554AbaGTO2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:28:45 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIKAA/Ry1NXQ0aj/2dsb2JhbABZgw6BKa4jAQEBAQEFAW6dSAGBBBd2hAQBBVYjEFE5HhmIRgGwM5BxF4V7iVAHFoQwBZsllC+DRjsv
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Rasesh Mody <rmody@brocade.com>, netdev@vger.kernel.org
Subject: [PATCH 23/30] bna: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:27:48 +0200
Message-Id: <1405866475-24754-4-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405866475-24754-1-git-send-email-fabf@skynet.be>
References: <1405866475-24754-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/brocade/bna/cna_fwimg.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/cna_fwimg.c b/drivers/net/ethernet/brocade/bna/cna_fwimg.c
index 6a68e8d..6f72771 100644
--- a/drivers/net/ethernet/brocade/bna/cna_fwimg.c
+++ b/drivers/net/ethernet/brocade/bna/cna_fwimg.c
@@ -68,10 +68,8 @@ bfa_cb_image_get_chunk(enum bfi_asic_gen asic_gen, u32 off)
 	switch (asic_gen) {
 	case BFI_ASIC_GEN_CT:
 		return (bfi_image_ct_cna + off);
-		break;
 	case BFI_ASIC_GEN_CT2:
 		return (bfi_image_ct2_cna + off);
-		break;
 	default:
 		return NULL;
 	}
@@ -83,10 +81,8 @@ bfa_cb_image_get_size(enum bfi_asic_gen asic_gen)
 	switch (asic_gen) {
 	case BFI_ASIC_GEN_CT:
 		return bfi_image_ct_cna_size;
-		break;
 	case BFI_ASIC_GEN_CT2:
 		return bfi_image_ct2_cna_size;
-		break;
 	default:
 		return 0;
 	}
-- 
1.9.1

