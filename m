Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157AbaEFGjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:39:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20818 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933977AbaEFGjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:39:15 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-0d-536883919642
Message-id: <536887D4.90808@samsung.com>
Date: Tue, 06 May 2014 15:57:24 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, t.figa@samsung.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 0/4] Introducing Exynos ChipId driver
References: <1399097500-4052-1-git-send-email-pankaj.dubey@samsung.com>
 <13946837.RfnRDPQdge@wuerfel> <536758AB.2060503@samsung.com>
 <4239261.HFHm7SU1iH@wuerfel>
In-reply-to: <4239261.HFHm7SU1iH@wuerfel>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t8zQ92JzRnBBv8+i1v8nXSM3aJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NarJ/xmsWB3aOluYfN4/evSYwem5fUe/RtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAlfGg5krmAvOG1ds3/yHuYFxjnoXIyeHhICJxNl9jxkhbDGJC/fWs3Ux
	cnEICSxjlJhxaQEzTNHOrs+sILaQwHRGiS8t6RBFrxklnrYtYgFJ8ApoSLxbu5QJxGYRUJU4
	8f8xO4jNJqAr8eT9XLBBogJhEpum97FC1AtK/Jh8D6xXREBRYuqLZ8wgQ5kFNjBK9G7uAGrm
	4BAWsJRY+oMZYtlSRom58zYyg8Q5BTQlXu/KBOllFrCWWDlpGyOELS+xec1bsHoJgUvsEs+n
	/meFOEhA4tvkQywgvRICshKbDkA9JilxcMUNlgmMYrOQnDQLydhZSMYuYGRexSiaWpBcUJyU
	XmSkV5yYW1yal66XnJ+7iRESc307GG8esD7EmAy0ciKzlGhyPjBm80riDY3NjCxMTUyNjcwt
	zUgTVhLnXfQwKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY9ovPRHGRcVz7Wdtedov0lnJ
	PjtGLcFS75577dRll6dwimwwu7A403rO0c4laz7La509HPTi/uX+qif/r2TcnV86T8s0I/p/
	j+FpuZ2dxrOWzzwXzBmUs21V2J/WSIH9IUyT3s7c8nW1X6Wr114L9ozFZ/50hwj9iv7/tPtN
	c4x5zsGmZt3pEUosxRmJhlrMRcWJAOV7843PAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jQd2JzRnBBn82Cln8nXSM3aJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NarJ/xmsWB3aOluYfN4/evSYwem5fUe/RtWcXo8XmTXABr
	VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QFUoK
	ZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjAczVzAXnDeu2L75D3MD4xz1
	LkZODgkBE4mdXZ9ZIWwxiQv31rOB2EIC0xklvrSkdzFyAdmvGSWeti1iAUnwCmhIvFu7lAnE
	ZhFQlTjx/zE7iM0moCvx5P1cZhBbVCBMYtP0PlaIekGJH5PvgfWKCChKTH3xjBlkKLPABkaJ
	3s0dQM0cHMIClhJLfzBDLFvKKDF33kZmkDingKbE612ZIL3MAtYSKydtY4Sw5SU2r3nLPIFR
	YBaSFbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBEP5PewbiqweIQowAH
	oxIP74mV6cFCrIllxZW5hxglOJiVRHjr8zOChXhTEiurUovy44tKc1KLDzEmA0NgIrOUaHI+
	MNnklcQbGpuYGVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAOjS6dQ8s9t
	Bs4ftUy6ZTcfstf9s8vokrWg/MGHkzP3WvU4nJj9kKXj1LP4TwG2nBX+XBNYHcokl6UbzzyV
	57xBrOud/nYP2dMnGR/LKbWFXz6m8F0rIbPeVv7W4eR62eubDncqrfzu6/xd553Ey3/L9zCp
	Trovt8s8oEf2wMEZvZ17rzZYPb+kxFKckWioxVxUnAgA8xbgACwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 11:58 PM, Arnd Bergmann wrote:
> On Monday 05 May 2014 18:23:55 Pankaj Dubey wrote:
>> On 05/04/2014 12:02 AM, Arnd Bergmann wrote:
>>> Ideally this should be done by slightly restructuring the DT
>>> source to make all on-chip devices appear below the soc node.
>> Currently I can't see soc nodes in exynos4 and exynos5 DT files.
>> So isn't it should be a separate patch first to modify all exynos4
>> exynos5 DT files to move all devices under soc node?
>> In that case existing chipid node will be also moved under soc node.
> Yes, that would be good. In fact the soc node could be identical
> to the chipid node, effectively moving everything under chipid.

OK, in that case I would like to keep this as separate patch once
I do all other modifications.

>>> We'd have to think a bit about how to best do this while
>>> preserving compatibility with existing dts files.
>> Is it necessary in this case?
>> As I have mentioned there is difference in bit-mask among exynos4
>> and exynos5's chipid. So is this reason not sufficient to keep separate
>> compatible for both?
> Having two "compatible" values for exynos4 and exynos5 is not a problem,
> and it absolutely makes sense to have more specific values in there
> as well:
>
> compatible = "samsung,exynos4210-chipid", "samsung,exynos4-chipid";

