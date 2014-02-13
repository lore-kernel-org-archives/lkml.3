Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaBMF7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 00:59:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18341 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaBMF7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 00:59:09 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-7c-52fc5f2c21d5
Date: Thu, 13 Feb 2014 05:59:08 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: [x86 question] invalid conversion of bootloader_type and
 bootloader_version ??
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20140213055825832@jongman.heo
Msgkey: 20140213055825832@jongman.heo
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140213053307038@jongman.heo
X-ParentMTR: 20140213055644340@jongman.heo
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <16419793.126861392271147946.JavaMail.weblogic@epv6ml15>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42JZI2JSrKsT/yfIoPcyh8XlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mp4/VGy4Apnxd2lKxgbGDdwdjFycggJqEnc/HyIEcSWEDCRuHBx
	LpQtJnHh3nq2LkYuoJqljBKzT12FKzr4upMRIjGfUeLnlwXMIAkWAVWJh2ses4DYbAI6Eh3/
	97OC2MIC4RLHNu9mB7FFBBwldhz8ygaxWVHi2tLFYDavgKDEyZlPWCAWqEjcnLEBKq4q8eLK
	MlaIuLjEhbmX2CFsXokZ7U+h6uUkpn1dwwxhS0ucn7UB7oPF3x9Dxfkljt3ewdTFyAHW++R+
	MMyY3Zu/sEHYAhJTzxyEatWUuP5sPtRabYk5S9+wwozZdWo5M0zv/S1zmUBsZqBXpnQ/ZAcZ
	zwzUu36XPrqveAVcJA5vamAFBZuEwEQOid6FM5knMCrNQlI3C8moWQijkJUsYGRZxSiaWpBc
	UJyUXmSqV5yYW1yal66XnJ+7iRGYFE7/ezZxB+P9A9aHGJOBMTKRWUo0OR+YVPJK4g2NzYws
	TE1MjY3MLc1IE1YS501/lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbFa/7vcv96N1dq2
	ge1ZOgsm3gqff1hdir+wXWPa6ea+HT+aDhvtX2fwYUW9vtm+wl1XA48fvLfxg1vJFFa2N//b
	BF8+tQv95Lh6natt5C6z7/r7BK0dLbn0biWbewvEK7488OwS/5t0laTvBqKGu7fHPBJdf56d
	yd9B59KWYucIvYSTphEJPkosxRmJhlrMRcWJAJEUo5cgAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsVy+t/tmbo68X+CDBrXMFpc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIzX
	HyULrnBW3F26grGBcQNnFyMnh5CAmsTNz4cYQWwJAROJg687oWwxiQv31rN1MXIB1cxnlPj5
	ZQEzSIJFQFXi4ZrHLCA2m4CORMf//awgtrBAuMSxzbvZQWwRAUeJHQe/skEsUJS4tnQxmM0r
	IChxcuYTFogFKhI3Z2yAiqtKvLiyjBUiLi5xYe4ldgibV2JG+1OoejmJaV/XMEPY0hLnZ22A
	O3Tx98dQcX6JY7d3MHUxcoD1PrkfDDNm9+YvbBC2gMTUMwehWjUlrj+bD7VWW2LO0jesMGN2
	nVrODNN7f8tcJhCbGeiVKd0P2UHGMwP1rt+lj+4rXgEXicObGlgnMMrOQpKahaR7FkI3spIF
	jCyrGEVTC5ILipPSK4z1ihNzi0vz0vWS83M3MYIT0LPFOxj/n7c+xCjAwajEw/tg8e8gIdbE
	suLK3EOMEhzMSiK8MhJ/goR4UxIrq1KL8uOLSnNSiw8xJgOjbCKzlGhyPjA55pXEGxobm5iZ
	mFqaWBiYmpMmrCTOG38rKUhIID2xJDU7NbUgtQhmCxMHp1QD4yT56A2vPyhfq6hcH7wnet3m
	kMhZ9RwsLRKz03ao/Hf8erX0auhHR4s/hx99F/nbyLS69eSd8r/v161I4tz5qKIroONxvZtT
	++GNrtFXtiz84nvnPoOK4qyDRxv5J7/ev0h0vyyH8p9JuZFRy7InvWt9efDlVsXmD/+ENhaH
	Ha42Ny5cwnJz6mklluKMREMt5qLiRAAYNKiChAMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1D5xFhk025134


Hi, all,

While looking at x86 boot code (arch/x86/kernel/setup.c), I got confused due to bootloader_type and bootloader_version conversion.

I've only checked GRUB and U-Boot bootloader code.

1. GRUB 2
    type_of_loader setting = 0x72
-> bootloader_type = 0x72, bootloader_version = 0x2

2. U-Boot
    type_of_loader setting = 0x8
-> bootloader_type = 0x8, bootloader_version = 0x8

3. example in Documentation/x86/boot.txt
    type_of_loader  = 0xE4, ext_loader_type = 0x05, ext_loader_ver = 0x23, for T = 0x15, V = 0x234
-> bootloader_type = 0x154, bootloader_version = 0x234

So, for GRUB 2 and the example bootloader, T != bootloader_type. 
Is this intended?
First I thought that bootloader_type and bootloader_version should match with T and V configured in the bootloader. 

This would not bring any real world issue, but I'm just curious.

Regards,
Jongman Heo.
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
