Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaEWEww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 00:52:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10271 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaEWEwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 00:52:51 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-1d-537ed41d8ec1
Date: Fri, 23 May 2014 04:52:45 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] PM / devfreq: remove checks for CONFIG_EXYNOS_ASV
To: Paul Bolle <pebolle@tiscali.nl>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        =?euc-kr?Q?=B1=E8=B1=B9=C1=F8?= <kgene.kim@samsung.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140523045221440@myungjoo.ham
Msgkey: 20140523045221440@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140523045221440@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <7638065.14871400820762911.JavaMail.weblogic@epml08>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42JZI2JSoCt7pS7YYPdFPovLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJXRPuEGc8E7vopl3Y+YGxh38HUxcnIICahLLFpykg3ElhAwkbhy
	4gULhC0mceHeejaImqWMEhv/WcLUnHv1FqiGCyg+h1FiWts01i5GDg4WAVWJyZ0JICabgJ7E
	zM/JIOXCAm4Sl7evYgYpFxFYzCjx5NBPdhCHWWAak8SDpdeZIRYoSazZ9wpsMa+AoMTJmU+g
	jlCV6LvRxw4ylFdATaJjmiBEWEJi1vQLrBA2r8SM9qdQ5XIS076uYYawpSXOz9rACPPL4u+P
	oeL8Esdu72ACGQnS++R+MMyY3Zu/QINBQGLqmYNQrVoShxbuY4Kw+STWLHzLAjNm16nlzDC9
	97fMBathFlCUmNL9kB3C1pL48mMfG7qveAUcJJav2sY+gVF5FpLULCTts5C0I6tZwMiyilE0
	tSC5oDgpvchIrzgxt7g0L10vOT93EyMwKZz+96xvB+PNA9aHGJOBMTKRWUo0OR+YVPJK4g2N
	zYwsTE1MjY3MLc1IE1YS5130MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2O6hyjHofiS
	N7t5zk1NXfX49dEerv7NBUdmhDRHl+x1zveeL35w9ffXeq5NxaJ7rkrXO1fPUVx9rNVb0fOt
	1MqvZj7PjhSEfEy2bpuspcC7fe+h9oqfm+3yxMXetW7fqVkna8uXuOij5/E1Mg/3Ly7aeWua
	3cnVcw+/3xziv9l7Rdnj3yWNgmVKLMUZiYZazEXFiQAcbvtqIAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsVy+t/tXl3ZK3XBBoeOs1tc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIz2
	CTeYC97xVSzrfsTcwLiDr4uRk0NIQF1i0ZKTbCC2hICJxLlXb1kgbDGJC/fWA8W5gGrmMEpM
	a5vG2sXIwcEioCoxuTMBxGQT0JOY+TkZpFxYwE3i8vZVzCDlIgKLGSWeHPrJDuIwC0xjkniw
	9DozxDIliTX7XoEt4BUQlDg58wnUMlWJvht97CBDeQXUJDqmCUKEJSRmTb/ACmHzSsxofwpV
	Licx7esaZghbWuL8rA2MMDcv/v4YKs4vcez2DiaQkSC9T+4Hw4zZvfkL1LsCElPPHIRq1ZI4
	tHAfE4TNJ7FmISwY+CV2nVrODNN7f8tcsBpmAUWJKd0P2SFsLYkvP/axofuKV8BBYvmqbewT
	GOVmIUnNQtI+C0k7spoFjCyrGEVTC5ILipPSK0z0ihNzi0vz0vWS83M3MYKT07MlOxgbLlgf
	YhTgYFTi4X3AVBcsxJpYVlyZe4hRgoNZSYTXJxQoxJuSWFmVWpQfX1Sak1p8iDEZGH8TmaVE
	k/OBiTOvJN7Q2NjEzMTU0sTCwNScNGElcd4Ft5KChATSE0tSs1NTC1KLYLYwcXBKNTBucrjE
	Ln868Out0mnnOjdwbWe4fepxc1FjQl+iY7vkMSGtX7ei1wRWa/TMnfS0yNO2OGwP2+YpekWy
	hpdaJk5Ruqa4SWP7VuP/NxIilsQLMOcaXFvhunDJW/2AmbYf7Ke+ClV3P9bfxJe8u9v32Bq+
	z4q743tmTd65S5lnaef1A0Za++qFV3EqsRRnJBpqMRcVJwIAb6T8/JIDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4N4r647031812

On Thu, May 22, 2014 at 5:37 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Checks for CONFIG_EXYNOS_ASV were added in v3.3. But the related Kconfig
> symbol has never been added to the tree. Remove these checks, as they
> always evaluate to false.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Thanks for pointing this out.

ASV was supposed to be merged, but it appears it failed or never attempted.

I will merge with the next batch (this week).


Cheers,
MyungJoo.

> ---
> 0) Untested.
>
> 1) I do not really care much for this patch. Two years is not very long
> for dead code to remain in the tree. There is, however, a trivial issue
> that makes this patch stand out from the other patches in my current
> sweep of the tree for Kconfig related problems.
>
> See, here the use of an unknown Kconfig macro hides an obvious typo: it
> should either be "exynos_result_of_asv" or "exynos4_result_of_asv", but
> not both. Ie, this almost certainly wouldn't have compiled even if the
> Kconfig symbol EXYNOS_ASV would have been part of the tree.
>
> 2) So this makes me wonder whether there are any guidelines for using
> Kconfig macros before the related Kconfig symbols are merged?
>
>  drivers/devfreq/Kconfig              |  3 +--
>  drivers/devfreq/exynos/exynos4_bus.c | 13 -------------
>  2 files changed, 1 insertion(+), 15 deletions(-)ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
