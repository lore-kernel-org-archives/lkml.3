Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbaDNWet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:34:49 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:51471 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaDNWes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:34:48 -0400
Message-ID: <534C6286.4040600@gmail.com>
Date: Mon, 14 Apr 2014 18:34:46 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: hpa@linux.intel.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] remove duplicate definition
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 include/linux/compiler-intel.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.h
index 5529c52..ba147a1 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -13,12 +13,9 @@
 /* Intel ECC compiler doesn't support gcc specific asm stmts.
  * It uses intrinsics to do the equivalent things.
  */
-#undef barrier
 #undef RELOC_HIDE
 #undef OPTIMIZER_HIDE_VAR
 
-#define barrier() __memory_barrier()
-
 #define RELOC_HIDE(ptr, off)					\
   ({ unsigned long __ptr;					\
      __ptr = (unsigned long) (ptr);				\
-- 
1.9.1

--
Pranith
