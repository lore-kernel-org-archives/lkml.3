Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaEGEiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:38:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11140 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaEGEiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:38:20 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-2a-5369b88f13bc
Message-id: <5369B88E.9030901@samsung.com>
Date: Wed, 07 May 2014 13:37:34 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: kgene.kim@samsung.com, t.figa@samsung.com, linux@arm.linux.org.uk,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5] ARM: EXYNOS: Support secondary CPU boot of Exynos4212
References: <1398735462-1938-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1398735462-1938-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWyRsSkSLd/R2awwfW1nBaX92tbXP/ynNXi
	84cWdotJ9yewWPQuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi9uXeS1mTH7JZrF+xmsWi707
	JzM68Hq0NPeweWxeUu/Rt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGVuu3WUq2MtXMfNOXQPj
	Me4uRk4OCQETiQ1b2pkhbDGJC/fWs3UxcnEICSxllLh7pZsJpmhH9wFmiMR0Romna6dBVb1m
	lHjcf5sRpIpXQEti644eVhCbRUBVYtv6o2Bj2YDi+1/cYAOxRQXCJFZOv8ICUS8o8WPyPTBb
	REBDYubfK4wgQ5kFjjNJzDjZDzZUWMBH4tGfrWCDhARcJN7O2go0iIODU8BV4vVjPZAws4CO
	xP7WaWwQtrzE5jVvod75yC6x/EMFxD0CEt8mH2IBaZUQkJXYdACqRFLi4IobLBMYxWYhuWgW
	kqmzkExdwMi8ilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMwQk//ezZxB+P9A9aHGJOBVk5k
	lhJNzgdGeF5JvKGxmZGFqYmpsZG5pRlpwkrivOmPkoKEBNITS1KzU1MLUovii0pzUosPMTJx
	cEo1MHbMerhP5Sf3WRsLuxBXs03M56fw+Iuxclq3R+TskC5vMNFh6L6YGPgr0CVf/uGV7R9c
	2b7anopbJ2q8SF+E++3syok+tlvMNKVEcru1V2gEu7tNlbn35/e+HNVtNXwS8tafz++5s+68
	4kKPuIu3Nh+rVbGvXOu53KXkhdOrNPGAk9Pk5fdyKLEUZyQaajEXFScCAEAQHNLmAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jQd3+HZnBBo8PMFpc3q9tcf3Lc1aL
	zx9a2C0m3Z/AYtG74CqbxdmmN+wWmx5fY7W4vGsOm8WM8/uYLG5f5rWYMfklm8X6Ga9ZLPbu
	nMzowOvR0tzD5rF5Sb1H35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
	GOoaWlqYKynkJeam2iq5+AToumXmAF2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiu
	x8gADSSsYczYcu0uU8FevoqZd+oaGI9xdzFyckgImEjs6D7ADGGLSVy4t56ti5GLQ0hgOqPE
	07XToJzXjBKP+28zglTxCmhJbN3RwwpiswioSmxbfxSsmw0ovv/FDTYQW1QgTGLl9CssEPWC
	Ej8m3wOzRQQ0JGb+vcIIMpRZ4DiTxIyT/WBDhQV8JB792Qo2SEjAReLtrK1Agzg4OAVcJV4/
	1gMJMwvoSOxvncYGYctLbF7zlnkCo8AsJCtmISmbhaRsASPzKkbR1ILkguKk9FwjveLE3OLS
	vHS95PzcTYzgBPBMegfjqgaLQ4wCHIxKPLwWbzOChVgTy4orcw8xSnAwK4nwLlqbGSzEm5JY
	WZValB9fVJqTWnyIMRkYAhOZpUST84HJKa8k3tDYxMzI0sjc0MLI2Jw0YSVx3oOt1oFCAumJ
	JanZqakFqUUwW5g4OKUaGBPu3edxvXXp1a+nP6ZGCq4smHy4YXGS0cNnMbEvw1crBXy5n/58
	9vMT/PVpH7nPca+6YPTlflRMVe3jgw7/HtjUzxG19uTs6gpfl3l/lkFEYvpaaTXdwO7Xqtsn
	v7K4FShnuyc1WNtkpfvE1Hfsn91d8vgeOpsldl1t+b4j8Z5xydlq6R3KnEosxRmJhlrMRcWJ
	AFjq149EAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin,

Could you please pick this patch?

Best Regards,
Chanwoo Choi

On 04/29/2014 10:37 AM, Chanwoo Choi wrote:
> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> This patch fix the offset of CPU boot address and change parameter of smc call
> of SMC_CMD_CPU1BOOT command for Exynos4212.
> 
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
> Changes from v4:
> - Post only this patch separated from following patchset[1]
> [1] https://lkml.org/lkml/2014/4/24/873
> 
>  arch/arm/mach-exynos/firmware.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
> index 932129e..aa01c42 100644
> --- a/arch/arm/mach-exynos/firmware.c
> +++ b/arch/arm/mach-exynos/firmware.c
> @@ -18,6 +18,8 @@
>  
>  #include <mach/map.h>
>  
> +#include <plat/cpu.h>
> +
>  #include "smc.h"
>  
>  static int exynos_do_idle(void)
> @@ -28,13 +30,24 @@ static int exynos_do_idle(void)
>  
>  static int exynos_cpu_boot(int cpu)
>  {
> +	/*
> +	 * The second parameter of SMC_CMD_CPU1BOOT command means CPU id.
> +	 * But, Exynos4212 has only one secondary CPU so second parameter
> +	 * isn't used for informing secure firmware about CPU id.
> +	 */
> +	if (soc_is_exynos4212())
> +		cpu = 0;
> +
>  	exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
>  	return 0;
>  }
>  
>  static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
>  {
> -	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c + 4*cpu;
> +	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c;
> +
> +	if (!soc_is_exynos4212())
> +		boot_reg += 4*cpu;
>  
>  	__raw_writel(boot_addr, boot_reg);
>  	return 0;
> 

