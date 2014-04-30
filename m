Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbaD3IAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:00:55 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48941 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaD3IAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:00:52 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-a2-5360adb22249
Message-id: <5360ADB2.1080600@samsung.com>
Date: Wed, 30 Apr 2014 17:00:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: kgene.kim@samsung.com, t.figa@samsung.com, sajjan.linux@gmail.com,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, arnd@arndb.de, marc.zyngier@arm.com,
        hyunhee.kim@samsung.com, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, yj44.cho@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com,
        thomas.abraham@linaro.org, ben-linux@fluff.org, olof@lixom.net,
        chanho61.park@samsung.com, sachin.kamat@linaro.org,
        linux-arm-kernel@lists.infradead.org, tushar.behera@linaro.org
Subject: Re: [PATCHv4 4/7] ARM: EXYNOS: Enter a15 lowpower mode for Exynos3250
 based on Cortex-a7
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
 <1398388572-30239-5-git-send-email-cw00.choi@samsung.com>
 <535AFCDF.20503@gmail.com>
In-reply-to: <535AFCDF.20503@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsWyRsSkWHfT2oRgg29r1Sz+TjrGbjFp3QEm
	i8v7tS3mHznHavH5QwtQ6P4EFoveBVfZLM42vWG32PT4GqvF5V1z2CxmnN/HZHH7Mq/F3zv/
	2CxOXf/MZnHyTy+jxZPDH1ktZkx+yWaxfsZrFotjM5YwWqza9YfRov3vXjaLvTsnMzqIeayZ
	t4bRo6W5h83j969JjB5/V71g9tg56y67x51re9g8Ni+p97hyoonVo2/LKkaPz5vkAriiuGxS
	UnMyy1KL9O0SuDLetV9gLZgkXDHtTBN7A+Mnvi5GDg4JAROJLcuCuhg5gUwxiQv31rN1MXJx
	CAksZZS4d6WPCSIBVDN1LiNEYjqjxLJDXcwQzmtGiQddB1lAJvEKaEks7fcGaWARUJX4+vcK
	WDMbUHj/ixtsILaoQJjEyulXWEBsXgFBiR+T74HZIgLqEt+m9LOD2MwCM1kkrm/WBRkpLJAs
	ceiIA8SqeYwSnT2rwGo4gerff77GBFGvI7G/dRobhC0vsXnNW7DbJAQecEis2buRHeIgAYlv
	kw+xQHwsK7HpADPEY5ISB1fcYJnAKDYLyUmzkIydhWTsAkbmVYyiqQXJBcVJ6UXGesWJucWl
	eel6yfm5mxiBaeP0v2f9OxjvHrA+xJgMtHIis5Rocj4w7eSVxBsamxlZmJqYGhuZW5qRJqwk
	znv/YVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsalPFcWtmiIGruXTTx6ivU/57R/mjqP
	5pywviXyNoU7ID7x1bfHKyvbVn59xrjm+ax7xUWdd3PUv9gy+87cleVT7ai/4ljJomlmekzt
	xk9rGs+pTlPVMMo1zlwh/1rySCKb8uXJ+V3fpp5re85RfpXzxRUTtylb9zyPdp2x+5xIxin9
	4o3FrZeVWIozEg21mIuKEwExTNLmMQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsVy+t9jQd1NaxOCDT63yVj8nXSM3WLSugNM
	Fpf3a1vMP3KO1eLzhxag0P0JLBa9C66yWZxtesNusenxNVaLy7vmsFnMOL+PyeL2ZV6Lv3f+
	sVmcuv6ZzeLkn15GiyeHP7JazJj8ks1i/YzXLBbHZixhtFi16w+jRfvfvWwWe3dOZnQQ81gz
	bw2jR0tzD5vH71+TGD3+rnrB7LFz1l12jzvX9rB5bF5S73HlRBOrR9+WVYwenzfJBXBFNTDa
	ZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gA9qqRQlphT
	ChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMeNd+gbVgknDFtDNN7A2Mn/i6GDk5
	JARMJLZMncsIYYtJXLi3nq2LkYtDSGA6o8SyQ13MEM5rRokHXQdZuhg5OHgFtCSW9nuDNLAI
	qEp8/XuFCcRmAwrvf3GDDcQWFQiTWDn9CguIzSsgKPFj8j0wW0RAXeLblH52EJtZYCaLxPXN
	uiAjhQWSJQ4dcYBYNY9RorNnFVgNJ1D9+8/XmCDqdST2t05jg7DlJTavecs8gVFgFpIVs5CU
	zUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcFp6Jr2DcVWDxSFGAQ5GJR5ega3x
	wUKsiWXFlbmHGCU4mJVEeDM6EoKFeFMSK6tSi/Lji0pzUosPMSYDQ2Ais5Rocj4wZeaVxBsa
	m5gZWRqZG1oYGZuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2P6C3P3yEdSLa8+5YSf
	MiviOsGw5p658t4LfCf7Xf4sUPr8Ndlv7fyAo3vfcdze/ZCvxY9vOn9Yx7PTJ3t3C7yJv6cU
	wSl6yyw25tf7zw8EK9t4o2z8p169MlHxcGTBFw4rA8ZbsjXn1q2Yu4Vze9DEyMu3ZI2nvSqt
	U+FmZOjT9BK9JvvoTJ4SS3FGoqEWc1FxIgDrsEL2jwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 04/26/2014 09:25 AM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 25.04.2014 03:16, Chanwoo Choi wrote:
