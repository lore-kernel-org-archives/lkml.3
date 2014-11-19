Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbaKSUxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:53:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbaKSUxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:53:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shuah Khan <shuahkh@osg.samsung.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.17 001/141] x86/build: Add arch/x86/purgatory/ make generated files to gitignore
Date: Wed, 19 Nov 2014 12:50:24 -0800
Message-Id: <20141119205150.748238872@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuah Khan <shuahkh@osg.samsung.com>

commit 4ea48a01bb1a99f4185b77cd90cf962730336cc4 upstream.

The following generated files are missing from gitignore
and show up in git status after x86_64 build. Add them
to gitignore.

    arch/x86/purgatory/kexec-purgatory.c
    arch/x86/purgatory/purgatory.ro

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Link: http://lkml.kernel.org/r/1412016116-7213-1-git-send-email-shuahkh@osg.samsung.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/.gitignore |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/.gitignore
+++ b/arch/x86/.gitignore
@@ -1,4 +1,6 @@
 boot/compressed/vmlinux
 tools/test_get_len
 tools/insn_sanity
+purgatory/kexec-purgatory.c
+purgatory/purgatory.ro
 


