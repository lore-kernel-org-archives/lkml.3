Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaEWCCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 22:02:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18200 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaEWCCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 22:02:19 -0400
X-AuditID: cbfee690-b7fb56d000003439-57-537eac28d3af
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Russell King'" <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
References: <20140523112003.3da4b5f5@canb.auug.org.au>
In-reply-to: <20140523112003.3da4b5f5@canb.auug.org.au>
Subject: RE: linux-next: manual merge of the samsung tree with the  tree
Date: Fri, 23 May 2014 11:02:16 +0900
Message-id: <017b01cf762b$05576a80$10063f80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFhzSMmrCfVmo0iBpo9N6OfLYlnD5wou6ZQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zfV2NNXXBBpdvSVlc3jWHzeLgwjZG
	i9uXeS1O/ulltNi69yq7A6tHS3MPm0fjjRtsHneu7WHz+LxJLoAlissmJTUnsyy1SN8ugSvj
	5K4+xoL/PBULH81kamBcwtXFyMkhIWAi8fTWEkYIW0ziwr31bF2MXBxCAssYJd5ffczaxcgB
	VtS5ORAivohRYnnbEWYI5y+jxP8pS5lAutkENCQOv3/GDmKLCERITD23kRnEZhbIkLi3fTkL
	iC0kYCax40UHG4jNKWAu8fLGXrAaYQEPiU/Nc8BqWARUJT7f38YKYvMKWEq03jzFBGELSvyY
	fI8FYqaWxPqdx5kgbHmJzWveMkN8oCCx4+xrRogbjCQ+bpzJBlEjIrHvxTtGkKMlBC6xSyyc
	cIYJYpmAxLfJh1ggvpSV2HQAao6kxMEVN1gmMErMQrJ6FpLVs5CsnoVkxQJGllWMoqkFyQXF
	SelFJnrFibnFpXnpesn5uZsYIfE5YQfjvQPWhxiTgdZPZJYSTc4HxndeSbyhsZmRhamJqbGR
	uaUZacJK4rxqj5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAGSqR3ifYzrW7LY5vwQUJu
	E+N6C+UfC+xspoV/0rerf9kjJBgo3l3P9Plz60/lyZZ3f0jfFTvve7wzauvBjHB1j3eGRzcZ
	l62LWGV3bh3n7c1HV2ZN8dxaMsFsrt7aSVyN+ndv8FjVRs8pnSQmU2l2NWjdVbapG64wVnF+
	5fH0mlbpevnKpP1KLMUZiYZazEXFiQDfdNi25QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jAV2NNXXBBgdPiVlc3jWHzeLgwjZG
	i9uXeS1O/ulltNi69yq7A6tHS3MPm0fjjRtsHneu7WHz+LxJLoAlqoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdor5JCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsI4x4+SuPsaC/zwVCx/NZGpgXMLVxcjBISFgItG5ObCLkRPI
	FJO4cG89WxcjF4eQwCJGieVtR5ghnL+MEv+nLGUCqWIT0JA4/P4ZO4gtIhAhMfXcRmYQm1kg
	Q+Le9uUsILaQgJnEjhcdbCA2p4C5xMsbe8FqhAU8JD41zwGrYRFQlfh8fxsriM0rYCnRevMU
	E4QtKPFj8j0WiJlaEut3HmeCsOUlNq95ywxxqYLEjrOvGSFuMJL4uHEmG0SNiMS+F+8YJzAK
	zUIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODofya9g3FVg8Uh
	RgEORiUe3gdMdcFCrIllxZW5hxglOJiVRHh9QoFCvCmJlVWpRfnxRaU5qcWHGJOBPp3ILCWa
	nA9MTHkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwJjY6jnl
	702bg6fee4p3mqVzKeq8LlBt96o5Lfz064QK3eQn1w9q573/umzebamz3iLW5fb5NooSm3aY
	yy+4nL1tXUHd0blMD+rOftafxKnCGr4/zmaF7muN3PgM+Wcai/tP5J6SjOaPMprX/ZeJafFa
	3hVX2MVazBWm7o5ONw76Mr0z5Mii2UosxRmJhlrMRcWJAPI8U1dCAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi Kukjin,
> 
Hi Stephen,

> Today's linux-next merge of the samsung tree got a conflict in
> arch/arm/mach-exynos/exynos.c between commit 46bfc99c9225 ("ARM: l2c:
> exynos: convert to generic l2c OF initialisation (and thereby fix it)")
> from the arm tree and commit 3919fb954b3a ("ARM: EXYNOS: Remove
> exynos_subsys registration") from the samsung tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
Looks good to me, thanks.

- Kukjin

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mach-exynos/exynos.c
> index afce154f83f9,93507ee98c86..000000000000
> --- a/arch/arm/mach-exynos/exynos.c
> +++ b/arch/arm/mach-exynos/exynos.c
> @@@ -241,17 -246,22 +243,6 @@@ void __init exynos_init_io(void
>   	exynos_map_io();
>   }
> 
> - struct bus_type exynos_subsys = {
> - 	.name		= "exynos-core",
> - 	.dev_name	= "exynos-core",
> - };
> -
> - static int __init exynos_core_init(void)
>  -static int __init exynos4_l2x0_cache_init(void)
> --{
> - 	return subsys_system_register(&exynos_subsys, NULL);
>  -	int ret;
>  -
>  -	ret = l2x0_of_init(L2_AUX_VAL, L2_AUX_MASK);
>  -	if (ret)
>  -		return ret;
>  -
>  -	if (IS_ENABLED(CONFIG_S5P_SLEEP)) {
>  -		l2x0_regs_phys = virt_to_phys(&l2x0_saved_regs);
>  -		clean_dcache_area(&l2x0_regs_phys, sizeof(unsigned long));
>  -	}
>  -	return 0;
> --}
> - core_initcall(exynos_core_init);
>  -early_initcall(exynos4_l2x0_cache_init);
> --
>   static void __init exynos_dt_machine_init(void)
>   {
>   	struct device_node *i2c_np;

