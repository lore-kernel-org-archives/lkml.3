Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbaGWULD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:11:03 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43542 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933025AbaGWUK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:10:58 -0400
X-Sasl-enc: DssEP8+ALk4ZndwjiSOB3vYA/SrZ7zQYC/SJnm6Axk8Y 1406146257
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: H Peter Anvin <hpa@zytor.com>
Subject: [PATCH 1/8] x86, microcode, amd: fix missing static declaration
Date: Wed, 23 Jul 2014 17:10:44 -0300
Message-Id: <1406146251-8540-2-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc warns that a declaration is missing.  Fix it.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 arch/x86/kernel/cpu/microcode/amd_early.c |    2 +-
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
-- 
1.7.10.4

