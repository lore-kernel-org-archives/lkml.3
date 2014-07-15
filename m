Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbaGOQst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:48:49 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43802 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbaGOQsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:48:35 -0400
From: Adithya Krishnamurthy <linux.challenge1@gmail.com>
To: omar.ramirez@copitl.com, gregkh@linuxfoundation.org,
        rashika.kheria@gmail.com, freemangordon@abv.bg,
        dan.carpenter@oracle.com, ody.guru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Adithya Krishnamurthy <linux.challenge1@gmail.com>
Subject: [PATCH] Staging:tidspbridge Fix minor checkpatch.pl warining Unnecessary parentheses
Date: Tue, 15 Jul 2014 22:18:20 +0530
Message-Id: <1405442900-6977-3-git-send-email-linux.challenge1@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405442900-6977-2-git-send-email-linux.challenge1@gmail.com>
References: <y>
 <1405442900-6977-1-git-send-email-linux.challenge1@gmail.com>
 <1405442900-6977-2-git-send-email-linux.challenge1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adithya Krishnamurthy <linux.challenge1@gmail.com>

Fixed checkpatch "WARNING: Unnecessary parentheses"

Signed-off-by: Adithya Krishnamurthy <linux.challenge1@gmail.com>
---
 drivers/staging/tidspbridge/dynload/cload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/tidspbridge/dynload/cload.c b/drivers/staging/tidspbridge/dynload/cload.c
index 83f2106..b306349 100644
--- a/drivers/staging/tidspbridge/dynload/cload.c
+++ b/drivers/staging/tidspbridge/dynload/cload.c
@@ -376,7 +376,7 @@ void dload_headers(struct dload_state *dlthis)
 		return;
 	}
 	/* Check for valid file format */
-	if ((dlthis->dfile_hdr.df_doff_version != DOFF0)) {
+	if (dlthis->dfile_hdr.df_doff_version != DOFF0) {
 		dload_error(dlthis, "Bad DOFF version 0x%x",
 			    dlthis->dfile_hdr.df_doff_version);
 		return;
-- 
1.7.9.5

