Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061AbaDJStT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:49:19 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:41822 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbaDJStP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:49:15 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, riel@redhat.com
Subject: [PATCH 06/15] ipc:shm whitespace
Date: Thu, 10 Apr 2014 19:49:12 +0100
Message-Id: <1397155752-6578-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: trailing whitespace

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 ipc/shm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 89ab12c..33d7e95 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -694,7 +694,7 @@ static inline unsigned long copy_shminfo_to_user(void __user *buf, struct shminf
 		out.shmmin	= in->shmmin;
 		out.shmmni	= in->shmmni;
 		out.shmseg	= in->shmseg;
-		out.shmall	= in->shmall; 
+		out.shmall	= in->shmall;
 
 		return copy_to_user(buf, &out, sizeof(out));
 	    }
-- 
1.8.3.2

