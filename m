Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbaDKFOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 01:14:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12679 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbaDKFOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 01:14:01 -0400
X-AuditID: cbfee68e-b7f566d000002344-7c-53477a1827d9
Message-id: <53477A19.6070509@samsung.com>
Date: Fri, 11 Apr 2014 14:14:01 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Olof Johansson <olof@lixom.net>
Cc: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/27] ARM: EXYNOS: Support secondary CPU boot of Exynos4212
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397122658-16013-5-git-send-email-cw00.choi@samsung.com>
 <20140411014424.GA14934@quad.lixom.net>
In-reply-to: <20140411014424.GA14934@quad.lixom.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWyRsSkSFeiyj3Y4PsPAYvPH1rYLSbdn8Bi
	0bvgKpvF2aY37BabHl9jtbi8aw6bxYzz+5gsTl3/DGRNfslmsX7GaxaLvTsnMzpwe2xeUu9x
	5UQTq0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBlHN/4ma3ginDF6zMdbA2M/fxdjJwcEgIm
	EicW/mSGsMUkLtxbz9bFyMUhJLCUUWLH11YmmKIbvy6yQCSmM0q8PfSKCcJ5zShxa+lndpAq
	XgEtiWfLV7GB2CwCqhInDt5iBLHZgOL7X9wAi4sKhEmsnH6FBaJeUOLH5HtgtoiAssSTtkvM
	IEOZBaYwSdx9+QEsISwQIDGj8zbUTasZJa78fgiU4ODgBLrp2U2wocwCOhL7W6dB2fISm9e8
	BRskIXCPXaLj/G92iIsEJL5NPgTWKyEgK7HpANTPkhIHV9xgmcAoNgvJTbOQjJ2FZOwCRuZV
	jKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIFxefrfs74djDcPWB9iTAZaOZFZSjQ5HxjXeSXx
	hsZmRhamJqbGRuaWZqQJK4nzLnqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB0cc8648X
	v/+r+Ja/JyLOMe4Qk+WfrJ2961jYNtkCV3/BnzmeU06bSe8w2bdw/YQZD9crGwl+3/3v9MN5
	3w3XzFmyLicq+NJt54+sojLzZMT+rZ7D8EK3yWdCSFetefX8E60PDSxdPQqi9O/ZZL7l/7z4
	Vo1b/97/H775rzotkM0veu2MN+/vE0osxRmJhlrMRcWJAJAJeIzhAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jQV2JKvdggwOf2C0+f2hht5h0fwKL
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyOHX9M5A1+SWbxfoZr1ks9u6czOjA7bF5Sb3H
	lRNNrB59W1YxenzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCX
	mJtqq+TiE6DrlpkDdJWSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMeP4
	xs9sBVeEK16f6WBrYOzn72Lk5JAQMJG48esiC4QtJnHh3nq2LkYuDiGB6YwSbw+9YoJwXjNK
	3Fr6mR2kildAS+LZ8lVsIDaLgKrEiYO3GEFsNqD4/hc3wOKiAmESK6dfYYGoF5T4MfkemC0i
	oCzxpO0SM8hQZoEpTBJ3X34ASwgLBEjM6LwNtXo1o8SV3w+BEhwcnED3PbsJNpRZQEdif+s0
	KFteYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER/0z
	6R2MqxosDjEKcDAq8fAeuOQWLMSaWFZcmXuIUYKDWUmE18zfPViINyWxsiq1KD++qDQntfgQ
	YzIwCCYyS4km5wMTUl5JvKGxiZmRpZG5oYWRsTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBx
	cEo1MNazv3BJUJ/NK27yOfG29tI5G+pa+op4tD4XfjLuVva+6Hg/i+XqTo32vJ1tXcwi56/b
	+U/4t3+iXHa5jETtwcvfXxjM2KI/X7YouVb8QMU6zouzg6es3u2fclG78tGWnNNzHWMuKG3m
	bmrprutU2MgzTeyaJq+s+ZXnCxhNWpSvJUTmdVQ+VmIpzkg01GIuKk4EAGsc8kE+AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/11/2014 10:44 AM, Olof Johansson wrote:
> On Thu, Apr 10, 2014 at 06:37:15PM +0900, Chanwoo Choi wrote:
>> From: Kyungmin Park <kyungmin.park@samsung.com>
>>
>> This patch fix the offset of CPU boot address and change parameter of smc call
>> of SMC_CMD_CPU1BOOT command for Exynos4212.
>>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/mach-exynos/firmware.c | 14 ++++++++++++--
>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
>> index 932129e..91a911d 100644
>> --- a/arch/arm/mach-exynos/firmware.c
>> +++ b/arch/arm/mach-exynos/firmware.c
>> @@ -18,6 +18,8 @@
>>  
>>  #include <mach/map.h>
>>  
>> +#include <plat/cpu.h>
>> +
>>  #include "smc.h"
>>  
>>  static int exynos_do_idle(void)
>> @@ -28,14 +30,22 @@ static int exynos_do_idle(void)
>>  
>>  static int exynos_cpu_boot(int cpu)
>>  {
>> -	exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
>> +	if (soc_is_exynos4212())
>> +		exynos_smc(SMC_CMD_CPU1BOOT, 0, 0, 0);
>> +	else
>> +		exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
> 
> 	/* <explain why you need this special case on 4212> */

It's better to ask system lsi person. We don't know it well.
I got the guide about secondary boot from system lsi.
But, this patch was completely tested.

> 	if (soc_is_exynos4212())
> 		cpu = 0;
> 
> ...and then do the call as before.

OK, I'll modify it as following:

 static int exynos_cpu_boot(int cpu)
 {
+       if (soc_is_exynos4212())
+               cpu = 0;
+
        exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
        return 0;
 }

> 
> 
>>  	return 0;
>>  }
>>  
>>  static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
>>  {
>> -	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c + 4*cpu;
>> +	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c;
>>  
>> +	if (soc_is_exynos4212())
>> +		goto out;
>> +	else
>> +		boot_reg += 4*cpu;
> 
> 	if (!soc_is_exynos4212())
> 		boot_reg += 4 * cpu;
> 
> That way you avoid a goto, especially since the "goto out" isn't actually
> an "out", it's still doing stuff at the end of the funciton.
> 

OK, I'll remove goto statement and then modify it as your comment.

-       void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c + 4*cpu;
+       void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c;
+
+       if (!soc_is_exynos4212())
+               boot_reg += 4*cpu;

Best Regards,
Chanwoo Choi
