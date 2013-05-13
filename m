Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab3EMBQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 21:16:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59679 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab3EMBQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 21:16:57 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-8f-51903f076a74
Date: Mon, 13 May 2013 01:16:55 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: [PATCH] mips: fix build error for crash_dump.c in 3.10-rc1
To: "ralf@linux-mips.org" <ralf@linux-mips.org>
Cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130513011509329@eunb.song
Msgkey: 20130513011509329@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130513011509329@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <175967.10981368407814645.JavaMail.weblogic@epml07>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+Zri67/YRAg9+XjSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGtAkyBQs4K5r/cDUw/uHoYuTkEBJQkWj5/50RxJYQMJHYs+ga
	G4QtJnHh3nogmwuoZhmjxORz5+CK/i+ZxgLRPJ9R4urlYBCbRUBVouvsSbA4m4C2xNsvD1hB
	bGEBZ4neB+eYQGwRAX2J/+fesoPYzAI1Et1/FzNCzJGXmHz6MlicV0BQ4uTMJywQu5Qkru9/
	wAIRV5ZYur6dGSIuITFr+gVWCJtXYkb7U6h6OYlpX9dA1UhLnJ+1gRHmmcXfH0PF+SWO3d4B
	dA8HWO+T+8EwY3Zv/gL1u4DE1DMHoVrVJdpvTISy+STWLHzLAjNm16nlzDC997fMZYJ4S1Fi
	SvdDqBe1JL782MeG6i0OINte4s2qmAmMyrOQZGYh6Z6FpBtZzQJGllWMoqkFyQXFSelFhnrF
	ibnFpXnpesn5uZsYIQmhdwfj7QPWhxiTgTEykVlKNDkfmFDySuINjc2MLExNTI2NzC3NSBNW
	EudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBYu+OElZJ1vv29X8vsTS55lvTMr7Sd
	lnRplehTuynn9qu5Piqbo5X8YuORa/Wuk9L5gzvCrOMEb/rqqL9yavmSOFeAPXv1HgUtr6O2
	m/V88l/xrWE6vFRo4vS/bdICYeUfrfpitGbG6ihsjyy7dJ7rzLGr5YvPHUhUriy87bW70SjB
	2voJ03slluKMREMt5qLiRACIm6MbHgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t/t6brs9hMCDf7OMLC4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GdMmyBQs4Kxo/sPVwPiHo4uRk0NIQEWi5f93RhBbQsBE4v+SaSwQtpjEhXvr2SBq5jNKXL0c
	DGKzCKhKdJ09CVbDJqAt8fbLA1YQW1jAWaL3wTkmEFtEQF/i/7m37CA2s0CNRPffxYwQc+Ql
	Jp++DBbnFRCUODnzCdQuJYnr+x+wQMSVJZaub2eGiEtIzJp+gRXC5pWY0f4Uql5OYtrXNVA1
	0hLnZ21ghLl58ffHUHF+iWO3dwDdwwHW++R+MMyY3Zu/sEHYAhJTzxyEalWXaL8xEcrmk1iz
	8C0LzJhdp5Yzw/Te3zKXCeItRYkp3Q+hXtSS+PJjHxuqtziAbHuJN6tiJjDKzUKSmYWkexaS
	bmQ1CxhZVjGKphYkFxQnpVeY6BUn5haX5qXrJefnbmIEp6ZnS3YwNlywPsQowMGoxMO7QHlC
	oBBrYllxZe4hRgkOZiURXjcGoBBvSmJlVWpRfnxRaU5q8SHGZGD8TWSWEk3OB6bNvJJ4Q2MD
	Y0NDS3MDU0MjC9KElcR5n7VaBwoJpCeWpGanphakFsFsYeLglGpgDJvflPC1P8PintB5F4W/
	bjs2P81s3+/Ok5V9ti56YlvxmZcLL/05o1e3ZiqXreHHmeLZiSzpjS5r7p6KX6xywSBVLS7+
	/o9i58Vrsy34mRN9NTZX/AppX3fqo6G/f1ucaOjcuDBmid+lRwJrinM5/p84JPuWqTDmU6VN
	z45jhw9rdhcFzzylxFKckWioxVxUnAgAjnMP0JEDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4D1HSqR030649


This patch fixes crash_dump.c build error. Build error logs are as follow.

arch/mips/kernel/crash_dump.c: In function 'kdump_buf_page_init':
arch/mips/kernel/crash_dump.c:67: error: implicit declaration of function 'kmalloc'
arch/mips/kernel/crash_dump.c:67: error: assignment makes pointer from integer without a cast

Signed-off-by: EunBong Song <eunb.song@samsung.com>
---
 arch/mips/kernel/crash_dump.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/crash_dump.c b/arch/mips/kernel/crash_dump.c
index 35bed0d..3be9e7b 100644
--- a/arch/mips/kernel/crash_dump.c
+++ b/arch/mips/kernel/crash_dump.c
@@ -2,6 +2,7 @@
 #include <linux/bootmem.h>
 #include <linux/crash_dump.h>
 #include <asm/uaccess.h>
+#include <linux/slab.h>
 
 static int __init parse_savemaxmem(char *p)
 {
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
