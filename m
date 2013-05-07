Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab3EGGa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 02:30:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9808 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab3EGGaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 02:30:55 -0400
X-AuditID: cbfee690-b7f136d000000fea-2b-51889f9e9610
Date: Tue, 07 May 2013 06:30:54 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: MIPS: Test reault for  enable interrupts before WAIT instruction patch
To: "david.daney@cavium.com" <david.daney@cavium.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "jogo@openwrt.org" <jogo@openwrt.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>, manuel.lauss@gmail.com
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130507061510134@eunb.song
Msgkey: 20130507061510134@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130507061510134@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <15709790.301941367908253064.JavaMail.weblogic@epml12>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+Zru68+R2BBiffilpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mfy3rGAsO6Fe0bXnH3MC4QK+LkZNDSEBFouX/d0YQW0LAROLD
	pNvsELaYxIV769kgapYxSqx7pwJTs29zN0sXIxdQfD6jRNuXj0wgCRagQZu+H2YFsdkEtCXe
	fnkAZgsL+EvM39wF1iAicJVJ4sqlBewQU+UlJp++DGbzCghKnJz5hAVig5LErVsHgTZzAMWV
	Ja5et4IIS0jMmn6BFcLmlZjR/hSqXE5i2tc1zBC2tMT5WRsYYR5Y/P0xVJxf4tjtHUwgI0F6
	n9wPhhmze/MXNghbQGLqmYNQreoSB/6shbL5JNYsfMsCM2bXqeXMML33t8wFe51ZQFFiSvdD
	dghbS+LLj31s6L7iFXCSOPunjxEUDBICEzkkzjx/wT6BUWkWkrpZSGbNQjILWc0CRpZVjKKp
	BckFxUnpRSZ6xYm5xaV56XrJ+bmbGCGJYcIOxnsHrA8xJgPjZCKzlGhyPjCx5JXEGxqbGVmY
	mpgaG5lbmpEmrCTOq95iHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBkX/Nww1nv/3J/eOx
	kiver+SHucnfhkUzX13PTvDd8K+yo0Bm1SfJyRX2j/fZHHY9t2ArW9CcpiMhyQ93T3ohLbP7
	0GlP0dOdzAV1z/mKZh7Pe796odRC9bqTSxW9l1jl5gZo5J4IvHzq7tSfgTXM587zPzSNjbjh
	u6nnx9c/Zk/far+YEV/ed0aJpTgj0VCLuag4EQBrZF4IIgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsVy+t/tGbrz5ncEGqx7KWhxedccNgdGj8+b
	5AIYozJsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaKNDIz1jExN9IyMDfRMDGKtDA0MjEyBqhIy
	Mv61rGMsOKBf0bblHXMD4wK9LkZODiEBFYmW/98ZQWwJAROJfZu7WSBsMYkL99azdTFyAdXM
	Z5Ro+/KRCSTBAtSw6fthVhCbTUBb4u2XB2C2sIC/xPzNXSwgDSICV5kkrlxawA6xQV5i8unL
	YDavgKDEyZlPoDYoSdy6dRBoAwdQXFni6nUriLCExKzpF1ghbF6JGe1PocrlJKZ9XcMMYUtL
	nJ+1gRHm0MXfH0PF+SWO3d7BBDISpPfJ/WCYMbs3f2GDsAUkpp45CNWqLnHgz1oom09izcK3
	LDBjdp1azgzTe3/LXLDXmQUUJaZ0P2SHsLUkvvzYx4buK14BJ4mzf/oYJzDKzkKSmoWkfRaS
	dmQ1CxhZVjGKphYkFxQnpVcY6hUn5haX5qXrJefnbmIEp6JnC3cwfjlvfYhRgINRiYdX4VR7
	oBBrYllxZe4hRgkOZiURXmntjkAh3pTEyqrUovz4otKc1OJDjMnASJvILCWanA9Mk3kl8YbG
	BsaGhpbmBqaGRhakCSuJ8z5ttQ4UEkhPLEnNTk0tSC2C2cLEwSnVwJggJcDkVusiVbJ0g3Di
	xh8FUsreDOkq8sbtH7a4vt94RX3fyjaf5ZpTzn6d3rXXVyiUISuLdeWDaY0ZH3Y5W3X/fjjZ
	K7jJfRljqMP7k5qCugzhS++fLr49Qcb/gUX+1WLh3hU+HrlLJD8peh9t6o67sctFafpE0XXP
	cyOXe9x5dnhTXt7cP0osxRmJhlrMRcWJAPhlpJ2JAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r476V2bM032524


Hello. I  tested with two patches.
The first one is thomas gleixner's patch. The patch is as follow.
This patch works well without any problem.

