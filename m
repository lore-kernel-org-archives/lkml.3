Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaCQV6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 17:58:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:9536 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaCQV6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 17:58:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,673,1389772800"; 
   d="scan'208";a="493895060"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/5 V2] mei: client.h fix checkpatch errors
Date: Mon, 17 Mar 2014 23:57:23 +0200
Message-Id: <1395093443-11533-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch error
return is not a function, parentheses are not required

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: fix typo in the commit message
 checkpetch -> checkpatch

 drivers/misc/mei/client.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index 8139393..96d5de0 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -68,15 +68,15 @@ int mei_cl_flow_ctrl_reduce(struct mei_cl *cl);
  */
 static inline bool mei_cl_is_connected(struct mei_cl *cl)
 {
-	return (cl->dev &&
+	return  cl->dev &&
 		cl->dev->dev_state == MEI_DEV_ENABLED &&
-		cl->state == MEI_FILE_CONNECTED);
+		cl->state == MEI_FILE_CONNECTED;
 }
 static inline bool mei_cl_is_transitioning(struct mei_cl *cl)
 {
-	return (MEI_FILE_INITIALIZING == cl->state ||
+	return  MEI_FILE_INITIALIZING == cl->state ||
 		MEI_FILE_DISCONNECTED == cl->state ||
-		MEI_FILE_DISCONNECTING == cl->state);
+		MEI_FILE_DISCONNECTING == cl->state;
 }
 
 bool mei_cl_is_other_connecting(struct mei_cl *cl);
-- 
1.8.5.3

