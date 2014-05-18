Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbaERRTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 13:19:55 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:55268 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbaERRTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 13:19:25 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: gregkh@linuxfoundation.org, andreas.dilger@intel.com,
        oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 5/5] staging: lustre: lnet: socklnd: Clean up ksocknal_create_conn(...)
Date: Sun, 18 May 2014 18:19:17 +0100
Message-Id: <1400433557-24985-6-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400433557-24985-1-git-send-email-massa.nomura@gmail.com>
References: <1400433557-24985-1-git-send-email-massa.nomura@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove prohibited space and fix indenting of following parameters
of ksocknal_create_conn(...) to meet kernel coding style.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index fd4cdc3..c63d69a 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -1010,8 +1010,8 @@ ksocknal_connecting(ksock_peer_t *peer, __u32 ipaddr)
 }
 
 int
-ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
-		      socket_t *sock, int type)
+ksocknal_create_conn(lnet_ni_t *ni, ksock_route_t *route,
+		     socket_t *sock, int type)
 {
 	rwlock_t		*global_lock = &ksocknal_data.ksnd_global_lock;
 	LIST_HEAD     (zombies);
-- 
1.7.9.5

