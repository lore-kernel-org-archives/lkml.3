Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab3HEWGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:06:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:64992 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116Ab3HEWDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:03:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="382341519"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 13/16] x86, asmlinkage: Make 64bit checksum functions visible
Date: Mon,  5 Aug 2013 15:02:47 -0700
Message-Id: <1375740170-7446-14-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

They are implemented in assembler.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/checksum_64.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/checksum_64.h b/arch/x86/include/asm/checksum_64.h
index 9bfdc41..e6fd8a0 100644
--- a/arch/x86/include/asm/checksum_64.h
+++ b/arch/x86/include/asm/checksum_64.h
@@ -133,7 +133,7 @@ extern __wsum csum_partial(const void *buff, int len, __wsum sum);
 
 
 /* Do not call this directly. Use the wrappers below */
-extern __wsum csum_partial_copy_generic(const void *src, const void *dst,
+extern __visible __wsum csum_partial_copy_generic(const void *src, const void *dst,
 					int len, __wsum sum,
 					int *src_err_ptr, int *dst_err_ptr);
 
-- 
1.8.3.1

