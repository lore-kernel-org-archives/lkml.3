Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291AbaFST1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:27:50 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:53986 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757463AbaFST1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:27:48 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2014 15:27:48 EDT
From: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
To: devel@linuxdriverproject.org
Cc: Johannes Stadlinger <Johannes.Stadlinger@fau.de>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Vitaly Osipov <vitaly.osipov@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] wlan-ng/prism2mib:checkpatch: Fix string split
Date: Thu, 19 Jun 2014 21:20:16 +0200
Message-Id: <1403205620-10219-4-git-send-email-Johannes.Stadlinger@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
References: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a warning of checkpatch about string splitting.

Signed-off-by: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
CC: linux-kernel@i4.cs.fau.de
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Vitaly Osipov <vitaly.osipov@gmail.com>
CC: Himangi Saraogi <himangi774@gmail.com>
CC: devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org
---
 drivers/staging/wlan-ng/prism2mib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
index 0fb42df..bdd3b4c 100644
--- a/drivers/staging/wlan-ng/prism2mib.c
+++ b/drivers/staging/wlan-ng/prism2mib.c
@@ -672,8 +672,8 @@ static int prism2mib_fragmentationthreshold(struct mibrec *mib,
 
 	if (!isget)
 		if ((*uint32) % 2) {
-			netdev_warn(wlandev->netdev, "Attempt to set odd number "
-			       "FragmentationThreshold\n");
+			netdev_warn(wlandev->netdev,
+				    "Attempt to set odd number FragmentationThreshold\n");
 			msg->resultcode.data =
 			    P80211ENUM_resultcode_not_supported;
 			return 0;
-- 
1.9.1

