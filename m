Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaFMC2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 22:28:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42294 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaFMC2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 22:28:01 -0400
Date: Thu, 12 Jun 2014 19:27:39 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-6e8f21584a30ba6ce73cfef34f316d5bf3fadaab@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <3efc170e0e166e15f0150c9fdb37d52488b9c0a4.1402620737.git.luto@amacapital.net>
References: <3efc170e0e166e15f0150c9fdb37d52488b9c0a4.1402620737.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86/vdso/doc:
  Rename vdso_test.c to vdso_standalone_test_x86.c
Git-Commit-ID: 6e8f21584a30ba6ce73cfef34f316d5bf3fadaab
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

Commit-ID:  6e8f21584a30ba6ce73cfef34f316d5bf3fadaab
Gitweb:     http://git.kernel.org/tip/6e8f21584a30ba6ce73cfef34f316d5bf3fadaab
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Thu, 12 Jun 2014 17:53:09 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 12 Jun 2014 19:01:16 -0700

x86/vdso/doc: Rename vdso_test.c to vdso_standalone_test_x86.c

This thing is hopelessly x86_64-specific: it's an example of how to
access the vDSO without any runtime support at all.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/3efc170e0e166e15f0150c9fdb37d52488b9c0a4.1402620737.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 Documentation/vDSO/{vdso_test.c => vdso_standalone_test_x86.c} | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/vDSO/vdso_test.c b/Documentation/vDSO/vdso_standalone_test_x86.c
similarity index 98%
rename from Documentation/vDSO/vdso_test.c
rename to Documentation/vDSO/vdso_standalone_test_x86.c
index fff6334..1523f5d 100644
--- a/Documentation/vDSO/vdso_test.c
+++ b/Documentation/vDSO/vdso_standalone_test_x86.c
@@ -6,7 +6,7 @@
  * You can amuse yourself by compiling with:
  * gcc -std=gnu99 -nostdlib
  *     -Os -fno-asynchronous-unwind-tables -flto
- *      vdso_test.c parse_vdso.c -o vdso_test
+ *      vdso_standalone_test_x86.c parse_vdso.c
  * to generate a small binary with no dependencies at all.
  */
 
