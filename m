Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaIPIbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:31:17 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:55803 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbaIPIbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:31:15 -0400
Date: Tue, 16 Sep 2014 10:31:09 +0200
From: Michele Curti <michele.curti@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86/vdso: use NULL instead of zero
Message-ID: <20140916083109.GA802@powerline.azcom-win.it>
References: <20140915143939.GA1953@powerline.azcom-win.it>
 <20140916065732.GA19849@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140916065732.GA19849@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


x86/vdso: use NULL instead of zero in patch_vdso32()

Signed-off-by: Michele Curti <michele.curti@gmail.com>

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 1ad1026..a4647bc 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -34,7 +34,7 @@ static unsigned vdsox32_size;
 void __init patch_vdso32(void *vdso, size_t len)
 {
 	Elf32_Ehdr *hdr = vdso;
-	Elf32_Shdr *sechdrs, *alt_sec = 0;
+	Elf32_Shdr *sechdrs, *alt_sec = NULL;
 	char *secstrings;
 	void *alt_data;
 	int i;
-- 
2.1.0

Regards,
Michele