>> This patch decide proper lowpower mode of either a15 or a9 according to own ID
>> from Main ID register.
>>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Marc Zynigier <marc.zyngier@arm.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>   arch/arm/mach-exynos/hotplug.c | 19 ++++++++++++-------
>>   1 file changed, 12 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
>> index 5eead53..acf3119 100644
>> --- a/arch/arm/mach-exynos/hotplug.c
>> +++ b/arch/arm/mach-exynos/hotplug.c
>> @@ -135,16 +135,21 @@ void __ref exynos_cpu_die(unsigned int cpu)
>>       int primary_part = 0;
>>
>>       /*
>> -     * we're ready for shutdown now, so do it.
>> -     * Exynos4 is A9 based while Exynos5 is A15; check the CPU part
>> -     * number by reading the Main ID register and then perform the
>> -     * appropriate sequence for entering low power.
>> +     * Prepare the CPU for shutting down. The required sequence of
>> +     * operations depends on core type. CPUID part number can be used to
>> +     * determine the right way.
>>        */
>> -    asm("mrc p15, 0, %0, c0, c0, 0" : "=r"(primary_part) : : "cc");
>> -    if ((primary_part & 0xfff0) == 0xc0f0)
>> +    primary_part = read_cpuid_part_number();
>> +
>> +    switch (primary_part) {
>> +    case ARM_CPU_PART_CORTEX_A7:
>> +    case ARM_CPU_PART_CORTEX_A15:
>>           cpu_enter_lowpower_a15();
>> -    else
>> +        break;
>> +    default:
>>           cpu_enter_lowpower_a9();
>> +        break;
>> +    }
>>
>>       platform_do_lowpower(cpu, &spurious);
>>
>>
> 
> I have noticed Leela Krishna Amudala's patch [1] that removes this distinction completely and simply uses generic code. Could you check if this works on Exynos3250 as well? If yes, then this patch could be dropped and Leela's one would be enough.
> 
> [1] http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg29064.html

OK, I tested this patch[1] to turn on secondary CPu on Exynos3250.
I'll drop following patch on next posting(v5) by using Leela Krishna Amudala's patch [1].
- ARM: EXYNOS: Enter a15 lowpower mode for Exynos3250 based on Cortex-a7

Best Regards,
Chanwoo Choi


