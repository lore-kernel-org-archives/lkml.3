Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaEOAEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 20:04:07 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34715 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaEOAEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 20:04:06 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Masaru Nomura <massa.nomura@gmail.com>
Subject: [PATCH] staging: lustre: socklnd: Fix indenting
Date: Thu, 15 May 2014 01:03:42 +0100
Message-Id: <1400112222-7652-1-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed indenting of if statement in socklnd.c to meet kernel coding style.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index 21d36ee..b3c4fc3 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -2514,7 +2514,8 @@ ksocknal_debug_peerhash (lnet_ni_t *ni)
 		list_for_each (tmp, &ksocknal_data.ksnd_peers[i]) {
 			peer = list_entry (tmp, ksock_peer_t, ksnp_list);
 
-			if (peer->ksnp_ni == ni) break;
+			if (peer->ksnp_ni == ni)
+				break;
 
 			peer = NULL;
 		}
-- 
1.7.9.5

