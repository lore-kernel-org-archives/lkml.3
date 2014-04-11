Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbaDKGEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:04:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64889 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbaDKGEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:04:13 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-8c-534785db9df8
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Olof Johansson'" <olof@lixom.net>
Cc: linux-samsung-soc@vger.kernel.org, t.figa@samsung.com,
        hyunhee.kim@samsung.com, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, yj44.cho@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397122658-16013-5-git-send-email-cw00.choi@samsung.com>
 <20140411014424.GA14934@quad.lixom.net> <53477A19.6070509@samsung.com>
In-reply-to: <53477A19.6070509@samsung.com>
Subject: RE: [PATCH 04/27] ARM: EXYNOS: Support secondary CPU boot of Exynos4212
Date: Fri, 11 Apr 2014 15:04:11 +0900
Message-id: <006f01cf554b$dbc6a2d0$9353e870$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGB6meoV0Op4c6O0JoKYhIbL435PgEUgv4/AeDvlO4BouzvnZuB+T8Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t8zfd3bre7BBmv+GFhc//Kc1eLzhxZ2
	i0n3J7BY9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaLU9c/A1mTX7JZrJ/xmsVi787JjA48
	HpuX1HtcOdHE6tG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZr3u7GQs+slecXVvWwDiHrYuR
	k0NCwERi2Z5pULaYxIV764FsLg4hgWWMEpO6v7LAFL2bc5cVIjGdUWLaydVQzh9Gic1XOxlB
	qtgENCRW7n4L1M7BISLgK/HutxpIDbPAJCaJqbMXQo09xSix7vpWsLGcAtoS55+uBWsWFgiQ
	mPu1jRXEZhFQlZi34xQ7iM0rYClxvn8eM4QtKPFj8j2wXmYBLYn1O48zQdjyEpvXvGWGOFVB
	YsfZ12AzRQTcJI48W8gKUSMise/FO0aQIyQEOjkkHvx6DbVMQOLb5EMsIFdLCMhKbDoANUdS
	4uCKGywTGCVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MkDif
	uIPx/gHrQ4zJQOsnMkuJJucD00ReSbyhsZmRhamJqbGRuaUZacJK4rzpj5KChATSE0tSs1NT
	C1KL4otKc1KLDzEycXBKNTCufzD5QQ3PRTbj3W8yQ8tnsm8ya52oLaP6vPCP4rrPKy+s2Lkh
	821abE1TWeydrE52V+fcSrEa/4+HBX0Kdp6N/ZMabCVyT/zhF6cUjV8Ssyb5Ti/SOlHwR+3g
	1S1RCtHn2/vl9zaHxt2zsdljr3nG/GR7YMBPXZP5WceDWddHMJodXnBHTECJpTgj0VCLuag4
	EQDEEdy1CQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsVy+t9jQd3bre7BBn3/tS2uf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFqeufgazJL9ks1s94zWKxd+dkRgce
	j81L6j2unGhi9ejbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNL
	C3MlhbzE3FRbJRefAF23zByg05QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCB
	hHWMGa97uxkLPrJXnF1b1sA4h62LkZNDQsBE4t2cu6wQtpjEhXvrgeJcHEIC0xklpp1czQrh
	/GGU2Hy1kxGkik1AQ2Ll7rdAVRwcIgK+Eu9+q4HUMAtMYpKYOnshVPcpRol117eygDRwCmhL
	nH+6FqxZWCBAYu7XNrB1LAKqEvN2nGIHsXkFLCXO989jhrAFJX5MvgfWyyygJbF+53EmCFte
	YvOat8wQpypI7Dj7GmymiICbxJFnC1khakQk9r14xziBUWgWklGzkIyahWTULCQtCxhZVjGK
	phYkFxQnpeca6hUn5haX5qXrJefnbmIEJ5FnUjsYVzZYHGIU4GBU4uHNuOAWLMSaWFZcmXuI
	UYKDWUmE18zfPViINyWxsiq1KD++qDQntfgQYzLQpxOZpUST84EJLq8k3tDYxMzI0sjMwsjE
	3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGL13fJ/9J+xLmf1Ct+nJJr2urkk5T84u
	NtLunqASb7M1UftZ5ZHHF2tMr8xw81QvN48+uPTR1CfZs2IfnJXeNzPtquu85/f+7pCeYb7u
	f1oKO99+tiV2X58u3+a0ok34CrNEyIUXbrnOkzwzC6a2ZhXO2n1P+v2qBee3al41dGTqMSpt
	9bwo9l+JpTgj0VCLuag4EQBEdQFJZgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On 04/11/2014 2:14 PM, Chanwoo Choi wrote:

> >>  {
> >> -	exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
> >> +	if (soc_is_exynos4212())
> >> +		exynos_smc(SMC_CMD_CPU1BOOT, 0, 0, 0);
> >> +	else
> >> +		exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
> >
> > 	/* <explain why you need this special case on 4212> */
> 
> It's better to ask system lsi person. We don't know it well.
> I got the guide about secondary boot from system lsi.
> But, this patch was completely tested.

exynos_smc(SMC_CMD_CPU1BOOT, ...) is cpu hotplug SMC interface.
Exynos4212 is dual core processor.
Exynos4212 only have to boot cpu1 on smp boot.
So, Second parameter of exynos_smc is fixed by 0 which means cpu1.
It don't need to boot another cpu (ex. cpu2, cpu3 for quad core processor).
But In case of quad core processor (ex. Exynos4412), 
It need to boot another cpu and specify parameter of booting core.
As I know, Exynos3250 is dual core. 
So It can be included 1st condition too.

Sangbeom,
Thanks,

