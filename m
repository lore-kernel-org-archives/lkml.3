Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaJJWza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 18:55:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbaJJWz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 18:55:29 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, x86@kernel.org,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] x86, kexec: Add .gitignore file
Date: Fri, 10 Oct 2014 18:55:21 -0400
Message-Id: <1412981721-3432-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing git-status there are two untracked files:

\# Untracked files:
\#   (use "git add <file>..." to include in what will be committed)
\#
\#       arch/x86/purgatory/kexec-purgatory.c
\#       arch/x86/purgatory/purgatory.ro

Add a .gitignore to block these files.

Cc: x86@kernel.org
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 arch/x86/purgatory/.gitignore |    2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 arch/x86/purgatory/.gitignore

diff --git a/arch/x86/purgatory/.gitignore b/arch/x86/purgatory/.gitignore
new file mode 100644
index 0000000..e9e66f1
--- /dev/null
+++ b/arch/x86/purgatory/.gitignore
@@ -0,0 +1,2 @@
+kexec-purgatory.c
+purgatory.ro
-- 
1.7.9.3

