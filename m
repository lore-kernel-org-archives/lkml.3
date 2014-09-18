Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbaIRCEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 22:04:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49044 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570AbaIRCET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 22:04:19 -0400
X-AuditID: cbfee68f-f797f6d000001173-2a-541a3da141d5
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <541A3DA0.1040805@samsung.com>
Date: Thu, 18 Sep 2014 11:04:16 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Vikas Sajjan <vikas.sajjan@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [RESEND PATCH] arm: exynos: Allow rtc alarm and tick wakeup irq
 for exynos3250.
References: <1410923262-4771-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAGm_ybjMaLHPALp519fe=UdMy1DeJbcxUxJN+hcPecttY7A_tQ@mail.gmail.com>
In-reply-to: <CAGm_ybjMaLHPALp519fe=UdMy1DeJbcxUxJN+hcPecttY7A_tQ@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWyRsSkWHehrVSIwdx/sha9C66yWWx6fI3V
	4vKuOWwWM87vY7K4+Ww7kwOrx+Yl9R59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CVcaNvGnvB
	Zr6KvS83MTUwzuLuYuTkkBAwkbh+vpENwhaTuHBvPZDNxSEksJRR4t/CU0wwRctefGeGSExn
	lNhz8gwjSIJXQFDix+R7LCA2s4C6xKR5i5ghbBGJ5eeesELY2hLLFr4GiwsJvGaUOLpfC6JX
	S+LRg4VgNSwCqhKPOiFq2ATkJN42fQObLyoQJnF1wnGw+SJAcza+amYHOYJZ4ByjxI6G+2Bn
	CwvEScw8uhnq7D5Gib3dF8E6OAWCJVa+/wN2toTANnaJu88ns0GsE5D4NvkQUBEHUEJWYtMB
	Zog3JSUOrrjBMoFRfBaS52YheW4WkudmIXluASPLKkbR1ILkguKk9CJjveLE3OLSvHS95Pzc
	TYzACDz971n/Dsa7B6wPMQpwMCrx8B7glQoRYk0sK67MPcRoCnTRRGYp0eR8YJznlcQbGpsZ
	WZiamBobmVuaKYnzLpT6GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUbYv5Pmbr4z5DQYC
	lluVWnLyVP6uL5x1sFvROuq5UUXJ7qczk/oXFhw/fky7+14um/Q/G43ZGRmu2dU/ztZ3Oz7R
	2LTlvcS99bufbIy+GMh45uM5k2sNt447OXUfj488e3beb+ap4v0Po/2tP/KIT2hwqklX052n
	+czr7RHHGbZfejdueTG1TomlOCPRUIu5qDgRAJH6JTq7AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t9jQd2FtlIhBrvmiVv0LrjKZrHp8TVW
	i8u75rBZzDi/j8ni5rPtTA6sHpuX1Hv0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGENY8bvD6cYCybzVUw/uYipgfEXVxcjJ4eEgInEshffmSFsMYkL99az
	dTFycQgJTGeU2HPyDCNIgldAUOLH5HssXYwcHMwC8hJHLmWDhJkF1CUmzVsE1isk8JpR4uh+
	LYhyLYlHDxaygtgsAqoSjzpfg9WwCchJvG36BjZSVCBM4uqE4ywgtoiAtsTGV83sIHuZBc4x
	SuxouM8GkhAWiJOYeXQz1EF9jBJ7uy+CdXAKBEusfP+HeQKjwCwk981CuG8WkvsWMDKvYhRN
	LUguKE5KzzXUK07MLS7NS9dLzs/dxAiO1WdSOxhXNlgcYhTgYFTi4T3AKxUixJpYVlyZe4hR
	goNZSYTX871kiBBvSmJlVWpRfnxRaU5q8SFGU6D3JjJLiSbnA9NIXkm8obGJmZGlkbmhhZGx
	uZI474FW60AhgfTEktTs1NSC1CKYPiYOTqkGRtuXvgn7Y9LNs19Jp5gw7e9Qnl73b1Vz0V4L
	81tB77NcxfjDSi8HvLvIz3Qx6fJB10UCXxIcnVTF1vBYV6i+uzk/6IxE5LuUSHXPFwzbf8xf
	7HGX88KE4DOdFYECs6YzTXk9P57zfOVr53sMuqf1VExKDn3czpVlE7Lk05pC7ezqNq2i83nR
	SizFGYmGWsxFxYkAJpxmw+sCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 09월 17일 17:53, Vikas Sajjan wrote:

> Hi,
> 
> On Wed, Sep 17, 2014 at 8:52 AM, Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
>> Add rtc alarm and tick irq to wakeup sources in exynos3250.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> Acked-by : Chanwoo choi <cw00.choi@samsung.com>
>> ---
>>  arch/arm/mach-exynos/pm.c |    9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
>> index fa7218a..d78dcf9 100644
>> --- a/arch/arm/mach-exynos/pm.c
>> +++ b/arch/arm/mach-exynos/pm.c
>> @@ -66,6 +66,12 @@ static struct sleep_save exynos_core_save[] = {
>>
>>  static u32 exynos_irqwake_intmask = 0xffffffff;
>>
>> +static const struct exynos_wkup_irq exynos3250_wkup_irq[] = {
>> +       { 105, BIT(1) }, /* RTC alarm */
>> +       { 106, BIT(2) }, /* RTC tick */
>> +       { /* sentinel */ },
>> +};
>> +
>>  static const struct exynos_wkup_irq exynos4_wkup_irq[] = {
>>         { 76, BIT(1) }, /* RTC alarm */
>>         { 77, BIT(2) }, /* RTC tick */
>> @@ -81,9 +87,10 @@ static const struct exynos_wkup_irq exynos5250_wkup_irq[] = {
>>  static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
>>  {
>>         const struct exynos_wkup_irq *wkup_irq;
>> -
>>         if (soc_is_exynos5250())
>>                 wkup_irq = exynos5250_wkup_irq;
>> +       else if (soc_is_exynos3250())
>> +               wkup_irq = exynos3250_wkup_irq;
> 
> 
> Don't add anymore soc_is_exynosxxx() checks, please rebase on [1],
> which refactors the pm.c to use DT based lookup.
> 
> [1] http://www.spinics.net/lists/arm-kernel/msg355266.html
>


Okay, I'll wait those patches are merged, then I'll rebase and repost it.

Thanks,
Jonghwa.

