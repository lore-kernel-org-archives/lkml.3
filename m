Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbaLHLbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:31:31 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:59128 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbaLHLb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:31:28 -0500
X-AuditID: cbfee691-f79b86d000004a5a-b8-54858c0eaea3
Message-id: <54858C13.8020704@samsung.com>
Date: Mon, 08 Dec 2014 17:01:31 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Inha Song <ideal.song@samsung.com>
Subject: Re: [PATCH 03/19] clk: samsung: exynos5433: Add clocks for CMU_PERIC
 domain
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
 <1417510196-6714-4-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1417510196-6714-4-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWyRsSkSpevpzXE4H+fjMXjNYuZLP5OOsZu
	8X5ZD6PF5f3aFte/PGe1mH/kHKvFnwmtbBa7/t5ntJh0fwKLxY1fbawWvQuuslmcbXrDbrHp
	8TVWi8u75rBZzDi/D2jInX9sFkuvX2SyOHX9M5vF4TftrBYzJr9ks1i16w+jxcuPJ1gcxDzW
	zFvD6PH71yRGj52z7rJ7bF5S73HlRBOrR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGW8nLOE
	teC6d8Wma1eYGhgf2HcxcnBICJhIzNvC18XICWSKSVy4t56ti5GLQ0hgKaNE35aDTBAJE4kV
	09YzQSQWMUpsmryXBcJpZZLonvKDEaSKV0BL4smHKcwgNouAqsSh9bvAbDYBXYkn7+eC2aIC
	ERJX1syBqheU+DH5HguILSKQLfH0zWGw1cwC95kl5j7pZgVJCAuESfRMe8EOYgsJ1EtcWroB
	rJlTwFXiWf9rsDizgK3EgvfrWCBseYnNa94ygwySEDjBIbF/81dWiIsEJL5NPsQC8bOsxKYD
	zBCvSUocXHGDZQKj2CwkN81CMnYWkrELGJlXMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYgSm
	h9P/nk3cwXj/gPUhRgEORiUe3gUPWkKEWBPLiitzDzGaAl0xkVlKNDkfmITySuINjc2MLExN
	TI2NzC3NlMR5daR/BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgXKVhO2PXz5nScelZn2zX
	mXhJsWv+WdW3ccG5/4aXKqOZC8XbXoeu1Zik//vntYfO9U84aoLOn35ygHejWePMkLczWNPf
	LbLYtWW5iGNw9nafu4Xpd98tK+Hjr/x4Z9r6c9vfOKr5z3sp28dX3dDu/8NF/oMk4+UjHi5n
	nfM+Rk/6denql+UL2JRYijMSDbWYi4oTAQYL6xQKAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsVy+t9jAV2+ntYQgzP7BCwer1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbPY9fc+o8Wk+xNYLG78amO16F1wlc3ibNMbdotN
	j6+xWlzeNYfNYsb5fUBD7vxjs1h6/SKTxanrn9ksDr9pZ7WYMfklm8WqXX8YLV5+PMHiIOax
	Zt4aRo/fvyYxeuycdZfdY/OSeo8rJ5pYPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv
	3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoNSWFssScUqBQQGJxsZK+HaYJoSFu
	uhYwjRG6viFBcD1GBmggYQ1jxss5S1gLrntXbLp2hamB8YF9FyMnh4SAicSKaeuZIGwxiQv3
	1rN1MXJxCAksYpTYNHkvC4TTyiTRPeUHI0gVr4CWxJMPU5hBbBYBVYlD63eB2WwCuhJP3s8F
	s0UFIiSurJkDVS8o8WPyPRYQW0QgW+Lpm8NgG5gF7jNLzH3SzQqSEBYIk+iZ9oIdxBYSqJe4
	tHQDWDOngKvEs/7XYHFmAVuJBe/XsUDY8hKb17xlnsAoMAvJjllIymYhKVvAyLyKUTS1ILmg
	OCk911CvODG3uDQvXS85P3cTIzj9PJPawbiyweIQowAHoxIP74IHLSFCrIllxZW5hxglOJiV
	RHgT41pDhHhTEiurUovy44tKc1KLDzGaAoNgIrOUaHI+MDXmlcQbGpuYmxqbWppYmJhZKonz
	3riZGyIkkJ5YkpqdmlqQWgTTx8TBKdXAOEHuJevkG4c9+GYylZ4J6fObk7BWhcGJ5/7H33e1
	b9tO1t324tjWcvUQk0d16dJf1tpxeISFL7wiX6Gl5xnw/1Ot2IsND7QCLTY45NQ+sXnAFhh/
	4aCzn9x1hgfL2Db371Rcc8v82emNWt4Xu/4H+36f2FSSY1X6PyzCYOG0u20S732nL58vrMRS
	nJFoqMVcVJwIAHNwrkZVAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Tuesday 02 December 2014 02:19 PM, Chanwoo Choi wrote:
