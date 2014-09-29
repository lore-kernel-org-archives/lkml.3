Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaI2SmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:42:05 -0400
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:49011 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752926AbaI2SmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:42:03 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: add purgatory make generated files to gitignore
Date: Mon, 29 Sep 2014 12:41:56 -0600
Message-Id: <1412016116-7213-1-git-send-email-shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following generated files are missing from gitignore
and show up in git status after x86_64 build. Add them
to gitignore.

    arch/x86/purgatory/kexec-purgatory.c
    arch/x86/purgatory/purgatory.ro

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
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
 
-- 
1.9.1

