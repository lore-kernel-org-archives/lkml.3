Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762703Ab3ECHrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 03:47:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19212 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757537Ab3ECHra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 03:47:30 -0400
X-AuditID: cbfee68d-b7f016d000007930-df-51836b84c47d
Date: Fri, 03 May 2013 07:47:16 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: MIPS : die at free_initmem() function 3.9+
To: liuj97@gmail.com, "ralf@linux-mips.org" <ralf@linux-mips.org>
Cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jogo@openwrt.org, david.daney@cavium.com
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130503070831657@eunb.song
Msgkey: 20130503070831657@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130503070831657@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <31174990.226951367567235155.JavaMail.weblogic@epml13>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zpm5LdnOgwaoJZhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSujb/Z21oIWlYorz44xNTB2KHcxcnIICahItPz/ztjFyMEhIWAi
	MbtPCSQsISAmceHeerYuRi6gkmWMEo9n3mKBSJhIbH92mh0iMZ9RYvKDVUwgzSxAg25/yAap
	YRPQlnj75QEriC0sYCyx7vZ6MFtEwEPi57cfzCC9zAJbGCV2LF/KBnGEvMTk05fZQWxeAUGJ
	kzOfQC1TknjwqJkZIq4sMen5OjaIuITErOkXWCFsXokZ7U+h6uUkpn1dwwxhS0ucn7WBEeab
	xd8fQ8X5JY7d3sEE8TCvxJP7wTBjdm/+AjVeQGLqmYNQreoSZzbfZIKw+STWLHzLAjNm16nl
	zDC997fMBathFlCUmNL9kB3C1pL48mMfG7q3eAWcJK63vWedwKg8C0lqFpL2WUjakdUsYGRZ
	xSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRGSFnp3MN4+YH2IMRkYJROZpUST84FpJa8k3tDY
	zMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjN1C3O5eW2zm
	Xn+wJT/hwtIfTQeT5zso7Fp5ZZqjhp3SSTZdRaOPZxa+lAjdwCi0al+8PU+UVPreKxqtzgpx
	Uyf8j7xi2LCpiqn8QeneEO7CbT2h5jER1lu5y2UUznayx0+P/vtc+fSlX8f3ZSmuaBS2dDKP
	myXIuDqgsl5qio+xcv03zS1PlViKMxINtZiLihMB82IFjSEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e/2TN2W7OZAg6U3jSwu75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	Rt/s7awFLSoVV54dY2pg7FDuYuTkEBJQkWj5/50RxJYQMJHY/uw0O4QtJnHh3nq2LkYuoJr5
	jBKTH6xi6mLk4GABarj9IRukhk1AW+LtlwesILawgLHEutvrwWwRAQ+Jn99+MIP0MgtsYZTY
	sXwpG8QyeYnJpy+DLeAVEJQ4OfMJC8QyJYkHj5qZIeLKEpOer2ODiEtIzJp+gRXC5pWY0f4U
	ql5OYtrXNcwQtrTE+VkbGGGOXvz9MVScX+LY7R1gN4P0PrkfDDNm9+YvUOMFJKaeOQjVqi5x
	ZvNNJgibT2LNwrcsMGN2nVrODNN7f8tcsBpmAUWJKd0P2SFsLYkvP/axoXuLV8BJ4nrbe9YJ
	jHKzkKRmIWmfhaQdWc0CRpZVjKKpBckFxUnpFUZ6xYm5xaV56XrJ+bmbGMEp6tmiHYz/zlsf
	YhTgYFTi4VVoaQoUYk0sK67MPcQowcGsJMLr9gMoxJuSWFmVWpQfX1Sak1p8iDEZGIETmaVE
	k/OB6TOvJN7Q2MDY0NDS3MDU0MiCNGElcd5nrdaBQgLpiSWp2ampBalFMFuYODilGhi7/f+m
	7NSZp62k8Ej00PyE0xH1irLTPuksf7V5XrKg3FPdKx/CKtda79nufra9ZsOSr95X7tyffY2N
	Y+Y780nJ4QVfPwfeZ3DkulJhrdzFJRnRk76M6cnyM+bMRaydP4+K8P9ZEHRIWPJO9GkfKwvv
	FB7DEqPCmxuYLunu0mad/GlfyLIleRuVWIozEg21mIuKEwEAzjVUlQMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r437lbr3010226


Hello. I try to boot my cavium board with david's patch. 
It's is not applied yet in linux tree, i got the patch from mailing list.
And the patch is as follow.


This is only very lightly tested, we need more testing before
declaring it the definitive fix.

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

I think, it works well. But i encounter another problem at free_initmem(). 
The log messages are as follow.

[  132.134719] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.9.0+ #29
[  132.141678] Stack : 0000000000000004 000000000000003f ffffffff80fa0000 ffffffff802924a8
          0000000000000000 ffffffff80fa0000 00000000000000ff ffffffff80293760
          0000000000000000 0000000000000000 ffffffff81080000 ffffffff81080000
          ffffffff80e2baf0 ffffffff80f93977 a80000004146cbb8 0000000000000020
          0000000000000003 0000000000000020 a800000041473da8 ffffffff810f0000
          a800000041473a10 ffffffff806ef910 a800000041473828 ffffffff80290920
          0000000000000000 ffffffff80293b90 000000000000000a ffffffff80e2baf0
          0000000000000000 a800000041473750 000000004146cef8 ffffffff805e7794
          0000000000000000 0000000000000000 0000000000000000 0000000000000000
          0000000000000000 ffffffff80272498 0000000000000000 0000000000000000
          ...
[  132.207201] Call Trace:
[  132.209655] [<ffffffff80272498>] show_stack+0x68/0x80
[  132.225943] [<ffffffff802bd4ac>] notifier_call_chain+0x5c/0xa8
[  132.231776] [<ffffffff802bdb84>] __atomic_notifier_call_chain+0x3c/0x58
[  132.238391] [<ffffffff802bdbe8>] notify_die+0x38/0x48
[  132.243442] [<ffffffff802716cc>] die+0x4c/0x148
[  132.247974] [<ffffffff8027f998>] do_page_fault+0x4b8/0x500
[  132.253461] [<ffffffff8026c764>] resume_userspace_check+0x0/0x10
[  132.259469] [<ffffffff80324a54>] free_reserved_area+0x8c/0x178
[  132.265304] [<ffffffff806e0dc8>] kernel_init+0x20/0x100
[  132.270529] [<ffffffff8026c7e0>] ret_from_kernel_thread+0x10/0x18

And i just changed free_initmem() functions as follow

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 9b973e0..e246e9b 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -447,7 +447,10 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 void __init_refok free_initmem(void)
 {
        prom_free_prom_memory();
-       free_initmem_default(POISON_FREE_INITMEM);
+
+       free_init_pages("unused kernel memory",
+                       __pa_symbol(&__init_begin),
+                       __pa_symbol(&__init_end));
 }

After that it works well. but i don't know why it works well.

Thanks. ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
