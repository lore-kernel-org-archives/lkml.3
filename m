Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbaFQFsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 01:48:17 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:56852 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbaFQFsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 01:48:16 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v6 1/8] staging: lustre: lclient: glimpse.c fixing coding style issues
Date: Tue, 17 Jun 2014 15:43:52 +1000
Message-Id: <1402983839-3549-2-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1402983839-3549-1-git-send-email-askb23@gmail.com>
References: <1402983839-3549-1-git-send-email-askb23@gmail.com>
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
index 7bbca4b..f669645 100644
--- a/drivers/staging/lustre/lustre/lclient/glimpse.c
+++ b/drivers/staging/lustre/lustre/lclient/glimpse.c
@@ -177,7 +177,7 @@ static int cl_io_get(struct inode *inode, struct lu_env **envout,
 			io->ci_obj = clob;
 			*envout = env;
 			*ioout  = io;
-			result = +1;
+			result = 1;
 		} else
 			result = PTR_ERR(env);
 	} else
-- 
1.9.0

