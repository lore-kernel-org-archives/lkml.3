Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaERRT0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 13:19:26 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:36450 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaERRTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 13:19:23 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: gregkh@linuxfoundation.org, andreas.dilger@intel.com,
        oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 3/5] staging: lustre: lnet: socklnd: Clean up CDEBUG(...)
Date: Sun, 18 May 2014 18:19:15 +0100
Message-Id: <1400433557-24985-4-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400433557-24985-1-git-send-email-massa.nomura@gmail.com>
References: <1400433557-24985-1-git-send-email-massa.nomura@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove prohibited space and fix indenting of following parameters
of CDEBUG(...) to meet kernel coding style.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index 2d6414a..26cb8ce 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -153,8 +153,8 @@ ksocknal_destroy_peer(ksock_peer_t *peer)
 {
 	ksock_net_t    *net = peer->ksnp_ni->ni_data;
 
-	CDEBUG (D_NET, "peer %s %p deleted\n",
-		libcfs_id2str(peer->ksnp_id), peer);
+	CDEBUG(D_NET, "peer %s %p deleted\n",
+	       libcfs_id2str(peer->ksnp_id), peer);
 
 	LASSERT(atomic_read(&peer->ksnp_refcount) == 0);
 	LASSERT(peer->ksnp_accepting == 0);
-- 
1.7.9.5

