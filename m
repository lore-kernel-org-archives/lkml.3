Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbaLIGF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 01:05:27 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:29007 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448AbaLIGFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 01:05:23 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-28-54869121a3fd
Message-id: <54869127.6030307@samsung.com>
Date: Tue, 09 Dec 2014 11:35:27 +0530
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
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 08/19] clk: samsung: exynos5433: Add clocks for CMU_AUD
 domain
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
 <1417510196-6714-9-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1417510196-6714-9-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsWyRsSkRldxYluIwekFMhaP1yxmsvg76Ri7
	xftlPYwWl/drW1z/8pzVYv6Rc6wWfya0sllMuj+BxeLGrzZWi94FV9kszja9YbfY9Pgaq8Xl
	XXPYLGac3wfUf+cfm8XS6xeZLE5d/8xmcfhNO6vFjMkv2SxW7frDaPHy4wkWB1GPNfPWMHr8
	/jWJ0WPnrLvsHpuX1HtcOdHE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZ8yalFUxWqehb
	up+9gfGGbBcjJ4eEgInE8/kXWCBsMYkL99azdTFycQgJLGWUOHB8CVCCA6xoxeIgiPgiRold
	N3rYIZxWJokzZ8+xg3TzCmhJ/Pv7lhXEZhFQlVjQvQ3MZhPQlXjyfi4ziC0qECFxZc0cRoh6
	QYkfk++BbRYRyJZ4+uYw2GZmgZ3MEue7p4AlhAVCJL4cbgNbICRQLzH/zmI2kIs4BVwlXu92
	AwkzC9hKLHi/jgXClpfYvOYtM8gcCYEjHBI/p65mhzhIQOLb5ENQ38hKbDrADPGxpMTBFTdY
	JjCKzUJy0iwkY2chGbuAkXkVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRmBCOP3v2YQdjPcO
	WB9iFOBgVOLh1bBsCxFiTSwrrsw9xGgKdMVEZinR5Hxg2skriTc0NjOyMDUxNTYytzRTEud9
	LfUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjeGmVz7/ZZ3a8tfLy9OW3WLtxx+d25dQ0
	b8bjSSxZ+t49recevHzQUb4ie/EkRck7937ZvW89cDf8e06woG1t946vX57osC3yl7EMkH4R
	3bpwtZ/C5il5rNVrRI463zlcccngfs8SNf/P4k1LZrBlHOr0ema2Qzdqh8Ny86Vvpspa3BCd
	6DxDiaU4I9FQi7moOBEA5CPpmAMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t9jAV3FiW0hBnOWC1k8XrOYyeLvpGPs
	Fu+X9TBaXN6vbXH9y3NWi/lHzrFa/JnQymYx6f4EFosbv9pYLXoXXGWzONv0ht1i0+NrrBaX
	d81hs5hxfh9Q/51/bBZLr19ksjh1/TObxeE37awWMya/ZLNYtesPo8XLjydYHEQ91sxbw+jx
	+9ckRo+ds+6ye2xeUu9x5UQTq0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfH
	O8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAfaWkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC
	1zckCK7HyAANJKxhzJg3Ka1gskpF39L97A2MN2S7GDk4JARMJFYsDupi5AQyxSQu3FvP1sXI
	xSEksIhRYteNHnYIp5VJ4szZc+wgVbwCWhL//r5lBbFZBFQlFnRvA7PZBHQlnryfywxiiwpE
	SFxZM4cRol5Q4sfkeywgtohAtsTTN4fBNjAL7GSWON89BSwhLBAi8eVwG9gCIYF6ifl3FrOB
	XMcp4CrxercbSJhZwFZiwft1LBC2vMTmNW+ZJzAKzEKyYhaSsllIyhYwMq9iFE0tSC4oTkrP
	NdIrTswtLs1L10vOz93ECE43z6R3MK5qsDjEKMDBqMTDq2HZFiLEmlhWXJl7iFGCg1lJhPd+
	HVCINyWxsiq1KD++qDQntfgQoykwBCYyS4km5wNTYV5JvKGxibmpsamliYWJmaWSOK+SPVCT
	QHpiSWp2ampBahFMHxMHp1QDo0b20hDbuWJbd3B58aZqLSmNfGd9/F5ad/MrrU0f994+bnix
	8bKh+tEPu2pVjt7TO8wZdP/HpI3bdffHd1h+mttW+NJfzG3Kqu2yojfmekfx5E1bYDxh0eVe
	JofXcyzPLvq669VUve77FSsPcds+UmiwvR1zMTnD8cTN7spEw13rbdyDliYt51ViKc5INNRi
	LipOBAAbdXQpTQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Tuesday 02 December 2014 02:19 PM, Chanwoo Choi wrote:
> This patch adds the mux/divider/gate clocks for CMU_AUD domain which
> includes the clocks of Cortex-A6/Bus/Audio clocks.

Cortex-A6? I think it should be Cortex-A5?

