Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaERRUS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 13:20:18 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48602 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaERRTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 13:19:22 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: gregkh@linuxfoundation.org, andreas.dilger@intel.com,
        oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 2/5] staging: lustre: lnet: socklnd: Clean up memset(...)
Date: Sun, 18 May 2014 18:19:14 +0100
Message-Id: <1400433557-24985-3-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400433557-24985-1-git-send-email-massa.nomura@gmail.com>
References: <1400433557-24985-1-git-send-email-massa.nomura@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove prohibited space and fix line over 80 characters of
memset(...) to meet kernel coding style.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index 66af02e..2d6414a 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -113,7 +113,7 @@ ksocknal_create_peer(ksock_peer_t **peerp, lnet_ni_t *ni, lnet_process_id_t id)
 	if (peer == NULL)
 		return -ENOMEM;
 
-	memset (peer, 0, sizeof (*peer));       /* NULL pointers/clear flags etc */
+	memset(peer, 0, sizeof(*peer));     /* NULL pointers/clear flags etc */
 
 	peer->ksnp_ni = ni;
 	peer->ksnp_id = id;
-- 
1.7.9.5

