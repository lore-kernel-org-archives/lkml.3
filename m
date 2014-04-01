Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaDAGFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 02:05:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31298 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaDAGFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 02:05:05 -0400
X-AuditID: cbfee68e-b7f566d000002344-10-533a56f34fc8
Date: Tue, 01 Apr 2014 06:04:35 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: tools/liblockdep: Build failure
To: ak@linux.intel.com, sasha.levin@oracle.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20140401060131636@eunb.song
Msgkey: 20140401060131636@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140401060131636@eunb.song
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <22212997.138341396332274687.JavaMail.weblogic@epml01>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsVy+t8zLd3PYVbBBgd3W1hc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXM+Piuk7lgnmDFndcGDYwPBLoYOTmEBFQkWv5/ZwSxJQRMJJ6/2sIK
	YYtJXLi3nq2LkQuoZhmjxMcHu9hhis7+m88MkZjPKLF0zW6wBAvQpA0T21hAbDYBbYkfB64y
	g9jCAhoS286dBouLCFhJ7H7xD2wDs4CjxKPLd5ghrpCXmHz6MtgcXgFBiZMzn7BALFOS6Fz5
	mhUiriwxbf8bqEslJGZNvwB1Ka/EjPanUPVyEtO+rmGGsKUlzs/awAjzzeLvj6Hi/BLHbu9g
	6mLkAOt9cj8YZszuzV/YIGwBialnDjJClKhLHPjuAhHmk1iz8C3UJkGJ09e6mWFa72+ZywTx
	laLElO6H7BC2lsSXH/vY0H3FK+AksXvRV9YJjMqzkKRmIWmfhaQdWc0CRpZVjKKpBckFxUnp
	RUbIcb2JEZIE+3Yw3jxgfYhxPyMwSiYyS4km5wPTaF5JvKGxmZGFqYmpsZG5pRmFwiamFhYm
	RlQRVhLnXfQwKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDI/dV3hjBcAbGnL2bxW4xGx17
	NKvwwJzH1x/J84df3G0W//T7VO15iRN4Zikd1fWQaksxnbriy4tNzYGn7Xbdj33A6vDQRqT6
	sdmyWulwp81ljzTXrpRuKd7w3c5d9yynxJltER8095YGs/00OuP+3D4gLpXNi7F+8cqWeLd3
	vqVO7E7p1ulCSizFGYmGWsxFxYkAhYjGz/UDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2DN3PYVbBBud+m1hc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jI/vOpkL5glW3Hlt0MD4QKCLkZNDSEBFouX/d0YQW0LAROLsv/nMELaYxIV769m6GLmAauYz
	Sixds5sdJMEC1LBhYhsLiM0moC3x48BVsAZhAQ2JbedOg8VFBKwkdr/4xwpiMws4Sjy6fIcZ
	Ypm8xOTTl8Hm8AoISpyc+YQFYpmSROfK16wQcWWJafvfQB0kITFr+gVWCJtXYkb7U6h6OYlp
	X9dAHSotcX7WBkaYoxd/fwwV55c4dnsHUxcjB1jvk/vBMGN2b/7CBmELSEw9c5ARokRd4sB3
	F4gwn8SahW+hNglKnL7WzQzTen/LXCaIrxQlpnQ/ZIewtSS+/NjHhu4rXgEnid2LvrJOYJSb
	hSQ1C0n7LCTtyGoWMLKsYhRNLUguKE5KrzDSK07MLS7NS9dLzs/dxAhOT88W7WD8d976EKMA
	B6MSD69FuWWwEGtiWXFl7iFGCQ5mJRHeI++BQrwpiZVVqUX58UWlOanFhxiTgfE3kVlKNDkf
	mDrzSuINjQ2MDQ0tzQ1MDY0sSBNWEueVv5UUJCSQnliSmp2aWpBaBLOFiYNTqoHxhIahae8j
	pTdrpDTjajTcu49JL+x8dqkm/CNboLZUndYMefslP6ZMFXm7nn3rve1znpkXyV+58eS4k1vp
	Y9d1LabuWuzCN3rcL38/GnffXNiA/2dR2+q1b57fdnbSrvDyLf5RkpzvWjJBQS7ohvCxX7ui
	HNvW/lrT8XL9/dTS6hUWUtFxV2cqsRRnJBpqMRcVJwIAeWHjn5MDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s31663q3032480


There is tools/liblockdep build failure.
I have been trying to find the cause and i found commit id 63f9a7fde715352e0769302527670542a664b981 is the casue.

Author: Andi Kleen <ak@linux.intel.com>
Date:   Sat Feb 8 08:52:01 2014 +0100

    asmlinkage: Make lockdep_sys_exit asmlinkage

    lockdep_sys_exit can be called from assembler code, so make it
    asmlinkage.

    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Ingo Molnar <mingo@kernel.org>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Link: http://lkml.kernel.org/r/1391845930-28580-5-git-send-email-ak@linux.intel.com
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 92b1bfc..7df9aa6 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -265,7 +265,7 @@ extern void lockdep_info(void);
 extern void lockdep_reset(void);
 extern void lockdep_reset_lock(struct lockdep_map *lock);
 extern void lockdep_free_key_range(void *start, unsigned long size);
-extern void lockdep_sys_exit(void);
+extern asmlinkage void lockdep_sys_exit(void);

 extern void lockdep_off(void);
 extern void lockdep_on(void);
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index eb8a547..c8b6753 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -4191,7 +4191,7 @@ void debug_show_held_locks(struct task_struct *task)
 }
 EXPORT_SYMBOL_GPL(debug_show_held_locks);

-void lockdep_sys_exit(void)
+asmlinkage void lockdep_sys_exit(void)
 {
        struct task_struct *curr = current;
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