>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---
>   .../devicetree/bindings/clock/exynos5433-clock.txt |   7 +
>   drivers/clk/samsung/clk-exynos5433.c               | 173 +++++++++++++++++++++
>   include/dt-bindings/clock/exynos5433.h             |  53 +++++++
>   3 files changed, 233 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
> index 8d3dad4..9a6ae75 100644
> --- a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
> +++ b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
> @@ -23,6 +23,8 @@ Required Properties:
>       which generates clocks for G2D/MDMA IPs.
>     - "samsung,exynos5433-cmu-disp"  - clock controller compatible for CMU_DISP
>       which generates clocks for Display (DECON/HDMI/DSIM/MIXER) IPs.
> +  - "samsung,exynos5433-cmu-aud"   - clock controller compatible for CMU_AUD
> +    which generates clocks for Cortex-A5/BUS/AUDIO clocks.

Commit message says Cortex-A6?

>
>   - reg: physical base address of the controller and length of memory mapped
>     region.
> @@ -86,6 +88,11 @@ Example 1: Examples of clock controller nodes are listed below.
>   		#clock-cells = <1>;
>   	};
>
> +	cmu_aud: clock-controller@0x114c0000 {
> +		compatible = "samsung,exynos5433-cmu-aud";
> +		reg = <0x114c0000 0x0b04>;
> +		#clock-cells = <1>;
> +	};
>
>   Example 2: UART controller node that consumes the clock generated by the clock
>   	   controller.
> diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
> index ec23e97..99262e0 100644
> --- a/drivers/clk/samsung/clk-exynos5433.c
> +++ b/drivers/clk/samsung/clk-exynos5433.c
> @@ -2454,3 +2454,176 @@ static void __init exynos5433_cmu_disp_init(struct device_node *np)
>
>   CLK_OF_DECLARE(exynos5433_cmu_disp, "samsung,exynos5433-cmu-disp",
>   		exynos5433_cmu_disp_init);
> +
> +/*
> + * Register offset definitions for CMU_AUD
> + */
> +#define MUX_SEL_AUD0			0x0200
> +#define MUX_SEL_AUD1			0x0204
> +#define MUX_ENABLE_AUD0			0x0300
> +#define MUX_ENABLE_AUD1			0x0304
> +#define MUX_STAT_AUD0			0x0400
> +#define DIV_AUD0			0x0600
> +#define DIV_AUD1			0x0604
> +#define DIV_STAT_AUD0			0x0700
> +#define DIV_STAT_AUD1			0x0704
> +#define ENABLE_ACLK_AUD			0x0800
> +#define ENABLE_PCLK_AUD			0x0900
> +#define ENABLE_SCLK_AUD0		0x0a00
> +#define ENABLE_SCLK_AUD1		0x0a04
> +#define ENABLE_IP_AUD0			0x0b00
> +#define ENABLE_IP_AUD1			0x0b04
> +
> +static unsigned long aud_clk_regs[] __initdata = {
> +	MUX_SEL_AUD0,
> +	MUX_SEL_AUD1,
> +	MUX_ENABLE_AUD0,
> +	MUX_ENABLE_AUD1,
> +	MUX_STAT_AUD0,
> +	DIV_AUD0,
> +	DIV_AUD1,
> +	DIV_STAT_AUD0,
> +	DIV_STAT_AUD1,
> +	ENABLE_ACLK_AUD,
> +	ENABLE_PCLK_AUD,
> +	ENABLE_SCLK_AUD0,
> +	ENABLE_SCLK_AUD1,
> +	ENABLE_IP_AUD0,
> +	ENABLE_IP_AUD1,
> +};
> +
> +/* list of all parent clock list */
> +PNAME(mout_aud_pll_user_aud_p)	= { "fin_pll", "fout_aud_pll", };
> +PNAME(mout_sclk_aud_pcm_p)	= { "mout_aud_pll_user", "ioclk_audiocdclk0",};
> +PNAME(mout_sclk_aud_i2s_p)	= { "mout_aud_pll_user", "ioclk_audiocdclk0",};

Above two lines can be clubbed with some common name as both has same 
parent clocks.

> +
> +static struct samsung_fixed_rate_clock aud_fixed_clks[] __initdata = {
> +	FRATE(0, "ioclk_jtag_tclk", NULL, CLK_IS_ROOT, 188000000),
> +	FRATE(0, "ioclk_slimbus_clk", NULL, CLK_IS_ROOT, 188000000),
> +	FRATE(0, "ioclk_i2s_bclk", NULL, CLK_IS_ROOT, 188000000),

Are you sure about these clock rates?
As per UM I have, these are having rates as 33 MHz, 25 MHz and 50 MHz 
respectively.

> +};
> +
> +static struct samsung_mux_clock aud_mux_clks[] __initdata = {
> +	/* MUX_SEL_AUD0 */
> +	MUX(CLK_MOUT_AUD_PLL_USER, "mout_aud_pll_user",
> +			mout_aud_pll_user_aud_p, MUX_SEL_AUD0, 0, 1),
> +
> +	/* MUX_SEL_AUD1 */
> +	MUX(CLK_MOUT_SCLK_AUD_PCM, "mout_sclk_aud_pcm", mout_sclk_aud_pcm_p,
> +			MUX_SEL_AUD1, 8, 1),
> +	MUX(CLK_MOUT_SCLK_AUD_I2S, "mout_sclk_aud_i2s", mout_sclk_aud_i2s_p,
> +			MUX_SEL_AUD1, 0, 1),
> +};
> +

Thanks,
Pankaj Dubey
