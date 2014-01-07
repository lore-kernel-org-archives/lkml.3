Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaAGFvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 00:51:22 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:27161 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaAGFvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 00:51:21 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-37-52cb95d709eb
Date: Tue, 07 Jan 2014 05:51:19 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v3] extcon: gpio: Add power resume support
To: RongJun Ying <rjying@gmail.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        Barry Song <Barry.Song@csr.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Workgroup.linux@csr.com" <Workgroup.linux@csr.com>,
        Rongjun Ying <rongjun.ying@csr.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140107055052035@myungjoo.ham
Msgkey: 20140107055052035@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140107055052035@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <1233289.652191389073877751.JavaMail.weblogic@epml01>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42JZI2JSrHt96ukgg5s7FCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGzmsbWQtesFXcfnOUsYHxDFsXIyeHkIC6xKIlJ8FsCQETiQub
	DkDZYhIX7q0HsrmAapYySmy+c4K1i5EDrKjjoS1EfD6jRNf0LWANLAIqEvd67jOC1LAJ6EnM
	/JwMEhYWsJNovfifHaReRKCdUaJh+Wkwh1ngE6NE5/cmqCuUJNbse8UCYvMKCEqcnPmEBeIK
	VYm+6TcYIeJqEn8m3WGCiEtIzJp+gRXC5pWY0f4Uql5OYtrXNcwQtrTE+VkbGGG+Wfz9MVSc
	X+LY7R1MEM/wSjy5HwwzZvfmL1DPC0hMPXMQqlVLYtq0zVDj+STWLHzLAjNm16nlzDC997fM
	BTuNWUBRYkr3Q3YIW0viy499bKje4gCyHSV2LFWewKg8C0lmFpLuWUi6kdUsYGRZxSiaWpBc
	UJyUXmSoV5yYW1yal66XnJ+7iRGYFk7/e9a7g/H2AetDjMnAKJnILCWanA9MK3kl8YbGZkYW
	piamxkbmlmakCSuJ8yY9TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwHhkhrR5RlrE7egO
	axnup4q7Ny989E0vbLOn+rOz/7IPL97BLqh5/E3Y1z2Hti9Y/3TLkUtPpcOfzm1pOefjNXnh
	jpW6B1O8n7+qZLe/rN9ryukhoXmPMUXqX9h71XPKgrUiVQ9LHre7rPOY1vBzU1t/zpMjJ+bP
	/x6yt7U5K5q/6Pz0dt49TzqUWIozEg21mIuKEwGBAclEIQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsVy+t/t6brXp54OMjixSdLi8q45bA6MHp83
	yQUwRqXZZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAN
	VVIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKkUbmhvpGRnomRrpGRrHWhkaGBiZAtUkpGXs
	vLaRteAFW8XtN0cZGxjPsHUxcnIICahLLFpyEsjm4JAQMJHoeGgLEpYQEJO4cG89UJgLqGQ+
	o0TX9C1g9SwCKhL3eu4zgtSzCehJzPycDBIWFrCTaL34nx2kXkSgnVGiYflpMIdZ4BOjROf3
	JqhlShJr9r1iAbF5BQQlTs58wgKxTVWib/oNRoi4msSfSXeYIOISErOmX2CFsHklZrQ/haqX
	k5j2dQ0zhC0tcX7WBkaYqxd/fwwV55c4dnsHE8RjvBJP7gfDjNm9+QsbhC0gMfXMQahWLYlp
	0zZDjeeTWLPwLQvMmF2nljPD9N7fMhfsNGYBRYkp3Q/ZIWwtiS8/9rGheosDyHaU2LFUeQKj
	3CwkmVlIumch6UZWs4CRZRWjaGpBckFxUnqFkV5xYm5xaV66XnJ+7iZGcHJ6tmgH47/z1ocY
	BTgYlXh4J+w+FSTEmlhWXJl7iFGCg1lJhFcz5XSQEG9KYmVValF+fFFpTmrxIcZkYAROZJYS
	Tc4HJs68knhDY2MTMxNTSxMLA1Nz0oSVxHnlbyUFCQmkJ5akZqemFqQWwWxh4uCUamBsDK0+
	Irg2RPrLiXPnsiUiSqI8NH6yJlXuehCz+hKPmVfNJd5TZYsm6XBpNq9o104UYPI3cDA9Kcnz
	cqlfX/GMaR/N3vPI737ibff2wrmqtAMHyjU+z3FMindJfdmwSVVK3bh/9XyrFC9phZVqzaxs
	rVefKiQFzVsz0VPn7qLgO6tcDhfN5VFiKc5INNRiLipOBADPl/ZGkgMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s075prGd016105

> From: Rongjun Ying <rongjun.ying@csr.com>
> 
> When system on the suspend state, Some SoC can't get gpio interrupt.
> After system resume, need send extcon uevent to userspace.
> 
> Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
> Reviewed-by: Barry Song <Baohua.Song@csr.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Thanks!

> ---
>  -v3:
>  'check_on_resume' instead of 'load_sleep_irq' as Chanwoo Choi's proposal.
> 
>  drivers/extcon/extcon-gpio.c       |   20 ++++++++++++++++++++
>  include/linux/extcon/extcon-gpio.h |    1 +
>  2 files changed, 21 insertions(+), 0 deletions(-)
>  
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
