Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3EEWjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 18:39:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41528 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3EEWjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 18:39:46 -0400
X-AuditID: cbfee691-b7fe56d000004b96-12-5186dfb03bad
Date: Sun, 05 May 2013 22:39:44 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: MIPS : die at free_initmem() function 3.9+
To: Jiang Liu <liuj97@gmail.com>
Cc: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jogo@openwrt.org" <jogo@openwrt.org>,
        "david.daney@cavium.com" <david.daney@cavium.com>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130505223519122@eunb.song
Msgkey: 20130505223519122@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130505223519122@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <21534601.395241367793582818.JavaMail.weblogic@epv6ml08>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zru6G+22BBjdeKlhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M83/vsRQ0sFe0713O0sD4hK2LkZNDSEBFouX/d0YQW0LARGLN
	0aVMELaYxIV764FquIBqljFKdGz4zA5TtKXvMitEYj6jxLbelawgCRagSS8XrAXrZhPQlnj7
	5QFYXFjAWmLjzQ3MILaIgJLEjHtHmECamQU6mSRen/vACnGGvMTk05fBNvAKCEqcnPmEBWKb
	ksSj13vYIOLKEvMetrBCxCUkZk2/AGXzSsxofwpVLycx7esaZghbWuL8rA2MMO8s/v4YKs4v
	cez2DqAjOMB6n9wPhhmze/MXNghbQGLqmYOMECXqEse+5UGE+STWLHzLAjNl16nlzDCt97fM
	BXudWUBRYkr3Q3YIW0viy499bKi+4gCyXSSmnlaYwKg8C0lmFpLuWUi6kdUsYGRZxSiaWpBc
	UJyUXmSqV5yYW1yal66XnJ+7iRGSFibuYLx/wPoQYzIwRiYyS4km5wPTSl5JvKGxmZGFqYmp
	sZG5pRlpwkrivOot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGOXM3PNfOAbkGSXzt9/U
	rknnz9Yo1Xx7JUNQWryof9otoz8H51gc9ekwuH2g2veB8Qm7mu6rExbL3Jz07OhCz6Ln8zeI
	vN0uLsX//qd+7OkJv/ct0t84N0Nk9q6V380v3/6kHO0X3PFq/62NDOsv92z5ItDAmbteT/BK
	WlzWlsUHZk1aGJlZxqbEUpyRaKjFXFScCAAKBLEeIQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2DN0N99sCDf4tlbO4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	Gef/3mMpaGCvaN+7nKWB8QlbFyMnh5CAikTL/++MILaEgInElr7LrBC2mMSFe+uBariAauYz
	SmzrXQmWYAFqeLlgLROIzSagLfH2ywOwuLCAtcTGmxuYQWwRASWJGfeOMIE0Mwt0Mkm8PveB
	FWKbvMTk05fZQWxeAUGJkzOfsEBsU5J49HoPG0RcWWLewxaoKyQkZk2/AGXzSsxofwpVLycx
	7esaZghbWuL8rA2MMFcv/v4YKs4vcez2DqAjOMB6n9wPhhmze/MXNghbQGLqmYOMECXqEse+
	5UGE+STWLHzLAjNl16nlzDCt97fMBXudWUBRYkr3Q3YIW0viy499bKi+4gCyXSSmnlaYwCg3
	C0lmFpLuWUi6kdUsYGRZxSiaWpBcUJyUXmGoV5yYW1yal66XnJ+7iRGcoJ4t3MH45bz1IUYB
	DkYlHt4bta2BQqyJZcWVuYcYJTiYlUR4ffa2BQrxpiRWVqUW5ccXleakFh9iTAbG30RmKdHk
	fGDyzCuJNzQ2MDY0tDQ3MDU0siBNWEmc92mrdaCQQHpiSWp2ampBahHMFiYOTqkGxlOzmVNe
	T7jxJ3uZbLfv3uKSeN7QnRnBmx7eyVv3YmH49fBuT8PuRVqOEjpB+XWGnEymNRsSZj080Frh
	JLjOhanfYmVWkdftBEulM/7zmnQ3VcnXqlSyll/1nleazHv9ezLvP6PCIrWjaWVhhus0K30c
	dd8ITNoyj22qpa6EHcuTrDjdDwlKLMUZiYZazEXFiQAQLbY8lAMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r45Mdwiv021165


>So on 64bits MIPS platforms, __va(__pa(x)) may not equal to x, that may cause
>trouble to free_initmem_default(). Could you please help to do another test
>by changing
>free_initmem_default(POISON_FREE_INITMEM);
>to
>free_initmem_default(0);

>This test could help to identify whether this panic is caused by
>memset((void *)pos, poison, PAGE_SIZE);
>in function free_reserved_area().

Hello, as you said i changed  "free_initmem_default(POISON_FREE_INITMEM);" to
"free_initmem_default(0);". Panic still occurred. 
Actually, i put the some debug messages. and i confirmed panic occurs in __free_reserved_page() function.
Thanks!

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
