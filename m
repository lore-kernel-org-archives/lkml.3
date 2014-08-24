Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaHXO4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:56:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33986 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaHXO4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:56:08 -0400
Date: Sun, 24 Aug 2014 07:55:33 -0700
From: tip-bot for Henrique de Moraes Holschuh <tipbot@zytor.com>
Message-ID: <tip-1d2ce978d160fa960f12d06bf84e45f47c141272@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hmh@hmh.eng.br, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, hmh@hmh.eng.br,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode, amd:
  Fix missing static declaration
Git-Commit-ID: 1d2ce978d160fa960f12d06bf84e45f47c141272
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

Commit-ID:  1d2ce978d160fa960f12d06bf84e45f47c141272
Gitweb:     http://git.kernel.org/tip/1d2ce978d160fa960f12d06bf84e45f47c141272
Author:     Henrique de Moraes Holschuh <hmh@hmh.eng.br>
AuthorDate: Wed, 23 Jul 2014 17:10:44 -0300
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Thu, 24 Jul 2014 12:21:46 +0200

x86, microcode, amd: Fix missing static declaration

Make locally used variable static.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Link: http://lkml.kernel.org/r/1406146251-8540-1-git-send-email-hmh@hmh.eng.br
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/microcode/amd_early.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
index 617a9e2..7aa1acc 100644
--- a/arch/x86/kernel/cpu/microcode/amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -27,7 +27,7 @@ static u32 ucode_new_rev;
 u8 amd_ucode_patch[PATCH_MAX_SIZE];
 static u16 this_equiv_id;
 
-struct cpio_data ucode_cpio;
+static struct cpio_data ucode_cpio;
 
 /*
  * Microcode patch container file is prepended to the initrd in cpio format.