> This patch adds missing divider/gate clocks of CMU_PERIC domain
> which includes I2S/PCM/SPDIF/PWM/SLIMBUS IPs. The SPI/I2S may use
> external input clock which has 'ioclk_*' prefix.
>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> [ideal.song: Change clk flags of to pclk_gpio_* clk, pclk_gpio_* should be always on.]
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---
>   drivers/clk/samsung/clk-exynos5433.c   | 80 +++++++++++++++++++++++++++++++++-
>   include/dt-bindings/clock/exynos5433.h | 34 ++++++++++++++-
>   2 files changed, 112 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
> index 88e8cac..a48b36c 100644
> --- a/drivers/clk/samsung/clk-exynos5433.c
> +++ b/drivers/clk/samsung/clk-exynos5433.c
> @@ -256,6 +256,14 @@ static struct samsung_fixed_rate_clock top_fixed_clks[] __initdata = {
>   	FRATE(0, "ioclk_audiocdclk0", NULL, CLK_IS_ROOT, 100000000),
>   	/* Xi2s1SDI input clock for SPDIF */
>   	FRATE(0, "ioclk_spdif_extclk", NULL, CLK_IS_ROOT, 100000000),
> +	/* XspiCLK[4:0] input clock for SPI */
> +	FRATE(0, "ioclk_spi4_clk_in", NULL, CLK_IS_ROOT, 50000000),
> +	FRATE(0, "ioclk_spi3_clk_in", NULL, CLK_IS_ROOT, 50000000),
> +	FRATE(0, "ioclk_spi2_clk_in", NULL, CLK_IS_ROOT, 50000000),
> +	FRATE(0, "ioclk_spi1_clk_in", NULL, CLK_IS_ROOT, 50000000),
> +	FRATE(0, "ioclk_spi0_clk_in", NULL, CLK_IS_ROOT, 50000000),
> +	/* Xi2s1SCLK input clock for I2S1_BCLK */
> +	FRATE(0, "ioclk_i2s1_bclk_in", NULL, CLK_IS_ROOT, 12288000),
>   };
>
>   static struct samsung_mux_clock top_mux_clks[] __initdata = {
> @@ -760,6 +768,7 @@ CLK_OF_DECLARE(exynos5433_cmu_mif, "samsung,exynos5433-cmu-mif",
>    * Register offset definitions for CMU_PERIC
>    */
>   #define DIV_PERIC			0x0600
> +#define DIV_STAT_PERIC			0x0700
>   #define ENABLE_ACLK_PERIC		0x0800
>   #define ENABLE_PCLK_PERIC0		0x0900
>   #define ENABLE_PCLK_PERIC1		0x0904
> @@ -770,6 +779,7 @@ CLK_OF_DECLARE(exynos5433_cmu_mif, "samsung,exynos5433-cmu-mif",
>
>   static unsigned long peric_clk_regs[] __initdata = {
>   	DIV_PERIC,
> +	DIV_STAT_PERIC,

IMO, this line should have been added in first place itself when you 
added peric_clk_regs.

>   	ENABLE_ACLK_PERIC,
>   	ENABLE_PCLK_PERIC0,
>   	ENABLE_PCLK_PERIC1,
> @@ -779,14 +789,57 @@ static unsigned long peric_clk_regs[] __initdata = {
>   	ENABLE_IP_PERIC2,
>   };
>
> +static struct samsung_div_clock peric_div_clks[] __initdata = {
> +	/* DIV_PERIC */
> +	DIV(CLK_DIV_SCLK_SCI, "div_sclk_sci", "fin_pll", DIV_PERIC, 4, 8),

As per UM I have DIV_SCLK_SCI has 4 bit wide as [7:4] please cross verify.

> +	DIV(CLK_DIV_SCLK_SC_IN, "div_sclk_sc_in", "fin_pll", DIV_PERIC, 0, 4),
> +};
> +
>   static struct samsung_gate_clock peric_gate_clks[] __initdata = {
> +	/* ENABLE_ACLK_PERIC */
> +	GATE(CLK_ACLK_AHB2APB_PERIC2P, "aclk_ahb2apb_peric2p", "aclk_peric_66",
> +			ENABLE_ACLK_PERIC, 3, CLK_IGNORE_UNUSED, 0),
> +	GATE(CLK_ACLK_AHB2APB_PERIC1P, "aclk_ahb2apb_peric1p", "aclk_peric_66",
> +			ENABLE_ACLK_PERIC, 2, CLK_IGNORE_UNUSED, 0),
> +	GATE(CLK_ACLK_AHB2APB_PERIC0P, "aclk_ahb2apb_peric0p", "aclk_peric_66",
> +			ENABLE_ACLK_PERIC, 1, CLK_IGNORE_UNUSED, 0),
> +	GATE(CLK_ACLK_PERICNP_66, "aclk_pericnp_66", "aclk_peric_66",
> +			ENABLE_ACLK_PERIC, 0, CLK_IGNORE_UNUSED, 0),
> +
>   	/* ENABLE_PCLK_PERIC0 */
> +	GATE(CLK_PCLK_SCI, "pclk_sci", "aclk_peric_66", ENABLE_PCLK_PERIC0,
> +			31, CLK_SET_RATE_PARENT, 0),
> +	GATE(CLK_PCLK_GPIO_FINGER, "pclk_gpio_finger", "aclk_peric_66",
> +			ENABLE_PCLK_PERIC0, 30, CLK_IGNORE_UNUSED, 0),
> +	GATE(CLK_PCLK_GPIO_ESE, "pclk_gpio_ese", "aclk_peric_66",
> +			ENABLE_PCLK_PERIC0, 29, CLK_IGNORE_UNUSED, 0),
> +	GATE(CLK_PCLK_PWM, "pclk_pwm", "aclk_peric_66", ENABLE_PCLK_PERIC0,
> +			28, CLK_SET_RATE_PARENT, 0),
> +	GATE(CLK_PCLK_SPDIF, "pclk_spdif", "aclk_peric_66", ENABLE_PCLK_PERIC0,
> +			26, CLK_SET_RATE_PARENT, 0),
> +	GATE(CLK_PCLK_PCM1, "pclk_pcm1", "aclk_peric_66", ENABLE_PCLK_PERIC0,
> +			25, CLK_SET_RATE_PARENT, 0),
> +	GATE(CLK_PCLK_I2S1, "pclk_i2s", "aclk_peric_66", ENABLE_PCLK_PERIC0,
> +			24, CLK_SET_RATE_PARENT, 0),
>   	GATE(CLK_PCLK_SPI2, "pclk_spi2", "aclk_peric_66", ENABLE_PCLK_PERIC0,
>   			23, CLK_SET_RATE_PARENT, 0),
>   	GATE(CLK_PCLK_SPI1, "pclk_spi1", "aclk_peric_66", ENABLE_PCLK_PERIC0,
>   			22, CLK_SET_RATE_PARENT, 0),
>   	GATE(CLK_PCLK_SPI0, "pclk_spi0", "aclk_peric_66", ENABLE_PCLK_PERIC0,
>   			21, CLK_SET_RATE_PARENT, 0),
> +	GATE(CLK_PCLK_ADCIF, "pclk_adcif", "aclk_peric_66", ENABLE_PCLK_PERIC0,
> +			20, CLK_SET_RATE_PARENT, 0),
> +	GATE(CLK_PCLK_GPIO_TOUCH, "pclk_gpio_touch", "aclk_peric_66",
> +			ENABLE_PCLK_PERIC0, 19, CLK_IGNORE_UNUSED, 0),
> +	GATE(CLK_PCLK_GPIO_NFC, "pclk_gpio_nfc", "aclk_peric_66",
> +			ENABLE_PCLK_PERIC0, 18, CLK_IGNORE_UNUSED, 0),
> +	GATE(CLK_PCLK_GPIO_PERIC, "pclk_gpio_peric", "aclk_peric_66",
> +			ENABLE_PCLK_PERIC0, 17, CLK_IGNORE_UNUSED, 0),
> +	GATE(CLK_PCLK_PMU_PERIC, "pclk_pmu_peric", "aclk_peric_66",
> +			ENABLE_PCLK_PERIC0, 16, CLK_SET_RATE_PARENT, 0),
> +	GATE(CLK_PCLK_SYSREG_PERIC, "pclk_sysreg_peric", "aclk_peric_66",
> +			ENABLE_PCLK_PERIC0, 15,
> +			CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED, 0),
>   	GATE(CLK_PCLK_UART2, "pclk_uart2", "aclk_peric_66", ENABLE_PCLK_PERIC0,
>   			14, CLK_SET_RATE_PARENT, 0),
>   	GATE(CLK_PCLK_UART1, "pclk_uart1", "aclk_peric_66", ENABLE_PCLK_PERIC0,
> @@ -841,11 +894,34 @@ static struct samsung_gate_clock peric_gate_clks[] __initdata = {
>   			ENABLE_PCLK_PERIC1, 0, CLK_SET_RATE_PARENT, 0),
>
>   	/* ENABLE_SCLK_PERIC */
> +	GATE(CLK_SCLK_IOCLK_SPI4, "sclk_ioclk_spi4", "ioclk_spi4_clk_in",
> +			ENABLE_SCLK_PERIC, 21, CLK_SET_RATE_PARENT, 0),
> +	GATE(CLK_SCLK_IOCLK_SPI3, "sclk_ioclk_spi3", "ioclk_spi3_clk_in",
> +			ENABLE_SCLK_PERIC, 20, CLK_SET_RATE_PARENT, 0),
>   	GATE(CLK_SCLK_SPI4, "sclk_spi4", "sclk_spi4_peric", ENABLE_SCLK_PERIC,
>   			19, CLK_SET_RATE_PARENT, 0),
>   	GATE(CLK_SCLK_SPI3, "sclk_spi3", "sclk_spi3_peric", ENABLE_SCLK_PERIC,
>   			18, CLK_SET_RATE_PARENT, 0),
> -
> +	GATE(CLK_SCLK_SCI, "sclk_sci", "div_sclk_sci", ENABLE_SCLK_PERIC,
> +			17, 0, 0),
> +	GATE(CLK_SCLK_SC_IN, "sclk_sc_in", "div_sclk_sc_in", ENABLE_SCLK_PERIC,
> +			16, 0, 0),
> +	GATE(CLK_SCLK_PWM, "sclk_pwm", "fin_pll", ENABLE_SCLK_PERIC, 15, 0, 0),
> +	GATE(CLK_SCLK_IOCLK_SPI2, "sclk_ioclk_spi2", "ioclk_spi2_clk_in",
> +			ENABLE_SCLK_PERIC, 13, CLK_SET_RATE_PARENT, 0),
> +	GATE(CLK_SCLK_IOCLK_SPI1, "sclk_ioclk_spi1", "ioclk_spi1_clk_in",
> +			ENABLE_SCLK_PERIC, 12, CLK_SET_RATE_PARENT, 0),
> +	GATE(CLK_SCLK_IOCLK_SPI0, "sclk_ioclk_spi0", "ioclk_spi0_clk_in",
> +			ENABLE_SCLK_PERIC, 11, CLK_SET_RATE_PARENT, 0),
> +	GATE(CLK_SCLK_IOCLK_I2S1_BCLK, "sclk_ioclk_i2s1_bclk",
> +			"ioclk_i2s1_bclk_in", ENABLE_SCLK_PERIC, 10,
> +			CLK_SET_RATE_PARENT, 0),
> +	GATE(CLK_SCLK_SPDIF, "sclk_spdif", "sclk_spdif_peric",
> +			ENABLE_SCLK_PERIC, 8, CLK_SET_RATE_PARENT, 0),
> +	GATE(CLK_SCLK_PCM1, "sclk_pcm1", "sclk_pcm1_peric",
> +			ENABLE_SCLK_PERIC, 7, CLK_SET_RATE_PARENT, 0),
> +	GATE(CLK_SCLK_I2S1, "sclk_i2s1", "sclk_i2s1_peric",
> +			ENABLE_SCLK_PERIC, 6, CLK_SET_RATE_PARENT, 0),
>   	GATE(CLK_SCLK_SPI2, "sclk_spi2", "sclk_spi2_peric", ENABLE_SCLK_PERIC,
>   			5, CLK_SET_RATE_PARENT, 0),
>   	GATE(CLK_SCLK_SPI1, "sclk_spi1", "sclk_spi1_peric", ENABLE_SCLK_PERIC,
> @@ -861,6 +937,8 @@ static struct samsung_gate_clock peric_gate_clks[] __initdata = {
>   };
>
>   static struct samsung_cmu_info peric_cmu_info __initdata = {
> +	.div_clks		= peric_div_clks,
> +	.nr_div_clks		= ARRAY_SIZE(peric_div_clks),
>   	.gate_clks		= peric_gate_clks,
>   	.nr_gate_clks		= ARRAY_SIZE(peric_gate_clks),
>   	.nr_clk_ids		= PERIC_NR_CLK,
> diff --git a/include/dt-bindings/clock/exynos5433.h b/include/dt-bindings/clock/exynos5433.h
> index e0f7928..8535917 100644
> --- a/include/dt-bindings/clock/exynos5433.h
> +++ b/include/dt-bindings/clock/exynos5433.h
> @@ -181,8 +181,40 @@
>   #define CLK_SCLK_UART2			34
>   #define CLK_SCLK_UART1			35
>   #define CLK_SCLK_UART0			36
> +#define CLK_ACLK_AHB2APB_PERIC2P	37
> +#define CLK_ACLK_AHB2APB_PERIC1P	38
> +#define CLK_ACLK_AHB2APB_PERIC0P	39
> +#define CLK_ACLK_PERICNP_66		40
> +#define CLK_PCLK_SCI			41
> +#define CLK_PCLK_GPIO_FINGER		42
> +#define CLK_PCLK_GPIO_ESE		43
> +#define CLK_PCLK_PWM			44
> +#define CLK_PCLK_SPDIF			45
> +#define CLK_PCLK_PCM1			46
> +#define CLK_PCLK_I2S1			47
> +#define CLK_PCLK_ADCIF			48
> +#define CLK_PCLK_GPIO_TOUCH		49
> +#define CLK_PCLK_GPIO_NFC		50
> +#define CLK_PCLK_GPIO_PERIC		51
> +#define CLK_PCLK_PMU_PERIC		52
> +#define CLK_PCLK_SYSREG_PERIC		53
> +#define CLK_SCLK_IOCLK_SPI4		54
> +#define CLK_SCLK_IOCLK_SPI3		55
> +#define CLK_SCLK_SCI			56
> +#define CLK_SCLK_SC_IN			57
> +#define CLK_SCLK_PWM			58
> +#define CLK_SCLK_IOCLK_SPI2		59
> +#define CLK_SCLK_IOCLK_SPI1		60
> +#define CLK_SCLK_IOCLK_SPI0		61
> +#define CLK_SCLK_IOCLK_I2S1_BCLK	62
> +#define CLK_SCLK_SPDIF			63
> +#define CLK_SCLK_PCM1			64
> +#define CLK_SCLK_I2S1			65
>
> -#define PERIC_NR_CLK			37
> +#define CLK_DIV_SCLK_SCI		70
> +#define CLK_DIV_SCLK_SC_IN		71
> +
> +#define PERIC_NR_CLK			72
>
>   /* CMU_PERIS */
>   #define	CLK_PCLK_HPM_APBIF		1
>


Thanks,
Pankaj Dubey
