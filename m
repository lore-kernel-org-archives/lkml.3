Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaDZP4L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 11:56:11 -0400
Received: from nm4-vm5.bullet.mail.ir2.yahoo.com ([212.82.96.103]:36327 "EHLO
	nm4-vm5.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177AbaDZP4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 11:56:10 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Apr 2014 11:56:09 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s1024; d=yahoo.fr;
	b=QObYGJqRqOfItAfO+KNu68ql0OAfh/+fUxKkMcMtrg/TcgN95iIu1b+pVJxnNpbhotAXhYvrBAHhc4U0K8e2ILxeZ76wy8FX0/otLWw6bLnOQFasvcIaLWkvFo8TlljprgG7jnQPaCg3QEhjcf+DHmi5O2pt5oGwbnbYvUWIiOg=;
X-Yahoo-Newman-Id: 123199.42585.bm@smtp144.mail.ir2.yahoo.com
Message-ID: <123199.42585.bm@smtp144.mail.ir2.yahoo.com>
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4S7Pu1gVM1mUypIC2pUsg_mCZJ0WhdiAX4kAaO5nOnRLNwa
 V6uOaznu7sbPdpc4QuwJ8xFuVeMti1WesUReDSTpTTFOkRRVNQGJUCCIPLbF
 Xz6GFWqjDVrOTbZY6yKXz71R8dP4o5Lb_MdCT7NYUQqrsOxyPON1cjamewMQ
 GcVySmBqiFTPC04tvgAdJI9f3Il8Cv3jGz1PbwjS0bTUrLrWiNUj6Ocu8yRZ
 X7i5mXAd8orYt8UgHrgtPwC97DRhx_LfhllhSiJGRleDqUcObWsEGFIB0iFY
 XCqbB83HCHiHk9V4lStwRGUL5MgwMOiVTkR7Uibg7aa6pb..ZGKUsDGMocGJ
 oKgBsmhDaWRahdLoA4JDK55bN38ZvWeu9Mw7t0JKTN8U_Bj_nu2s_C4MTghF
 NAYdO9cI7n2cyxf0ndQfpG1gLHW3Cijj0F2BVHXutB20ItQsvOwsSj88JkRe
 hFdueUrTu.Wm7.EGmd_2wjn.s4U2zLXFCI0Qxv6JPEfOtJe86J5h8UKNeulG
 eToCtk.Cwbo7xZvCQwIoXpw.oRQiE6gyCBdk6YNE-
X-Yahoo-SMTP: zgdcvJ6swBBcTOk5fgveL37ak9AQxYCP7GdO
X-Rocket-Received: from asus2 (lionel_debroux@82.122.199.38 with plain [188.125.69.59])
        by smtp144.mail.ir2.yahoo.com with SMTP; 26 Apr 2014 15:50:05 +0000 UTC
Date: Sat, 26 Apr 2014 17:50:02 +0200
From: Lionel Debroux <lionel_debroux@yahoo.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH] arm/mach-ux500: remove unused macro.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on PaX.

---

>From 9c443a7dfe581da8db5566d968a19c54f06a7fa3 Mon Sep 17 00:00:00 2001
From: Lionel Debroux <lionel_debroux@yahoo.fr>
Date: Sat, 26 Apr 2014 15:44:22 +0200
Subject: arm/mach-ux500: remove unused macro.

Extracted from the PaX patch.

Signed-off-by: Lionel Debroux <lionel_debroux@yahoo.fr>
Cc: PaX Team <pageexec@freemail.hu>
---
 arch/arm/mach-ux500/setup.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm/mach-ux500/setup.h b/arch/arm/mach-ux500/setup.h
index 2dea8b5..6499da2 100644
--- a/arch/arm/mach-ux500/setup.h
+++ b/arch/arm/mach-ux500/setup.h
@@ -33,13 +33,6 @@ extern void ux500_timer_init(void);
 	.type		= MT_DEVICE,		\
 }
 
-#define __MEM_DEV_DESC(x, sz)	{		\
-	.virtual	= IO_ADDRESS(x),	\
-	.pfn		= __phys_to_pfn(x),	\
-	.length		= sz,			\
-	.type		= MT_MEMORY_RWX,		\
-}
-
 extern struct smp_operations ux500_smp_ops;
 extern void ux500_cpu_die(unsigned int cpu);
 
-- 
1.9.1.506.g7bf272c

