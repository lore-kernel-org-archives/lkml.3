Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965080AbaFST1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:27:54 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:53998 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757787AbaFST1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:27:48 -0400
From: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
To: devel@linuxdriverproject.org
Cc: Johannes Stadlinger <Johannes.Stadlinger@fau.de>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tugce Sirin <ztugcesirin@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Himangi Saraogi <himangi774@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Vitaly Osipov <vitaly.osipov@gmail.com>,
        Neil Armstrong <superna9999@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] wlan-ng/prism2sta:checkpatch: Insert blank lines
Date: Thu, 19 Jun 2014 21:20:20 +0200
Message-Id: <1403205620-10219-8-git-send-email-Johannes.Stadlinger@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
References: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch inserts blank lines after declarations to avoid checkpatch
warnings.

After our fixes in 'wlan-ng/prism2sta' there is still a checkpatch
warning about prefering 'ether_addr_copy' instead of 'memcpy'
remaining.

Signed-off-by: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
CC: linux-kernel@i4.cs.fau.de
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Tugce Sirin <ztugcesirin@gmail.com>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Himangi Saraogi <himangi774@gmail.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Vitaly Osipov <vitaly.osipov@gmail.com>
CC: Neil Armstrong <superna9999@gmail.com>
CC: devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org
---
 drivers/staging/wlan-ng/prism2sta.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index 9444006..8d4d7ba 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -360,6 +360,7 @@ static int prism2sta_mlmerequest(wlandevice_t *wlandev, struct p80211msg *msg)
 	case DIDmsg_lnxreq_ifstate:
 		{
 			struct p80211msg_lnxreq_ifstate *ifstatemsg;
+
 			pr_debug("Received mlme ifstate request\n");
 			ifstatemsg = (struct p80211msg_lnxreq_ifstate *) msg;
 			result =
@@ -1411,6 +1412,7 @@ void prism2sta_processing_defer(struct work_struct *data)
 		 */
 		if (hw->join_ap && --hw->join_retries > 0) {
 			hfa384x_JoinRequest_data_t joinreq;
+
 			joinreq = hw->joinreq;
 			/* Send the join request */
 			hfa384x_drvr_setconfig(hw,
-- 
1.9.1

