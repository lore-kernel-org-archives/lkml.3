Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaERRTa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 13:19:30 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46332 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaERRTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 13:19:24 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: gregkh@linuxfoundation.org, andreas.dilger@intel.com,
        oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 4/5] staging: lustre: lnet: socklnd: Clean up ksocknal_get_peer_info(...)
Date: Sun, 18 May 2014 18:19:16 +0100
Message-Id: <1400433557-24985-5-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400433557-24985-1-git-send-email-massa.nomura@gmail.com>
References: <1400433557-24985-1-git-send-email-massa.nomura@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove prohibited space and fix indenting of following parameter
of ksocknal_get_peer_info(...) to meet kernel coding style.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index 26cb8ce..fd4cdc3 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -247,9 +247,9 @@ ksocknal_unlink_peer_locked(ksock_peer_t *peer)
 }
 
 int
-ksocknal_get_peer_info (lnet_ni_t *ni, int index,
-			lnet_process_id_t *id, __u32 *myip, __u32 *peer_ip,
-			int *port, int *conn_count, int *share_count)
+ksocknal_get_peer_info(lnet_ni_t *ni, int index,
+		       lnet_process_id_t *id, __u32 *myip, __u32 *peer_ip,
+		       int *port, int *conn_count, int *share_count)
 {
 	ksock_peer_t      *peer;
 	struct list_head	*ptmp;
-- 
1.7.9.5

