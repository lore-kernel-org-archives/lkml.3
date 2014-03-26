Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaCZIZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 04:25:34 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10918 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaCZIZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 04:25:31 -0400
X-AuditID: cbfee68e-b7f566d000002344-da-53328eebb2fc
Date: Wed, 26 Mar 2014 08:25:15 +0000 (GMT)
From: =?euc-kr?B?vcm1v8ij?= <dh.sim@samsung.com>
Subject: [PATCH] mkfs: fix wrong extension count
To: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-to: dh.sim@samsung.com
MIME-version: 1.0
X-MTR: 20140326081709799@dh.sim
Msgkey: 20140326081709799@dh.sim
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140326081709799@dh.sim
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <20209889.99741395822314289.JavaMail.weblogic@epv6ml05>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+Zvu7rPqNgg1k7pC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGmykmBZO4K3YceMPcwPiCq4uRk0NIQFHi1/NdzF2MHBwSAiYS
	/e+yQcISAmISF+6tZ+ti5AIqWcYoceLtQXaIhInEvoMTWSF65zNKnFnLB2KzCKhK3N4wnQ3E
	ZhMwlPiw8xkLiC0sYCDxd+prJhBbRKBK4tbGHhaIXhmJd1vPg83hFRCUODnzCQvEfHmJ2887
	oeIKErN2rmGDiEtIzJp+gRXC5pWY0f4Uql5OYtrXNcwQtrTE+VkbGGEeWPz9MVScX+LY7R1M
	ED/ySjy5HwwzZvfmL1DjBSSmnjnICFGiInHhZhhEmE9izcK3LDBTdp1azgzTen/LXLCvmIEh
	OKX7ITuErSXx5cc+NnRf8Qo4S/xbsIEdFJwSAp0cElNuvmKZwKg0C0ndLCSzZiGZhaxmASPL
	KkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYyQlNC3g/HmAetDjMnAKJnILCWanA9MKXkl8YbG
	ZkYWpiamxkbmlmakCSuJ8y56mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgdF9gr3Vu5tF
	V+ddrGOwXv55YdBv11m5T2QkzS5LKImquB1vtr8WcHD5+u75q3ev5e1I1WD3mvmC85jvTOXr
	T698rRK6pHLaxleO59rXfdmyWyJeFj0wf3Pvrqvwxz9nj0Rbhe3n+XJmg26TauWzS7VPVLic
	FywusF0mofLoPm/j3qyJRxtWLDZSYinOSDTUYi4qTgQAxkBbhB8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMKsWRmVeSWpSXmKPExsVy+t/tmbqv+4yCDdYslrC4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnrGlrFWhgYGRqZAVQkZ
	GW+mmBRM4q7YceANcwPjC64uRk4OIQFFiV/PdzGD2BICJhL7Dk5khbDFJC7cW88GUTOfUeLM
	Wj4Qm0VAVeL2hulgcTYBQ4kPO5+xgNjCAgYSf6e+ZgKxRQSqJG5t7GGB6JWReLf1PNhMXgFB
	iZMzn7BAzJeXuP28EyquIDFr5xo2iLiExKzpF6Bu4JWY0f4Uql5OYtrXNVB3Skucn7WBEebO
	xd8fQ8X5JY7d3gF0AwdY75P7wTBjdm/+AjVeQGLqmYOMECUqEhduhkGE+STWLHzLAjNl16nl
	zDCt97fMBfuKGRhSU7ofskPYWhJffuxjQ/cVr4CzxL8FG9gnMMrOQpKahaR9FpJ2ZDULGFlW
	MYqmFiQXFCelVxjqFSfmFpfmpesl5+duYgQnoWcLdzB+OW99iFGAg1GJh9eizzBYiDWxrLgy
	9xCjBAezkghvcLNRsBBvSmJlVWpRfnxRaU5q8SHGZGCcTWSWEk3OBybIvJJ4Q2NjEzMTU3MD
	CwNLc9KElcR5795MChISSE8sSc1OTS1ILYLZwsTBKdXAuJcxeaao6Va91/9e1Bxb4OaukZW2
	OPr4+W+N8WrtzVzbBHKLJ5fayd93Zlj25udjTQsuudZ3kwOu1JxJuCoz+5zDxky2z/+Ptv7w
	jzjPebt4QYTUh9DsA6vce06+9LdcLKN47EFazZSttidetkWY7XY2qU/dsev85iXKe18ktvAp
	sYvvTo8VUWIpzkg01GIuKk4EAG1VjlOGAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2Q8Prh7027939

fix an bug related to extension list.
there was the potential bug in set_cold_files function, namei.c.

Signed-off-by: Dongho Sim <dh.sim@samsung.com>
---
 mkfs/f2fs_format.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mkfs/f2fs_format.c b/mkfs/f2fs_format.c
index 9dbdc1d..d485808 100644
--- a/mkfs/f2fs_format.c
+++ b/mkfs/f2fs_format.c
@@ -154,7 +154,7 @@ static void configure_extension_list(void)
 		memcpy(super_block.extension_list[i++], *extlist, name_len);
 		extlist++;
 	}
-	super_block.extension_count = i - 1;
+	super_block.extension_count = i;
 
 	if (!ext_str)
 		return;
@@ -165,11 +165,11 @@ static void configure_extension_list(void)
 		name_len = strlen(ue);
 		memcpy(super_block.extension_list[i++], ue, name_len);
 		ue = strtok(NULL, ",");
-		if (i > F2FS_MAX_EXTENSION)
+		if (i >= F2FS_MAX_EXTENSION)
 			break;
 	}
 
-	super_block.extension_count = i - 1;
+	super_block.extension_count = i;
 
 	free(config.extension_list);
 }
-- 
1.7.9.5

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
