Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaDXC2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 22:28:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45892 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaDXC17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 22:27:59 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-93-535876ad348a
Message-id: <53587ADA.1090003@samsung.com>
Date: Thu, 24 Apr 2014 11:45:46 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Vikas Sajjan <sajjan.linux@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux@arm.linux.org.uk,
        chow.kim@samsung.com, Young-Gun Jang <yg1004.jang@samsung.com>,
        sunil joshi <joshi@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 06/10] ARM: EXYNOS: Add support for mapping PMU base
 address via DT
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1396425058-4012-7-git-send-email-pankaj.dubey@samsung.com>
 <CAGm_ybgEfqYfKJch58_svA5GAbkFXfXb1FyOiMSrX12PzBHxyA@mail.gmail.com>
In-reply-to: <CAGm_ybgEfqYfKJch58_svA5GAbkFXfXb1FyOiMSrX12PzBHxyA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zA921ZRHBBkcfmFgsm3SXzeL7ri/s
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mdfiyeGPrBardv1htNjRsprFgcujpbmHzWPnrLvs
	HpuX1Hv0bVnF6PF5k1wAaxSXTUpqTmZZapG+XQJXxo4Dv9gKHipW3Lj5grWBcbZkFyMnh4SA
	icT3xxeZIWwxiQv31rN1MXJxCAksY5TY9PgGM0zRuV/foBKLGCUWTlzDDOG8ZpTYMWcPSxcj
	BwevgJbE8T1qIA0sAqoS/98/YAOx2QR0JZ68nws2SFQgTGLT9D5WEJtXQFDix+R7YK0iApoS
	Dz/agIxkFvjEJHFvTh9YvbBApMTs0y/YIXadYZR4uvgk2FBOgWCJxQ1PwWxmATOJRy3rmCFs
	eYnNa96CHSch8JJd4mLLCjaIiwQkvk0+BLZNQkBWYtMBqM8kJQ6uuMEygVFsFpKbZiEZOwvJ
	2AWMzKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxQmKyfwfj3QPWhxiTgVZOZJYSTc4HxnRe
	SbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamCcaMo4
	Kyt+3YcPe7m9M46/WfdPYZHT5efTfR1SZBOTBF/27Y43Kn4a7++j8fE1+9korV+RrhqO67ek
	u3L9emFszhe2nO/wLdct6+U4g/xYP0QGr5QslhKRlZn4vXat2YSny/7oSrX8dWTKVHVr+3D1
	SN6h998ea1qlfG00S//ZOifvwdsaU2MlluKMREMt5qLiRABQKOlD3wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd21ZRHBBr1H9S2WTbrLZvF91xd2
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGvx5PBHVotVu/4wWuxoWc3iwOXR0tzD5rFz1l12
	j81L6j36tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEv
	MTfVVsnFJ0DXLTMH6CglhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8aO
	A7/YCh4qVty4+YK1gXG2ZBcjJ4eEgInEuV/f2CBsMYkL99YD2VwcQgKLGCUWTlzDDOG8ZpTY
	MWcPSxcjBwevgJbE8T1qIA0sAqoS/98/AGtmE9CVePJ+LjOILSoQJrFpeh8riM0rICjxY/I9
	sFYRAU2Jhx9tQEYyC3xikrg3pw+sXlggUmL26RfsELvOMEo8XXwSbCinQLDE4oanYDazgJnE
	o5Z1zBC2vMTmNW+ZJzAKzEKyYxaSsllIyhYwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93E
	CI74Z1I7GFc2WBxiFOBgVOLhPXAhPFiINbGsuDL3EKMEB7OSCG+eR0SwEG9KYmVValF+fFFp
	TmrxIcZkYBBMZJYSTc4HJqO8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQW
	wWxh4uCUamCc2PvxrstE9xD5BXeUtzXqTjwnxylm+Npni75W06cTDftPPsoT9rxnx6Qz4dW9
	LTcfFy6e/TBg5UkD/wlGasHCukzbFJQO7q956XYsYfbkZA4zhrMa6z8wf+cQ/JXeFLL2utnb
	/oSfkmn/1xvMXMdmskW53kl3W+HcQ3s6nkqkylTPV2UvfWmlxFKckWioxVxUnAgA/bUPmzwD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vikas,

On 04/23/2014 10:02 PM, Vikas Sajjan wrote:
> Hi,
>
> On Wed, Apr 2, 2014 at 1:20 PM, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
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
>> diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
>> index ff28334..9a55cf6 100644
>> --- a/arch/arm/mach-exynos/common.h
>> +++ b/arch/arm/mach-exynos/common.h
>> @@ -61,4 +61,6 @@ struct exynos_pmu_conf {
>>
>>   extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
>>
>> +extern void __iomem *get_exynos_pmubase(void);
>> +
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
> Are you sure you want to keep exynos_pmu_base in .init section.
> I am seeing a crash in platform_do_lowpower()
> I think you should remove __initdata.

Thanks for review and testing.
You are right we do not need __initdata here.
I will take care of this in V2.

>> +
>>   static struct map_desc exynos4_iodesc[] __initdata = {
>>          {
>>                  .virtual        = (unsigned long)S3C_VA_SYS,
>> @@ -245,6 +247,47 @@ void __init exynos_init_late(void)
>>          exynos_pm_init();
>>   }
>>
>> +static char const *exynos_dt_pmu_match[] __initconst = {
>> +       "samsung,exynos4210-pmu",
>> +       "samsung,exynos4212-pmu",
>> +       "samsung,exynos4412-pmu",
>> +       "samsung,exynos5250-pmu",
>> +       NULL
>> +};
>> +
>> +static int __init exynos_fdt_map_pmu(unsigned long node,
>> +               const char *uname, int depth, void *data)
>> +{
>> +       struct map_desc iodesc;
>> +       __be32 *reg;
>> +       unsigned long len;
>> +
>> +       if (of_flat_dt_match(node, exynos_dt_pmu_match)) {
>> +               phys_addr_t phys_addr;
>> +               reg = of_get_flat_dt_prop(node, "reg", &len);
>> +               if (reg == NULL || len != (sizeof(unsigned long) * 2))
>> +                       return 0;
>> +
>> +               phys_addr = be32_to_cpu(reg[0]);
>> +               iodesc.pfn = __phys_to_pfn(phys_addr);
>> +               iodesc.length = be32_to_cpu(reg[1]) - 1;
>> +               iodesc.virtual = (unsigned long)S5P_VA_PMU;
>> +               iodesc.type = MT_DEVICE;
>> +               iotable_init(&iodesc, 1);
>> +
>> +               exynos_pmu_base = ioremap(phys_addr, be32_to_cpu(reg[1]));
>> +               if (WARN_ON(!exynos_pmu_base))
>> +                       return -EFAULT;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +inline void __iomem *get_exynos_pmubase()
>> +{
>> +       return exynos_pmu_base;
>> +}
>> +
>>   static int __init exynos_fdt_map_chipid(unsigned long node, const char *uname,
>>                                          int depth, void *data)
>>   {
>> @@ -301,6 +344,7 @@ void __init exynos_init_io(void)
>>          debug_ll_io_init();
>>
>>          of_scan_flat_dt(exynos_fdt_map_chipid, NULL);
>> +       of_scan_flat_dt(exynos_fdt_map_pmu, NULL);
>>
>>          /* detect cpu id and rev. */
>>          s5p_init_cpu(S5P_VA_CHIPID);
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Best Regards,
Pankaj Dubey

