Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaHMBnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 21:43:24 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:41283 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbaHMBnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 21:43:23 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Jan Beulich <JBeulich@suse.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE...)
Subject: [PATCH 1/1] rtc: Remove duplicate const qualifier
Date: Tue, 12 Aug 2014 21:43:42 -0400
Message-Id: <1407894223-24786-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a duplicate const qualifier

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/x86/kernel/rtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index ca9622a..fe3dbfe 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -170,7 +170,7 @@ static struct platform_device rtc_device = {
 static __init int add_rtc_cmos(void)
 {
 #ifdef CONFIG_PNP
-	static const char * const  const ids[] __initconst =
+	static const char * const ids[] __initconst =
 	    { "PNP0b00", "PNP0b01", "PNP0b02", };
 	struct pnp_dev *dev;
 	struct pnp_id *id;
-- 
1.9.1

