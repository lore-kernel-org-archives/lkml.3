Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab3HFVoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:44:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43547 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab3HFVom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:44:42 -0400
Date: Tue, 6 Aug 2013 14:44:32 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-4a335c0695074c1fd2ede7f919b0064f53d35c3f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1375740170-7446-14-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-14-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage:
  Make 64bit checksum functions visible
Git-Commit-ID: 4a335c0695074c1fd2ede7f919b0064f53d35c3f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 06 Aug 2013 14:44:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a335c0695074c1fd2ede7f919b0064f53d35c3f
Gitweb:     http://git.kernel.org/tip/4a335c0695074c1fd2ede7f919b0064f53d35c3f
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 5 Aug 2013 15:02:47 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 6 Aug 2013 14:20:59 -0700

x86, asmlinkage: Make 64bit checksum functions visible

They are implemented in assembler.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1375740170-7446-14-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
 
