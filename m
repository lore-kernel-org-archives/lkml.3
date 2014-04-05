Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaDEKgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 06:36:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38003 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbaDEKge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 06:36:34 -0400
X-AuditID: cbfee690-b7f266d00000287c-4c-533fdcb05477
Message-id: <533FE0C1.6070207@samsung.com>
Date: Sat, 05 Apr 2014 19:53:53 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>
Subject: Re: [PATCH 06/10] ARM: EXYNOS: Add support for mapping PMU base
 address via DT
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1396425058-4012-7-git-send-email-pankaj.dubey@samsung.com>
 <533BF905.6070701@samsung.com>
In-reply-to: <533BF905.6070701@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zQ90Nd+yDDc794rdYNukum0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1OPymndViR8tqFgcOj5bmHjaPzUvqPfq2rGL0+LxJLoAl
	issmJTUnsyy1SN8ugSvj55JnjAWNUhXNk7azNzD2i3YxcnJICJhIXLr1nwXCFpO4cG89Wxcj
	F4eQwDJGicULOthginqXzmGCSExnlNj79x9U1WtGibWX3jCCVPEKaEmcaN8B1sEioCqxY+FK
	ZhCbTUBX4sn7uWC2qECYxKbpfawQ9YISPybfA1stIqAvsWTVRbChzAL3GCW2P1oENkhYIFJi
	9ukX7HA3vXz+hwkkwSmgLfHzxQOwbmYBa4mVk7YxQtjyEpvXvGUGaZAQOMcu8e7wRGaIkwQk
	vk0+BNTAAZSQldh0gBniN0mJgytusExgFJuF5KhZSMbOQjJ2ASPzKkbR1ILkguKk9CITveLE
	3OLSvHS95PzcTYyQyJuwg/HeAetDjMlAKycyS4km5wMjN68k3tDYzMjC1MTU2Mjc0ow0YSVx
	XrVHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGHX/FoYtPbv1m3Trh5s8R6Xf2dkYLalm
	NCg8KbuMc9q5BZPUOf7J7GFu62HUZMrMqs5Xlr7+1l8pdkaV6rGsTx86lu/s/CV+9kPqQj8x
	I9EJNu+ihZbWXJw897Mwe25ERZH2zioPKcbW8jMBy26clrp7sOdT7xtug6ntptO2yoTopfwK
	ec7LoMRSnJFoqMVcVJwIAOkC2eXSAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd0Nd+yDDVZ+5LJYNukum0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1OPymndViR8tqFgcOj5bmHjaPzUvqPfq2rGL0+LxJLoAl
	qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoCiWF
	ssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxs8lzxgLGqUqmidtZ29g7Bft
	YuTkkBAwkehdOocJwhaTuHBvPVsXIxeHkMB0Rom9f/9BOa8ZJdZeesMIUsUroCVxon0HG4jN
	IqAqsWPhSmYQm01AV+LJ+7lgtqhAmMSm6X2sEPWCEj8m32MBsUUE9CWWrLoINpRZ4B6jxPZH
	i8AGCQtESsw+/YIdYtsyRomXz/+A3cQpoC3x88UDsG5mAWuJlZO2MULY8hKb17xlnsAoMAvJ
	kllIymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIziun0nvYFzVYHGIUYCDUYmH
	t2OHXbAQa2JZcWXuIUYJDmYlEd6Oc/bBQrwpiZVVqUX58UWlOanFhxiTgWEwkVlKNDkfmHLy
	SuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoFxke71vE+HJwk9
	uDbJ0vJ/c8bMzbJLHsVkiigvKLZyPyO7rvnYSv09X57PDP31gXUy04UTJi94P3663rYtgG+f
	W5W3w5k9e9+Gsfu/z3Tq4fY5IBs3/aD6qf93X2uKp2wT5YlK69xzv7pmYWG3bPicKov5fT4T
	wuR6Ih7MOSuS8pJhyv/lpfuClFiKMxINtZiLihMBm6fwbC8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 08:48 PM, Sylwester Nawrocki wrote:
