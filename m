Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaHKS3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:29:20 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48373 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbaHKS3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:29:18 -0400
From: Srikrishan Malik <srikrishanmalik@gmail.com>
To: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Srikrishan Malik <srikrishanmalik@gmail.com>
Subject: [PATCH v2 12/13] staging: lustre: remove parentheses usage with return
Date: Mon, 11 Aug 2014 23:57:38 +0530
Message-Id: <1407781659-728-12-git-send-email-srikrishanmalik@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407781659-728-1-git-send-email-srikrishanmalik@gmail.com>
References: <1407781659-728-1-git-send-email-srikrishanmalik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch error:

ERROR: return is not a function, parentheses are not required

Signed-off-by: Srikrishan Malik <srikrishanmalik@gmail.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 5a9a8526dea1..4ab75c24bd17 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -2588,7 +2588,7 @@ static int mdc_process_config(struct obd_device *obd, obd_count len, void *buf)
 			rc = 0;
 		break;
 	}
-	return(rc);
+	return rc;
 }
 
 
-- 
1.9.3

