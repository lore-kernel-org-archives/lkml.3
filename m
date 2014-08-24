Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaHXO4G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:56:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33984 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaHXO4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:56:04 -0400
Date: Sun, 24 Aug 2014 07:55:49 -0700
From: tip-bot for Henrique de Moraes Holschuh <tipbot@zytor.com>
Message-ID: <tip-05a5f76d033f413396bc48ce2f8651b5659bcd31@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hmh@hmh.eng.br, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, hmh@hmh.eng.br,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode, intel:
  Add missing static declarations
Git-Commit-ID: 05a5f76d033f413396bc48ce2f8651b5659bcd31
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

Commit-ID:  05a5f76d033f413396bc48ce2f8651b5659bcd31
Gitweb:     http://git.kernel.org/tip/05a5f76d033f413396bc48ce2f8651b5659bcd31
Author:     Henrique de Moraes Holschuh <hmh@hmh.eng.br>
AuthorDate: Wed, 23 Jul 2014 17:10:45 -0300
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Thu, 24 Jul 2014 12:26:52 +0200

x86, microcode, intel: Add missing static declarations

gcc reports that a few declarations are missing.
Fix two obvious ones.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Link: http://lkml.kernel.org/r/1406146251-8540-1-git-send-email-hmh@hmh.eng.br
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/microcode/intel_early.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
index 18f7391..b105c11 100644
--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -28,8 +28,8 @@
 #include <asm/tlbflush.h>
 #include <asm/setup.h>
 
-unsigned long mc_saved_in_initrd[MAX_UCODE_COUNT];
-struct mc_saved_data {
+static unsigned long mc_saved_in_initrd[MAX_UCODE_COUNT];
+static struct mc_saved_data {
 	unsigned int mc_saved_count;
 	struct microcode_intel **mc_saved;
 } mc_saved_data;