> On 02/04/14 09:50, Pankaj Dubey wrote:
>> From: Young-Gun Jang <yg1004.jang@samsung.com>
>>
>> Add support for mapping Exynos Power Management Unit (PMU) base address
>> from device tree. Code will use existing samsung pmu binding information.
>> This patch also adds "get_exynos_pmubase" a helper function to return mapped base
>> address to various other files under "mach-exynos".
>>
>> Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   arch/arm/mach-exynos/common.h |    2 ++
>>   arch/arm/mach-exynos/exynos.c |   44 +++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 46 insertions(+)
>>
> [...]
>>   #endif /* __ARCH_ARM_MACH_EXYNOS_COMMON_H */
>> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
>> index a5e1349..a5127fb 100644
>> --- a/arch/arm/mach-exynos/exynos.c
>> +++ b/arch/arm/mach-exynos/exynos.c
>> @@ -35,6 +35,8 @@
>>   #define L2_AUX_VAL 0x7C470001
>>   #define L2_AUX_MASK 0xC200ffff
>>   
>> +static void __iomem *exynos_pmu_base __initdata;
>> +
>>   static struct map_desc exynos4_iodesc[] __initdata = {
>>   	{
>>   		.virtual	= (unsigned long)S3C_VA_SYS,
>> @@ -245,6 +247,47 @@ void __init exynos_init_late(void)
>>   	exynos_pm_init();
>>   }
>>   
>> +static char const *exynos_dt_pmu_match[] __initconst = {
>> +	"samsung,exynos4210-pmu",
>> +	"samsung,exynos4212-pmu",
>> +	"samsung,exynos4412-pmu",
>> +	"samsung,exynos5250-pmu",
>> +	NULL
>> +};
>> +
>> +static int __init exynos_fdt_map_pmu(unsigned long node,
>> +		const char *uname, int depth, void *data)
>> +{
>> +	struct map_desc iodesc;
>> +	__be32 *reg;
>> +	unsigned long len;
>> +
>> +	if (of_flat_dt_match(node, exynos_dt_pmu_match)) {
>> +		phys_addr_t phys_addr;
>> +		reg = of_get_flat_dt_prop(node, "reg", &len);
>> +		if (reg == NULL || len != (sizeof(unsigned long) * 2))
>> +			return 0;
>> +
>> +		phys_addr = be32_to_cpu(reg[0]);
>> +		iodesc.pfn = __phys_to_pfn(phys_addr);
>> +		iodesc.length = be32_to_cpu(reg[1]) - 1;
>> +		iodesc.virtual = (unsigned long)S5P_VA_PMU;
>> +		iodesc.type = MT_DEVICE;
>> +		iotable_init(&iodesc, 1);
> Are you sure...you need this in addition to ioremap() below ?
> Can't you just use the Linux syscon API ?
> There were some patches posted for syscon to make it available in earlier
> system initialization stage: https://lkml.org/lkml/2014/2/19/218
Thanks for review and suggestion.

We need ioremap() in addition to iotable_init to get virtual address,
which will be used by other files also for read/write PMU registers.

Regarding syscon early initialization, since I was not aware of any such
patch earlier I have not used it. But after you suggested I tried it and
modified this implementation to use syscon API and regmap API and it's
working fine.
I will wait for review of other patches in this series and status of above
mentioned syscon API based on that I will update this in next revision.

>> +		exynos_pmu_base = ioremap(phys_addr, be32_to_cpu(reg[1]));
>> +		if (WARN_ON(!exynos_pmu_base))
>> +			return -EFAULT;
>> +	}
>> +
>> +	return 0;
>> +}
> --
> Thanks,
> Sylwester
>


-- 
Best Regards,
Pankaj Dubey

