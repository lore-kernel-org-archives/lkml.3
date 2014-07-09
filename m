Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbaGILhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:37:21 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63169 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728AbaGILg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:36:57 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-18-53bd294f311c
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH RESEND -next 19/21] arm: Kconfig: enable kernel address
 sanitizer
Date: Wed, 09 Jul 2014 15:30:13 +0400
Message-id: <1404905415-9046-20-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t/xy7r+mnuDDQ428Vls+/WIzeL33pms
	FnPWr2GzuP7tDaPFhIdt7BYru5vZLLY/e8tksbLzAavFpsfXWC3+7NrBZHF51xw2i3tr/rNa
	3L7Ma3HpwAImi5Z9F5gs2j7/Y7XYt/I8kLVkI5PF4iO3mS3ePZvMbLF501Rmix8bHrM6iHm0
	NPeweeycdZfdY8GmUo9NqzrZPDZ9msTu0fX2CpPHu3Pn2D1OzPjN4vHkynQmj81L6j0+Pr3F
	4vF+31U2j74tqxg9ziw4wu7xeZNcAH8Ul01Kak5mWWqRvl0CV8aNi++YC/6wVDybuoitgbGf
	pYuRk0NCwESi59ccdghbTOLCvfVsXYxcHEICSxkl7l1ezAjh9DFJbHv1lRGkik1AT+LfrO1s
	ILaIgILE5t5nrCBFzALNbBLtHR9YQRLCAuES9xc8AbNZBFQlvi55AtbAK+AmsWfCZKh1ChLL
	ls8Eq+EEik+Yfo25i5EDaJurxIQVahMYeRcwMqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93E
	CImlLzsYFx+zOsQowMGoxMOrUbs7WIg1say4MvcQowQHs5IIr63o3mAh3pTEyqrUovz4otKc
	1OJDjEwcnFINjO3eP3cYu2c4mBxO1tzZ0vFz6aTed6baGdmKApXTPResnF8twfz0x30+qbVL
	vjOKr3tytNx+/TeTI+2B98KvX5zbFnpFy9L6y8voF2u4jb32/ulrV3Sdn/rTcrZzQvUnVuWM
	1XHbU2aqvpzWuL+oTmDlRy2b1L5q028cGlf+5feW67o/k/0Xr8RSnJFoqMVcVJwIAA1c79uD	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now everything in x86 code is ready for kasan. Enable it.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c52d1ca..c62db6c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -26,6 +26,7 @@ config ARM
 	select HARDIRQS_SW_RESEND
 	select HAVE_ARCH_AUDITSYSCALL if (AEABI && !OABI_COMPAT)
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
+	select HAVE_ARCH_KASAN
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_SECCOMP_FILTER if (AEABI && !OABI_COMPAT)
 	select HAVE_ARCH_TRACEHOOK
-- 
1.8.5.5