Index: linux-2.6/arch/mips/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/process.c
+++ linux-2.6/arch/mips/kernel/process.c
@@ -50,13 +50,18 @@ void arch_cpu_idle_dead(void)
 }
 #endif

-void arch_cpu_idle(void)
+static void smtc_idle_hook(void)
 {
 #ifdef CONFIG_MIPS_MT_SMTC
        extern void smtc_idle_loop_hook(void);
-
        smtc_idle_loop_hook();
 #endif
+}
+
+void arch_cpu_idle(void)
+{
+       local_irq_enable();
+       smtc_idle_hook();
        if (cpu_wait)
                (*cpu_wait)();
        else
--

The second one is david daney's patch.  The patch is as follow. 
arch/mips/kernel/genex.S | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
index ecb347c..57cda9a 100644
--- a/arch/mips/kernel/genex.S
+++ b/arch/mips/kernel/genex.S
@@ -132,12 +132,13 @@ LEAF(r4k_wait)
        .set    noreorder
        /* start of rollback region */
        LONG_L  t0, TI_FLAGS($28)
-       nop
        andi    t0, _TIF_NEED_RESCHED
        bnez    t0, 1f
         nop
-       nop
-       nop
+       /* Enable interrupts so WAIT will complete */
+       mfc0    t0, CP0_STATUS
+       ori     t0, ST0_IE
+       mtc0    t0, CP0_STATUS
        .set    mips3
        wait
        /* end of rollback region (the region size must be power of two) */

After apply this patch. I got two error message. 
The first one is as follow
[  124.661211] Checking for the daddi bug... no.
[  124.665737] ------------[ cut here ]------------
[  124.670187] WARNING: at kernel/cpu/idle.c:96 cpu_startup_entry+0x150/0x178()
[  124.677209] Modules linked in:
[  124.680251] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.9.0+ #40
[  124.686237] Stack : 0000000000000004 0000000000000034 ffffffff80fa0000 ffffffff80292558
          0000000000000000 ffffffff80fa0000 0000000000000001 ffffffff80293810
          0000000000000000 0000000000000000 ffffffff81080000 ffffffff81080000
          ffffffff80e2acf0 ffffffff80f8f977 ffffffff80f8fa80 ffffffff80e31730
          0000000000000001 0000000000000004 ffffffff00000000 0000000000000004
          ffffffffc05633f0 ffffffff806ef728 ffffffff80f57d08 ffffffff80290a74
          ffffffffc05633f0 ffffffff80293c40 000000000000003e ffffffff80e2acf0
          0000000000000000 ffffffff80f57c30 00ffffff80f8fdc0 ffffffff802908c0
          0000000000000000 0000000000000000 0000000000000000 0000000000000000
          0000000000000000 ffffffff80272498 0000000000000000 0000000000000000
          ...
[  124.751163] Call Trace:
[  124.753599] [<ffffffff80272498>] show_stack+0x68/0x80
[  124.758634] [<ffffffff802908c0>] warn_slowpath_common+0x78/0xa8
[  124.764533] [<ffffffff802d4448>] cpu_startup_entry+0x150/0x178
[  124.770351] [<ffffffff80fd6b04>] start_kernel+0x440/0x45c
[  124.775728]
[  124.777219] ---[ end trace 9179e654e5693e72 ]---

After boot process is done the follow error message is printed periodically.

[  284.751007] INFO: rcu_preempt detected stalls on CPUs/tasks: { 6} (detected by 1, t=14712 jiffies, g=18446744073709551344, c=18446744073709551343, q=2437)
[  284.764878] Task dump for CPU 6:
[  284.768105] swapper/6       R  running task        0     0      1 0x00100000
[  284.775174] Stack : 0000005311112000 ffffffff80f60000 ffffffff80f60000 a800000001d2d950
          0000000000000018 ffffffff81080000 ffffffff81080000 0000000000000000
          ffffffff81010000 ffffffff8030893c 4256e5715da6083d 800000040f800000
          0000000000000018 ffffffff81080000 ffffffff81080000 ffffffff80264f3c
          ffffffff80e31730 0000000000000000 ffffffff80e31730 ffffffff80f90000
          ffffffff80fd0000 ffffffff8026c760 0000000000000000 0000000010008ce1
          0000000000100000 a8000000414e4010 ffffffff80f8bb18 0000000000000000
          0000005311112000 0000000000000001 0000000000000001 0000000000000000
          ffffffff80f8bc58 a800000001d32c60 a8000000414e7fe0 0000000000008c00
          a80000003f7d8000 0000000000000000 ffffffff80fd0000 ffffffff80e31730
          ...
[  284.840704] Call Trace:
[  284.843153] [<ffffffff806f1a48>] __schedule+0x3b0/0x938
[  284.848377]


ThanksˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
