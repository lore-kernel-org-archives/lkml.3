Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaFYE6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 00:58:37 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:38325 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaFYE6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 00:58:34 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH 2/4] staging: lustre: llite: llite_capa.c - fixed warning to use recomended headers <linux/uaccess.h>
Date: Wed, 25 Jun 2014 14:57:28 +1000
Message-Id: <1403672250-19048-2-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403672250-19048-1-git-send-email-askb23@gmail.com>
References: <1403672250-19048-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- this fixes "WARNING: Use #include <linux/uaccess.h> instead of
  <asm/uaccess.h>"

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/llite/llite_capa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_capa.c b/drivers/staging/lustre/lustre/llite/llite_capa.c
index 7ed45a4..2f11cbf 100644
--- a/drivers/staging/lustre/lustre/llite/llite_capa.c
+++ b/drivers/staging/lustre/lustre/llite/llite_capa.c
@@ -41,7 +41,7 @@
 #define DEBUG_SUBSYSTEM S_LLITE
 
 #include <linux/fs.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/file.h>
 #include <linux/kmod.h>
 
-- 
1.9.0