OK, will keep compatible as you suggested.

>
>> Also even if we get some way to preserve existing compatibility, I afraid
>> in chipid driver that implementation will not look good, at least I am not
>> able to think of any good way. Any suggestions?
> The compatibility I mean is to ensure everything keeps working if
> the node is not present.
>
>>> Regarding patch 4, this is not what I meant when I asked for
>>> removing the soc_is_exynos* macros. You basically do a 1:1 replacement
>>> using a different interface, but you still have code that does
>>> things differently based on a global identification.
>> I agree with what you are trying to say. But if you see recently we had some
>> patches (cpu_idle.c: [2], pmu.c: [3])  to remove usage of such macros from
>> exynos machine files. So only leftover files using these macros are exynos.c
>> platsmp.c and pm.c.
>>
>> For exynos.c I have tried to remove soc_is_exynos4/exynos5 by matching with
>> compatible string in patch 1 of this series. Please let me know if that is OK?
> I've taken a closer look at that file now. My preferred solution
> would be to go back to having two machine descriptors as it
> was before Sachin Kamat's "ARM: EXYNOS: Consolidate exynos4 and
> exynos5 machine files", but keep it all in one file and consolidated
> as much as possible, e.g.

Yes, that case I do not need to add another function to compare compatible 
strings.
So if there is no issues in having two separate machine descriptor I will 
do this
modification in next version of patch.

>
> static void __init exynos_dt_machine_init(void)
> {
>         exynos_cpuidle_init();
>         exynos_cpufreq_init();
>
>         of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> }
>
> static void __init exynos5_dt_machine_init(void)
> {
>         /*
>          * Exynos5's legacy i2c controller and new high speed i2c
>          * controller have muxed interrupt sources. By default the
>          * interrupts for 4-channel HS-I2C controller are enabled.
>          * If node for first four channels of legacy i2c controller
>          * are available then re-configure the interrupts via the
>          * system register.
>          */
>         struct device_node *i2c_np;
>         const char *i2c_compat = "samsung,s3c2440-i2c";
>         unsigned int tmp;
>         int id;
>
>         for_each_compatible_node(i2c_np, NULL, i2c_compat) {
>                if (of_device_is_available(i2c_np)) {
>                          id = of_alias_get_id(i2c_np, "i2c");
>                          if (id < 4) {
>                                    tmp = readl(EXYNOS5_SYS_I2C_CFG);
>                                    writel(tmp & ~(0x1 << id),  EXYNOS5_SYS_I2C_CFG);
>                          }
>                 }
>         }
>
>         exynos_dt_machine_init();
> }
>
> This way you can avoid having another check of the compatible node.
> In the long run, all of the this code should go away: The cpuidle
> and cpufreq drivers should become normal platform drivers that
> get probed when the devices are present (just like it's required
> for arm64 anyway), and the EXYNOS5_SYS_I2C_CFG register should
> get set up by an appropriate driver, e.g. the i2c driver through
> syscon, or a pinmux driver that changes the mux between the
> sources based on DT information, whatever fits best.

OK, will move this in i2c driver and will use sysreg as syscon phandle.

>
> Similarly for exynos_map_io(), with the sysram out of the picture,
> it can be
>
> void __init exynos4_init_io(void)
> {
>          debug_ll_io_init();
> 	iotable_init(exynos4_iodesc, ARRAY_SIZE(exynos4_iodesc));
> }
>
> void __init exynos5_init_io(void)
> {
>          debug_ll_io_init();
> 	iotable_init(exynos5_iodesc, ARRAY_SIZE(exynos4_iodesc));
> }
>
> but in the long run, it would be nicer to completely eliminate
> exynos4_iodesc and exynos5_iodesc as well, and remove the init_io
> functions. Note that debug_ll_io_init() is already called when
> you have a NULL .map_io callback.

Agreed.

>
>> Also for platsmp.c and pm.c I can think of following approaches
>> 1: Keep these macros till we get generic solution?
>> 2: Allow chipid driver to expose APIs to check SoC id and SoC revisions
>> till we get
>> generic solution. So that at least we can remove #ifdef  based macros
>> as soc_is_exynosXYZ.
>> 3: Use of "of_flat_dt_is_compatible" or similar APIs in these machine files
>> till we get
>> generic solution. For some cases where we want to know SoC revision let us
>> map chipid register and get revision there itself.
>>
>> Please let me know what approach you think will be good?
> I think 1 or 2 would be better than 3. Between those two, I'm undecided,
> but I think either way the SoC specific values would be better kept in the
> mach-samsung directory than in plat/cpu.h or linux/exynos-chipid.h.

OK, let me introduce this driver via "drivers/soc" in second revision,
there also if we think it's not proper to expose such APIs or variable
outside of the driver, I will be think to move it in under machine 
directory itself.

> 	Arnd
>


-- 
Best Regards,
Pankaj Dubey

