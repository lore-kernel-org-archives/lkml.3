Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaHXO4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:56:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33993 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaHXO4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:56:18 -0400
Date: Sun, 24 Aug 2014 07:56:04 -0700
From: tip-bot for Henrique de Moraes Holschuh <tipbot@zytor.com>
Message-ID: <tip-f99b45c3c2aa6960b8d21bb200d144be48a0a783@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hmh@hmh.eng.br, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, hmh@hmh.eng.br,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode, intel: Fix typos
Git-Commit-ID: f99b45c3c2aa6960b8d21bb200d144be48a0a783
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

Commit-ID:  f99b45c3c2aa6960b8d21bb200d144be48a0a783
Gitweb:     http://git.kernel.org/tip/f99b45c3c2aa6960b8d21bb200d144be48a0a783
Author:     Henrique de Moraes Holschuh <hmh@hmh.eng.br>
AuthorDate: Wed, 23 Jul 2014 17:10:46 -0300
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Thu, 24 Jul 2014 12:32:49 +0200

x86, microcode, intel: Fix typos

Fix some typos. One of them was in a struct name, fortunately harmless
because it happened on a "sizeof(struct foo*)" construction.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Link: http://lkml.kernel.org/r/1406146251-8540-1-git-send-email-hmh@hmh.eng.br
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/microcode/intel_early.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
index b105c11..b88343f 100644
--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -415,7 +415,7 @@ static void __ref show_saved_mc(void)
 	struct ucode_cpu_info uci;
 
 	if (mc_saved_data.mc_saved_count == 0) {
-		pr_debug("no micorcode data saved.\n");
+		pr_debug("no microcode data saved.\n");
 		return;
 	}
 	pr_debug("Total microcode saved: %d\n", mc_saved_data.mc_saved_count);
@@ -506,7 +506,7 @@ int save_mc_for_early(u8 *mc)
 
 	if (mc_saved && mc_saved_count)
 		memcpy(mc_saved_tmp, mc_saved,
-		       mc_saved_count * sizeof(struct mirocode_intel *));
+		       mc_saved_count * sizeof(struct microcode_intel *));
 	/*
 	 * Save the microcode patch mc in mc_save_tmp structure if it's a newer
 	 * version.
@@ -526,7 +526,7 @@ int save_mc_for_early(u8 *mc)
 	show_saved_mc();
 
 	/*
-	 * Free old saved microcod data.
+	 * Free old saved microcode data.
 	 */
 	if (mc_saved) {
 		for (i = 0; i < mc_saved_count_init; i++)
