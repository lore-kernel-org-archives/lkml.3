Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaFPE3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 00:29:12 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63224 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaFPE3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 00:29:09 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v3 1/7] staging: lustre: lclient: glimpse.c fixing coding style issues
Date: Mon, 16 Jun 2014 14:28:30 +1000
Message-Id: <1402892916-5298-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

Fixed "ERROR: need consistent spacing around '+' (ctx:WxV)"

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/lclient/glimpse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/lclient/glimpse.c b/drivers/staging/lustre/lustre/lclient/glimpse.c
index 7bbca4b..60a6e6e 100644
--- a/drivers/staging/lustre/lustre/lclient/glimpse.c
+++ b/drivers/staging/lustre/lustre/lclient/glimpse.c
@@ -177,7 +177,7 @@ static int cl_io_get(struct inode *inode, struct lu_env **envout,
 			io->ci_obj = clob;
 			*envout = env;
 			*ioout  = io;
-			result = +1;
+			result = + 1;
 		} else
 			result = PTR_ERR(env);
 	} else
-- 
1.9.0

