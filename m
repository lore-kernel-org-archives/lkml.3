Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab3EBK7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:59:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9285 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3EBK7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:59:40 -0400
X-AuditID: cbfee68d-b7f016d000007930-de-5182471ac8cb
Date: Thu, 02 May 2013 10:59:38 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: mips; boot fail after merge 3.9+
To: Thomas Gleixner <tglx@linutronix.de>, Jonas Gorski <jogo@openwrt.org>
Cc: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130502105641445@eunb.song
Msgkey: 20130502105641445@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130502105641445@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <8122455.200971367492376044.JavaMail.weblogic@epml20>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+Ztq6Ue1OgwZRdvBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStjX8c3xoJZbBWbt25jamBsYOti5OQQElCRaPn/nRHElhAwkfjw
	5Q8zhC0mceHeeqAaLqCaZYwSd7sXs8AU/XpwigUiMZ9RYtfKtWAdLECTnu1cBFbEJqAt8fbL
	A1YQW1jAUGLzpz9MILaIgL/EzaZd7CDNzAKrGSXebO5jhThDXmLy6cvsIDavgKDEyZlPoLYp
	SfQvu8cIEVeWuHpuBxNEXEJi1vQLrBA2r8SM9qdQ9XIS076ugXpBWuL8rA2MMO8s/v4YKs4v
	cew2yBwOsN4n94Nhxuze/IUNwhaQmHrmICNEibrE7AdVEGE+iTUL37LATNl1ajkzTOv9LXPB
	LmMWUJSY0v2QHcLWkvjyYx8buq94BRwl9nS/Y5vAqDwLSWoWkvZZSNqR1SxgZFnFKJpakFxQ
	nJReZKhXnJhbXJqXrpecn7uJEZIYencw3j5gfYgxGRglE5mlRJPzgYklryTe0NjMyMLUxNTY
	yNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MvU2lYT9ETuyVkNtZLV9r
	w5e6bzrXiwVSB0UkFk1YVbeuVES5VG3KEoZJz3+sLucLmNIeUvki+ciUFWrBmzc1r9qgK655
	j1khxVGnZVLSxzkLpZcUpXyNV9C2Mrw3I+UQs25H8/WnAiu+fZNd7mm9yZ6Xe/3C5JOvnv67
	nrzkRuTEHYJlV+4cV2Ipzkg01GIuKk4EADi15xUiAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e/2TF0p96ZAgz3fuSwu75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xr6Ob4wFs9gqNm/dxtTA2MDWxcjJISSgItHy/zsjiC0hYCLx68EpFghbTOLCvfVANVxANfMZ
	JXatXMsMkmABani2cxFYEZuAtsTbLw9YQWxhAUOJzZ/+MIHYIgL+EjebdrGDNDMLrGaUeLO5
	jxVim7zE5NOX2UFsXgFBiZMzn0BtU5LoX3aPESKuLHH13A4miLiExKzpF1ghbF6JGe1Poerl
	JKZ9XcMMYUtLnJ+1gRHm6sXfH0PF+SWO3QaZwwHW++R+MMyY3Zu/sEHYAhJTzxxkhChRl5j9
	oAoizCexZuFbFpgpu04tZ4Zpvb9lLthlzAKKElO6H7JD2FoSX37sY0P3Fa+Ao8Se7ndsExjl
	ZiFJzULSPgtJO7KaBYwsqxhFUwuSC4qT0iuM9IoTc4tL89L1kvNzNzGCU9SzRTsY/523PsQo
	wMGoxMP7QbcxUIg1say4MvcQowQHs5II70uzpkAh3pTEyqrUovz4otKc1OJDjMnACJzILCWa
	nA9Mn3kl8YbGBsaGhpbmBqaGRhakCSuJ8z5rtQ4UEkhPLEnNTk0tSC2C2cLEwSnVwBj4vKio
	KvbUuSXm7x6Hsc2s1ezc9TJgof2an4tD1mscXjSB31W9pWL243RW9m87vr9Wfjehc8YRwav+
	sc18xefCY9/9f7PEKKn6t47FHQ6eWUdnVz588k54+svb4TPtZ0zbY5Mvpvl89Y47Io9nHg59
	v3VN8dewngULI/z/HZ1V1BrwPbQlQp1biaU4I9FQi7moOBEAjYIyKJUDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r42Axl9H003571


> Does the patch below fix your issue ?

I applied your patch, but it still fails to boot. the boot logs are same. 

Thanks

> Thanks,

> tglx

> diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
> index 8b86c0c..a8972fe 100644
> --- a/kernel/cpu/idle.c
> +++ b/kernel/cpu/idle.c
> @@ -70,8 +70,10 @@ static void cpu_idle_loop(void)
> check_pgt_cache();
> rmb();

> - if (cpu_is_offline(smp_processor_id()))
> + if (cpu_is_offline(smp_processor_id())) {
> arch_cpu_idle_dead();
> + continue;
> + }

> local_irq_disable();
> arch_cpu_idle_enter();ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
