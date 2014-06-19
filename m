Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbaFSLvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:51:06 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41375 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129AbaFSLvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:51:02 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH 2/2] staging: lustre: lustre: fld: lproc_fld.c fixed warning
Date: Thu, 19 Jun 2014 21:50:42 +1000
Message-Id: <1403178642-6984-2-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403178642-6984-1-git-send-email-askb23@gmail.com>
References: <1403178642-6984-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

fixed warning "WARNING: EXPORT_SYMBOL(foo); should immediately follow its
function/variable"

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/fld/fld_request.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/fld/fld_request.c b/drivers/staging/lustre/lustre/fld/fld_request.c
index 1f8abba..211430d 100644
--- a/drivers/staging/lustre/lustre/fld/fld_request.c
+++ b/drivers/staging/lustre/lustre/fld/fld_request.c
@@ -324,7 +324,6 @@ void fld_client_proc_fini(struct lu_client_fld *fld)
 	return;
 }
 #endif
-
 EXPORT_SYMBOL(fld_client_proc_fini);
 
 static inline int hash_is_sane(int hash)
-- 
1.9.0

