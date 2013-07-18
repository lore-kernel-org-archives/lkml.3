Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab3GRHNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:13:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47857 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785Ab3GRHNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:13:05 -0400
Date: Thu, 18 Jul 2013 00:12:40 -0700
From: tip-bot for Sami Kerola <tipbot@zytor.com>
Message-ID: <tip-8192f5bccf26968a1d78ef71890f7a27f824119f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kerolasa@iki.fi, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, kerolasa@iki.fi
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/boot:
  Add lz4 compressed file to .gitignore file
Git-Commit-ID: 8192f5bccf26968a1d78ef71890f7a27f824119f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 18 Jul 2013 00:12:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8192f5bccf26968a1d78ef71890f7a27f824119f
Gitweb:     http://git.kernel.org/tip/8192f5bccf26968a1d78ef71890f7a27f824119f
Author:     Sami Kerola <kerolasa@iki.fi>
AuthorDate: Wed, 17 Jul 2013 17:30:28 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 18 Jul 2013 09:03:33 +0200

x86/boot: Add lz4 compressed file to .gitignore file

Signed-off-by: Sami Kerola <kerolasa@iki.fi>
Link: http://lkml.kernel.org/n/tip-wjc5bf2MtnlqihpoMvzutwby@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/boot/compressed/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/boot/compressed/.gitignore b/arch/x86/boot/compressed/.gitignore
index 4a46fab..a30c02e 100644
--- a/arch/x86/boot/compressed/.gitignore
+++ b/arch/x86/boot/compressed/.gitignore
@@ -1,5 +1,6 @@
 relocs
 vmlinux.bin.all
+vmlinux.bin.lz4
 vmlinux.relocs
 vmlinux.lds
 mkpiggy
