Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbaGWULK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:11:10 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43942 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933292AbaGWULD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:11:03 -0400
X-Sasl-enc: pNp6EZ3p2MR/9w1VJvEip2B5md6q3GdyKCOutd+NZDmy 1406146262
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: H Peter Anvin <hpa@zytor.com>
Subject: [PATCH 3/8] x86, microcode, intel: fix typos
Date: Wed, 23 Jul 2014 17:10:46 -0300
Message-Id: <1406146251-8540-4-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some typos.  One of them was in a struct name, fortunately harmless
because it happened on a "sizeof(struct foo*)" construction.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 arch/x86/kernel/cpu/microcode/intel_early.c |    6 +++---
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
-- 
1.7.10.4

