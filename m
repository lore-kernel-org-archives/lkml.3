Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbaDNQ1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:27:17 -0400
Received: from ns3094689.ip-91-121-202.eu ([91.121.202.112]:50986 "EHLO
	ns3094689.ip-91-121-202.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755804AbaDNQ1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:27:15 -0400
From: Denis Pithon <denis.pithon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: bergwolf@gmail.com, andreas.dilger@intel.com, standby24x7@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/lustre: fix sparse warning
Date: Mon, 14 Apr 2014 18:25:30 +0200
Message-Id: <1397492730-19648-1-git-send-email-denis.pithon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse complaint: "Using plain integer as NULL pointer"

Signed-off-by: Denis Pithon <denis.pithon@gmail.com>
---
 drivers/staging/lustre/lustre/ptlrpc/sec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec.c b/drivers/staging/lustre/lustre/ptlrpc/sec.c
index d8041805..b0a1c5a 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec.c
@@ -354,7 +354,7 @@ static int import_sec_check_expire(struct obd_import *imp)
 		return 0;
 
 	CDEBUG(D_SEC, "found delayed sec adapt expired, do it now\n");
-	return sptlrpc_import_sec_adapt(imp, NULL, 0);
+	return sptlrpc_import_sec_adapt(imp, NULL, NULL);
 }
 
 static int import_sec_validate_get(struct obd_import *imp,
-- 
1.9.0

