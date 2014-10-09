Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaJIHd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:33:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50422 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaJIHdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:33:47 -0400
Date: Thu, 9 Oct 2014 00:33:31 -0700
From: tip-bot for Shuah Khan <tipbot@zytor.com>
Message-ID: <tip-4ea48a01bb1a99f4185b77cd90cf962730336cc4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        shuahkh@osg.samsung.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shuahkh@osg.samsung.com, tglx@linutronix.de
In-Reply-To: <1412016116-7213-1-git-send-email-shuahkh@osg.samsung.com>
References: <1412016116-7213-1-git-send-email-shuahkh@osg.samsung.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/build: Add arch/x86/purgatory/
  make generated files to gitignore
Git-Commit-ID: 4ea48a01bb1a99f4185b77cd90cf962730336cc4
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

Commit-ID:  4ea48a01bb1a99f4185b77cd90cf962730336cc4
Gitweb:     http://git.kernel.org/tip/4ea48a01bb1a99f4185b77cd90cf962730336cc4
Author:     Shuah Khan <shuahkh@osg.samsung.com>
AuthorDate: Mon, 29 Sep 2014 12:41:56 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 9 Oct 2014 09:29:46 +0200

x86/build: Add arch/x86/purgatory/ make generated files to gitignore

The following generated files are missing from gitignore
and show up in git status after x86_64 build. Add them
to gitignore.

    arch/x86/purgatory/kexec-purgatory.c
    arch/x86/purgatory/purgatory.ro

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Link: http://lkml.kernel.org/r/1412016116-7213-1-git-send-email-shuahkh@osg.samsung.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/.gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/.gitignore b/arch/x86/.gitignore
index 7cab8c0..aff152c 100644
--- a/arch/x86/.gitignore
+++ b/arch/x86/.gitignore
@@ -1,4 +1,6 @@
 boot/compressed/vmlinux
 tools/test_get_len
 tools/insn_sanity
+purgatory/kexec-purgatory.c
+purgatory/purgatory.ro
 
