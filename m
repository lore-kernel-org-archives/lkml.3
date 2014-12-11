Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbaLKM03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:26:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56113 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbaLKM00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:26:26 -0500
Date: Thu, 11 Dec 2014 04:25:55 -0800
From: "tip-bot for Luis R. Rodriguez" <tipbot@zytor.com>
Message-ID: <tip-96ed4cd0aa86ac1a753baeef26c911a9449493e9@git.kernel.org>
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, bp@suse.de, mcgrof@suse.com
Reply-To: bp@suse.de, mcgrof@suse.com, tglx@linutronix.de, mingo@kernel.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <1418165684-6226-1-git-send-email-mcgrof@do-not-panic.com>
References: <1418165684-6226-1-git-send-email-mcgrof@do-not-panic.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/doc:
  Update documentation after file shuffling
Git-Commit-ID: 96ed4cd0aa86ac1a753baeef26c911a9449493e9
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

Commit-ID:  96ed4cd0aa86ac1a753baeef26c911a9449493e9
Gitweb:     http://git.kernel.org/tip/96ed4cd0aa86ac1a753baeef26c911a9449493e9
Author:     Luis R. Rodriguez <mcgrof@suse.com>
AuthorDate: Tue, 9 Dec 2014 14:54:44 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 11 Dec 2014 11:33:22 +0100

x86/doc: Update documentation after file shuffling

While at it, also refer to the 32 bit entry file.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: linux-doc@vger.kernel.org
Cc: bpoirier@suse.de
Link: http://lkml.kernel.org/r/1418165684-6226-1-git-send-email-mcgrof@do-not-panic.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/x86/entry_64.txt | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/x86/entry_64.txt b/Documentation/x86/entry_64.txt
index bc7226e..4a1c5c2 100644
--- a/Documentation/x86/entry_64.txt
+++ b/Documentation/x86/entry_64.txt
@@ -7,9 +7,12 @@ http://lkml.kernel.org/r/<20110529191055.GC9835%40elte.hu>
 The x86 architecture has quite a few different ways to jump into
 kernel code.  Most of these entry points are registered in
 arch/x86/kernel/traps.c and implemented in arch/x86/kernel/entry_64.S
-and arch/x86/ia32/ia32entry.S.
+for 64-bit, arch/x86/kernel/entry_32.S for 32-bit and finally
+arch/x86/ia32/ia32entry.S which implements the 32-bit compatibility
+syscall entry points and thus provides for 32-bit processes the
+ability to execute syscalls when running on 64-bit kernels.
 
-The IDT vector assignments are listed in arch/x86/include/irq_vectors.h.
+The IDT vector assignments are listed in arch/x86/include/asm/irq_vectors.h.
 
 Some of these entries are:
 
