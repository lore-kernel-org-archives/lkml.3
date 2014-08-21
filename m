Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaHUGqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 02:46:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58169 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbaHUGqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 02:46:03 -0400
Date: Wed, 20 Aug 2014 23:45:36 -0700
From: tip-bot for Ross Zwisler <tipbot@zytor.com>
Message-ID: <tip-448466b723cc7b44016547116aa2b55a3736f1f0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ross.zwisler@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ross.zwisler@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1400521824-21040-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1400521824-21040-1-git-send-email-ross.zwisler@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Remove obsolete comment in uapi/e820.h
Git-Commit-ID: 448466b723cc7b44016547116aa2b55a3736f1f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  448466b723cc7b44016547116aa2b55a3736f1f0
Gitweb:     http://git.kernel.org/tip/448466b723cc7b44016547116aa2b55a3736f1f0
Author:     Ross Zwisler <ross.zwisler@linux.intel.com>
AuthorDate: Mon, 19 May 2014 11:50:24 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 21 Aug 2014 08:43:39 +0200

x86: Remove obsolete comment in uapi/e820.h

A comment introduced by this old commit:

  028b785888c5 ("x86 boot: extend some internal memory map arrays to handle larger EFI input")

had to do with some nested preprocessor directives.  The
directives were split into separate files by this commit:

  af170c5061dd ("UAPI: (Scripted) Disintegrate arch/x86/include/asm")

The comment explaining their interaction was retained and is now
present in arch/x86/include/uapi/asm/e820.h.  This comment is no
longer correct, so delete it.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Link: http://lkml.kernel.org/r/1400521824-21040-1-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/uapi/asm/e820.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/include/uapi/asm/e820.h b/arch/x86/include/uapi/asm/e820.h
index bbae024..d993e33 100644
--- a/arch/x86/include/uapi/asm/e820.h
+++ b/arch/x86/include/uapi/asm/e820.h
@@ -21,11 +21,6 @@
  * this size.
  */
 
-/*
- * Odd: 'make headers_check' complains about numa.h if I try
- * to collapse the next two #ifdef lines to a single line:
- *	#if defined(__KERNEL__) && defined(CONFIG_EFI)
- */
 #ifndef __KERNEL__
 #define E820_X_MAX E820MAX
 #endif
