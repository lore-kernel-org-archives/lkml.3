Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab3EGXM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:12:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49406 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3EGXM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:12:26 -0400
X-AuditID: cbfee691-b7fe56d000004b96-e8-51898a595269
Date: Tue, 07 May 2013 23:12:25 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: MIPS: Test reault for  enable interrupts before WAIT
 instruction patch
To: David Daney <ddaney@caviumnetworks.com>
Cc: "david.daney@cavium.com" <david.daney@cavium.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "jogo@openwrt.org" <jogo@openwrt.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "manuel.lauss@gmail.com" <manuel.lauss@gmail.com>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130507230831915@eunb.song
Msgkey: 20130507230831915@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130507230831915@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <28076857.501501367968343732.JavaMail.weblogic@epv6ml01>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zrm5kV2egwfOH0haXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj0QSfgj6Wiv/vbrE2MP5h7mLk5BASUJFo+f+dEcSWEDCRmD7x
	PyuELSZx4d56ti5GLqCaZYwS+9cfYIYpanr4ih2ieT6jxOlFcSA2C9CgLQvawQaxCWhLvP3y
	AGyQsEC4xONFU5hAbBEBXYmW922MIEOZBV4zSaxv2c4CMUheYvLpy2BDeQUEJU7OfMICsUxJ
	4uLOL2wQcWWJjoZXTBBxCYlZ0y9AXcorMaP9KVS9nMS0r2ugDpWWOD9rAyPMN4u/P4aK80sc
	u70DaA4HWO+T+8EwY3ZvhlglISAgMfXMQahWdYkvr1rYIWw+iTUL37LAjNl1ajkzTO/9LXPB
	TmMWUJSY0v2QHcLWkvjyYx8burd4BVwkJpztYJnAqDwLSWoWkvZZSNqR1SxgZFnFKJpakFxQ
	nJReZKpXnJhbXJqXrpecn7uJEZIWJu5gvH/A+hBjMjBOJjJLiSbnA9NKXkm8obGZkYWpiamx
	kbmlGWnCSuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY08z7S+aXTl/XwKo4xe5Q
	RvGnPqbIdIuN1v6ZHI+Phsq8eCVzJHF9hMWyGb8ctxSt+T+tbvM5TdHYBtX5+6btE/wYOSkx
	OP/KyXWscueun4tIXy9V7aI8/X7793XFVR0OWXPlI0903bb6+NfctHXPxzVFC0XLrtTOV1x8
	MLV34sulIX6X3EznKLEUZyQaajEXFScCABD0l2shAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2dN3Irs5Ag/bNkhaXd81hc2D0+LxJ
	LoAxKsMmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2io
	kkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKdrIwFjPyNREz8jYQM/EINbK0MDAyBSoKiEj
	49EEn4I+lor/726xNjD+Ye5i5OQQElCRaPn/nRHElhAwkWh6+IodwhaTuHBvPRtEzXxGidOL
	4kBsFqD6LQvawerZBLQl3n55wApiCwuESzxeNIUJxBYR0JVoed8GVMPFwSzwmklifct2FohB
	8hKTT18GW8ArIChxcuYTFohlShIXd35hg4grS3Q0vGKCiEtIzJp+gRXC5pWY0f4Uql5OYtrX
	NcwQtrTE+VkbGGGOXvz9MVScX+LY7R1AczjAep/cD4YZs3szxCoJAQGJqWcOQrWqS3x51QL1
	O5/EmoVvWWDG7Dq1nBmm9/6WuWCnMQsoSkzpfsgOYWtJfPmxjw3dW7wCLhITznawTGCUm4Uk
	NQtJ+ywk7chqFjCyrGIUTS1ILihOSq8w0itOzC0uzUvXS87P3cQITlDPFu1g/Hfe+hCjAAej
	Eg+vBXdnoBBrYllxZe4hRgkOZiUR3rICoBBvSmJlVWpRfnxRaU5q8SHGZGAMTmSWEk3OBybP
	vJJ4Q2MDY0NDS3MDU0MjC9KElcR5n7VaBwoJpCeWpGanphakFsFsYeLglGpg5PvWaWkit12f
	selvh+uK+Te5FPh9+hY+XHM8NiTAKGTqx4Ajf5dsFfav7rf9lXVzk5LAvVUHNqz6rZC0XU7r
	pt9J89OF3U53Pa2WW7YpXKhYtGD63ylmfy6aLRCzb08wLJtdWMvwsn7BkvlPk++phyTLax6p
	WMfOsVekhpWPUeL6mpJ6+ytMSizFGYmGWsxFxYkAklSOi5QDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r47NCXHb006006



>> 
>> Hello. I  tested with two patches.
>> The first one is thomas gleixner's patch. The patch is as follow.
>> This patch works well without any problem.

>You don't need them both.  When we fix it, it will be one or the other,
>not both.

Hello. David.
Maybe i didn't write clearly for test result. I meant i applied only one patche for each test.

Thanks. 

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
