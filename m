Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaHDTKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:10:32 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:57672 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaHDTKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:10:31 -0400
Date: Mon, 4 Aug 2014 21:10:24 +0200
From: Quentin Lambert <lambert.quentin@gmail.com>
To: Lior Dotan <liodot@gmail.com>, Christopher Harrer <charrer@alacritech.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: slicoss: fix a blank line coding style issue
Message-ID: <20140804191024.GA4721@greed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 2 missing blank lines after declaration.

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/staging/slicoss/slicoss.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index b6227fb..cbeac3e 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -2455,6 +2455,7 @@ static void slic_entry_remove(struct pci_dev *pcidev)
 	adapter->allocated = 0;
 	if (!card->adapters_allocated) {
 		struct sliccard *curr_card = slic_global.slic_card;
+
 		if (curr_card == card) {
 			slic_global.slic_card = card->next;
 		} else {
@@ -2551,6 +2552,7 @@ static int slic_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	case SIOCSLICTRACEDUMP:
 		{
 			u32 value;
+
 			DBG_IOCTL("slic_ioctl  SIOCSLIC_TRACE_DUMP\n");
 
 			if (copy_from_user(data, rq->ifr_data, 28)) {
-- 
1.9.1

