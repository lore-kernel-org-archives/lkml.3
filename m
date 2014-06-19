Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934375AbaFST1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:27:51 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:53991 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757681AbaFST1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:27:48 -0400
From: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
To: devel@linuxdriverproject.org
Cc: Johannes Stadlinger <Johannes.Stadlinger@fau.de>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Himangi Saraogi <himangi774@gmail.com>,
        Vitaly Osipov <vitaly.osipov@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] wlan-ng/prism2mgmt:checkpatch: Insert blank line
Date: Thu, 19 Jun 2014 21:20:15 +0200
Message-Id: <1403205620-10219-3-git-send-email-Johannes.Stadlinger@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
References: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch inserts a blank line after a declaration to avoid checkpatch
warning.

Signed-off-by: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
CC: linux-kernel@i4.cs.fau.de
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Himangi Saraogi <himangi774@gmail.com>
CC: Vitaly Osipov <vitaly.osipov@gmail.com>
CC: devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org
---
 drivers/staging/wlan-ng/prism2mgmt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
index f90f7da..e6a82d3 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -190,6 +190,7 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 	word = 0;
 	for (i = 0; i < msg->channellist.data.len; i++) {
 		u8 channel = msg->channellist.data.data[i];
+
 		if (channel > 14)
 			continue;
 		/* channel 1 is BIT 0 ... channel 14 is BIT 13 */
-- 
1.9.1

