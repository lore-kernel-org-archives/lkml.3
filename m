Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048AbaFRIYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:24:39 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:40058 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705AbaFRIYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:24:33 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v7 2/8] staging: lustre: lclient: glimpse.c fixing coding style issues
Date: Wed, 18 Jun 2014 18:23:50 +1000
Message-Id: <1403079836-9304-3-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403079836-9304-1-git-send-email-askb23@gmail.com>
References: <1403079836-9304-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

fixed "WARNING: labels should not be indented"

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/lclient/glimpse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/lclient/glimpse.c b/drivers/staging/lustre/lustre/lclient/glimpse.c
index f669645..a658116 100644
--- a/drivers/staging/lustre/lustre/lclient/glimpse.c
+++ b/drivers/staging/lustre/lustre/lclient/glimpse.c
@@ -204,7 +204,7 @@ int cl_glimpse_size0(struct inode *inode, int agl)
 
 	result = cl_io_get(inode, &env, &io, &refcheck);
 	if (result > 0) {
-	again:
+again:
 		io->ci_verify_layout = 1;
 		result = cl_io_init(env, io, CIT_MISC, io->ci_obj);
 		if (result > 0)
-- 
1.9.0

