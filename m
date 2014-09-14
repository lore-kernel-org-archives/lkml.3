Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaINKjd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 06:39:33 -0400
Received: from sender1.zohomail.com ([74.201.84.155]:30720 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaINKjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 06:39:32 -0400
From: Sorin Facaoaru <work@sorin.cc>
To: liodot@gmail.com, charrer@alacritech.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Sorin Facaoaru <work@sorin.cc>
Subject: [PATCH] Staging: slicoss: fix coding style
Date: Sun, 14 Sep 2014 03:39:29 -0700
Message-Id: <1410691169-10168-1-git-send-email-work@sorin.cc>
X-Mailer: git-send-email 1.9.1
X-ZohoMail: Ss  SS_10 UW UB CHF_INT_SMD_EXT  SGR4_1_26084_0
X-ZohoMail-Owner: <1410691169-10168-1-git-send-email-work@sorin.cc>+zmo_0_<work@sorin.cc>
X-ZohoMail-Sender: 23.243.135.245
X-Zoho-Virus-Status: 2
X-ZohoMailClient: External
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove return statement at the end of void function
- add blank line after declaration

Signed-off-by: Sorin Facaoaru <work@sorin.cc>
---
 drivers/staging/slicoss/slicoss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index f35fa3d..56ca3b6 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -1982,7 +1982,6 @@ static void slic_rcv_handle_error(struct adapter *adapter,
 				adapter->if_events.uflow802++;
 		}
 	}
-	return;
 }
 
 #define TCP_OFFLOAD_FRAME_PUSHFLAG  0x10000000
@@ -2455,6 +2454,7 @@ static void slic_entry_remove(struct pci_dev *pcidev)
 	adapter->allocated = 0;
 	if (!card->adapters_allocated) {
 		struct sliccard *curr_card = slic_global.slic_card;
+
 		if (curr_card == card) {
 			slic_global.slic_card = card->next;
 		} else {
@@ -2551,6 +2551,7 @@ static int slic_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	case SIOCSLICTRACEDUMP:
 		{
 			u32 value;
+
 			DBG_IOCTL("slic_ioctl  SIOCSLIC_TRACE_DUMP\n");
 
 			if (copy_from_user(data, rq->ifr_data, 28)) {
-- 
1.9.1


