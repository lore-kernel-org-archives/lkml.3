Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab3DSJN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:13:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42788 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab3DSJN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:13:57 -0400
X-AuditID: cbfee690-b7f656d0000007e3-f9-51710ad34345
Date: Fri, 19 Apr 2013 09:13:55 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: [PATCH]  I2C: Change the value of octeon i2c adapter timeout
 value
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130419090739827@eunb.song
Msgkey: 20130419090739827@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130419090739827@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <33288064.110491366362833968.JavaMail.weblogic@epv6ml06>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Ztu5lrsJAg6Z5XBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSuj9chE5oIzLBWdzy+yNDDuYOli5OQQElCRaPn/nRHElhAwkbi2
	5yQrhC0mceHeerYuRi6gmmWMEr1XdrLCFL14MBMqMZ9Rou/zYrAEi4CqxPNF95lBbDYBbYm3
	Xx6AxYUFgiWWHN3NBGKLCKhJHLrdC2YzC9RIXN5+nRHiCnmJyacvs4PYvAKCEidnPmGBWKYk
	cfn8Mai4ssTxb51MEHEJiVnTL0AdxCsxo/0pVL2cxLSva5ghbGmJ87M2MMJ8s/j7Y6g4v8Sx
	2zuA5nCA9T65HwwzZvfmL2wQtoDE1DMHoVrVJXbPmQk1nk9izcK3LDBjdp1azgzTe3/LXKi3
	FCWmdD9kh7C1JL782MeG6i0OINtFYuVxuwmMyrOQZGYh6Z6FpBtZzQJGllWMoqkFyQXFSelF
	JnrFibnFpXnpesn5uZsYIWlhwg7GewesDzEmA2NkIrOUaHI+MK3klcQbGpsZWZiamBobmVua
	kSasJM6r3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoExfWHQ0t1XthW92b4s0eX5v7Pb
	1qlUnXq8irU4mTG4uOHIbx+Ov1dfz85z1bmgYnL2mKqtSPYhjb2bNpqWFZ68Xv98Vsysw0FT
	r5xhEwx0vDTh+ZUvBSVzPsm0yU2sc1JUM+AJyrZSPRm5+7G/o/vqLv0GgY22WjOS6yQ2Vpl4
	qrIrLuE71vhdiaU4I9FQi7moOBEA2aLLnyEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2TN3LXIWBBivOsVtc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jNYjE5kLzrBUdD6/yNLAuIOli5GTQ0hARaLl/3dGEFtCwETixYOZbBC2mMSFe+uBbC6gmvmM
	En2fF7OCJFgEVCWeL7rPDGKzCWhLvP3yACwuLBAsseTobiYQW0RATeLQ7V4wm1mgRuLy9uuM
	EMvkJSafvswOYvMKCEqcnPmEBWKZksTl88eg4soSx791MkHEJSRmTb/ACmHzSsxofwpVLycx
	7esaZghbWuL8rA2MMEcv/v4YKs4vcez2DqA5HGC9T+4Hw4zZvfkL1I8CElPPHIRqVZfYPWcm
	1Hg+iTUL37LAjNl1ajkzTO/9LXOh3lKUmNL9kB3C1pL48mMfG6q3OIBsF4mVx+0mMMrNQpKZ
	haR7FpJuZDULGFlWMYqmFiQXFCelVxjpFSfmFpfmpesl5+duYgQnqGeLdjD+O299iFGAg1GJ
	h/eGVEGgEGtiWXFl7iFGCQ5mJRHe6UlAId6UxMqq1KL8+KLSnNTiQ4zJwPibyCwlmpwPTJ55
	JfGGxgbGhoaW5gamhkYWpAkrifM+a7UOFBJITyxJzU5NLUgtgtnCxMEp1cBY9eZipP7mg0X/
	LqzKNjLVeiph7XaKa5eShuzM4/yHDn8rPKd6ut+dgVFokfcJ+TD9hACtDM+ugDmfvVMP1Jxz
	yF2wVcho0ak3x5X8XXMvpDVn+fqUKqxmV1zbVCr29oxGp4mPvZNO5Prjb1Y4bxJLWq25uMTg
	dObBeZ8mCU1a+uhus05owxclluKMREMt5qLiRAB72R9OlAMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3J9E4U1022512



On Fri, Apr 19, 2013 at 12:01:04AM +0000, EUNBONG SONG wrote:
>> 
>>  I think HZ/50 is better than 2 for adapter timeout.

> Basically OK. But why HZ/50? Most drivers use HZ.

Actually, I just translated 2 jiffies because HZ is 100 in default cavium config. 
You can find that in "arch/mips/configs/cavium_octeon_defconfig". 
And i have been using this value over 1 year in octeon board without problem.
Thanks. ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
