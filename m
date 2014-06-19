Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934425AbaFST2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:28:43 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:54005 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934276AbaFST1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:27:50 -0400
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
Subject: [PATCH 5/8] wlan-ng/prism2mib:checkpatch: Insert blank lines
Date: Thu, 19 Jun 2014 21:20:17 +0200
Message-Id: <1403205620-10219-5-git-send-email-Johannes.Stadlinger@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
References: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch inserts blank lines after declarations to avoid checkpatch
warning.

After our fixes in 'wlan-ng/prism2mib.c' there are still two checkpatch
warnings about lines over 80 characters remaining.

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
 drivers/staging/wlan-ng/prism2mib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
index bdd3b4c..3ea24d6 100644
--- a/drivers/staging/wlan-ng/prism2mib.c
+++ b/drivers/staging/wlan-ng/prism2mib.c
@@ -85,7 +85,8 @@ struct mibrec {
 	u16 parm1;
 	u16 parm2;
 	u16 parm3;
-	int (*func) (struct mibrec *mib,
+
+	int (*func)(struct mibrec *mib,
 		     int isget,
 		     wlandevice_t *wlandev,
 		     hfa384x_t *hw,
@@ -722,6 +723,7 @@ static int prism2mib_priv(struct mibrec *mib,
 	switch (mib->did) {
 	case DIDmib_lnx_lnxConfigTable_lnxRSNAIE:{
 			hfa384x_WPAData_t wpa;
+
 			if (isget) {
 				hfa384x_drvr_getconfig(hw,
 						       HFA384x_RID_CNFWPADATA,
-- 
1.9.1

