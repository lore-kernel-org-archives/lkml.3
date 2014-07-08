Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbaGHOP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:15:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20841 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaGHOPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:15:24 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-e4-53bbfcfabb66
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
 <1403618235-19353-7-git-send-email-t.figa@samsung.com>
In-reply-to: <1403618235-19353-7-git-send-email-t.figa@samsung.com>
Subject: RE: [PATCH 6/6] ARM: EXYNOS: Register cpuidle device only on
 Exynos4210 and 5250
Date: Tue, 08 Jul 2014 23:15:21 +0900
Message-id: <038b01cf9ab7$0de5a440$29b0ecc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQImwlMNtKSRmS2HaaYx0l+evMEXagHXA9bPmtkxNiA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zI91ff3YHG8w+wW2x6fE1VovLu+aw
	Wcw4v4/JYu2Ru+wW62e8ZrFYtesPowObx85Zd9k9Ni+p9+jbsorR4/MmuQCWKC6blNSczLLU
	In27BK6MW7fvMxXM4qk40rmPrYGxgauLkZNDQsBEYuf82YwQtpjEhXvr2UBsIYFljBJvJofB
	1Jz9uA4ozgUUX8Qo0fy+jR2i6C+jxKkmZhCbTUBD4vD7Z2BxEQFPiQenDrCDNDALLGCUOHtr
	BlRDtcSxc/PAbE4BZ4nVv/rBbGGBaIkt7ycBDeLgYBFQlZjdYQ0S5hWwlDiw/zQrhC0o8WPy
	PRYQm1lAS2L9zuNMELa8xOY1b5khDlWQ2HH2NSPEDVYS/65+YYOoEZHY9+IdI8g9EgLX2CU+
	PDgP1sAiICDxbfIhFpC9EgKyEpsOQM2RlDi44gbLBEaJWUhWz0KyehaS1bOQrFjAyLKKUTS1
	ILmgOCm9yFCvODG3uDQvXS85P3cTIyROe3cw3j5gfYgxGWj9RGYp0eR8YJznlcQbGpsZWZia
	mBobmVuakSasJM6b9DApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPj7vSMa5s/yQmpSzyY
	WfP9qe6Td5qVJrdny/dy67/elflPZZYOl6N567QfPUtZAjv/z/DJKTFZ6qNvpnlmLZPNTc+d
	buu7lcsfHlbaxSxxOCtE+0jG08g/k708mhgP/z/RfHjKd7Zns6syFe77hx/eq+8eEph972aO
	QujMe3tObGk71rDBQCJXiaU4I9FQi7moOBEAo1TvmukCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+xgO6vP7uDDXadZbfY9Pgaq8XlXXPY
	LGac38dksfbIXXaL9TNes1is2vWH0YHNY+esu+wem5fUe/RtWcXo8XmTXABLVAOjTUZqYkpq
	kUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QciWFssScUqBQQGJx
	sZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxq3b95kKZvFUHOncx9bA2MDVxcjJISFgInH2
	4zo2CFtM4sK99UA2F4eQwCJGieb3bewgCSGBv4wSp5qYQWw2AQ2Jw++fgcVFBDwlHpw6wA7S
	wCywgFHi7K0ZUA3VEsfOzQOzOQWcJVb/6gezhQWiJba8nwQ0iIODRUBVYnaHNUiYV8BS4sD+
	06wQtqDEj8n3WEBsZgEtifU7jzNB2PISm9e8ZYY4VEFix9nXjBA3WEn8u/qFDaJGRGLfi3eM
	ExiFZiEZNQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAaeCa1g3Fl
	g8UhRgEORiUe3hUHdwULsSaWFVfmHmKU4GBWEuH9cmp3sBBvSmJlVWpRfnxRaU5q8SFGU6BH
	JzJLiSbnA1NUXkm8obGJmZGlkZmFkYm5uZI474FW60AhgfTEktTs1NSC1CKYPiYOTqkGxnX1
	51dfClkQqXCba/5xZo2kg/rz2PfFLN35t9DlinfONBk2Cbbmh4YrbTzar92PZ+Zo9t233OLa
	JPfp9Yo7bF/fnfSBh3O25est9h+zPCpvFquaxTG7PLeSe3tGL2zDyV384k5a0x4zv1Jxmp3O
	PXmmQuXJDU6L+6XXne4SrdLKOb/hHY+uuxJLcUaioRZzUXEiANqatYIZAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> Currently, the Exynos cpuidle driver works correctly only on Exynos4210
> and 5250. Trying to use it with just one CPU online on any other Exynos
> SoC will lead to system failure, due to unsupported AFTR mode on other
> SoCs. This patch fixes the problem by registering the driver only on
> supported SoCs and letting others simply use default WFI mode until
> support for them is added.
> 
Hmm...I thought other SoCs have no problem on cpuidle except exynos5420 and
exynos5440....something like this would be helpful to avoid system failure.
But unfortunately this conflicts with Pankaj's cleanup cpufreq_init() and
cpuidle_init() patch you've reviewed and I've applied in my local...

I'm going to check which exynos is ok on cpuidle and then sort them out.

Thanks,
Kukjin

> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  arch/arm/mach-exynos/exynos.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
> index f38cf7c..176bbf5 100644
> --- a/arch/arm/mach-exynos/exynos.c
> +++ b/arch/arm/mach-exynos/exynos.c
> @@ -173,10 +173,8 @@ static struct platform_device exynos_cpuidle = {
> 
>  void __init exynos_cpuidle_init(void)
>  {
> -	if (soc_is_exynos5440())
> -		return;
> -
> -	platform_device_register(&exynos_cpuidle);
> +	if (soc_is_exynos4210() || soc_is_exynos5250())
> +		platform_device_register(&exynos_cpuidle);
>  }
> 
>  void __init exynos_cpufreq_init(void)
> --
> 1.9.3

