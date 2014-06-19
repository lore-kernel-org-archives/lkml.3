Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934444AbaFST2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:28:45 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:54003 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934265AbaFST1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:27:50 -0400
From: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
To: devel@linuxdriverproject.org
Cc: Johannes Stadlinger <Johannes.Stadlinger@fau.de>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tugce Sirin <ztugcesirin@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Vitaly Osipov <vitaly.osipov@gmail.com>,
        Neil Armstrong <superna9999@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] wlan-ng/prism2sta:checkpatch: Fix string split
Date: Thu, 19 Jun 2014 21:20:19 +0200
Message-Id: <1403205620-10219-7-git-send-email-Johannes.Stadlinger@fau.de>
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
CC: Tugce Sirin <ztugcesirin@gmail.com>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Vitaly Osipov <vitaly.osipov@gmail.com>
CC: Neil Armstrong <superna9999@gmail.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org
---
 drivers/staging/wlan-ng/prism2sta.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index a449fdf..9444006 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -468,8 +468,7 @@ u32 prism2sta_ifstate(wlandevice_t *wlandev, u32 ifstate)
 			break;
 		case WLAN_MSD_RUNNING:
 			netdev_warn(wlandev->netdev,
-			       "Cannot enter fwload state from enable state,"
-			       "you must disable first.\n");
+				    "Cannot enter fwload state from enable state, you must disable first.\n");
 			result = P80211ENUM_resultcode_invalid_parameters;
 			break;
 		case WLAN_MSD_HWFAIL:
-- 
1.9.1

