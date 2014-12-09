Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbaLIGE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 01:04:59 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:17313 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaLIGE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 01:04:57 -0500
X-AuditID: cbfee68f-f791c6d000004834-54-54869106d568
Message-id: <5486910D.8030606@samsung.com>
Date: Tue, 09 Dec 2014 11:35:01 +0530
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
Subject: Re: [PATCH 09/19] clk: samsung: exynos5433: Add clocks for
 CMU_BUS{0|1|2} domains
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
 <1417510196-6714-10-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1417510196-6714-10-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWyRsSkVpdtYluIwa92ZYvHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azOPymndVixuSXbBardv1htHj58QSLg6jHmnlrGD1+
	/5rE6LFz1l12j81L6j2unGhi9ejbsorR4/MmuQD2KC6blNSczLLUIn27BK6M+7tWsBW8k6v4
	9e8pSwPjFskuRk4OCQETiQu3bzFC2GISF+6tZwOxhQSWMkpsbBboYuQAq7l/DKicCyi8iFHi
	/ZZ/zBA1rUwS2/4Xgti8AloSZ3afAJvDIqAqcfvkDLA5bAK6Ek/ezwWrFxWIkLiyZg4jRL2g
	xI/J91hAbBGBbImnbw6zgSxgFtjJLHG+ewpYQlggRmLbum5miM0NjBKr1t4Am8Qp4CaxZckR
	MJtZwFZiwft1LBC2vMTmNW/BGiQEjnBItB6+yAJxkoDEt8mHWCDekZXYdIAZ4mNJiYMrbrBM
	YBSbheSoWUjGzkIydgEj8ypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MwJRw+t+z/h2Mdw9Y
	H2IU4GBU4uHVsGwLEWJNLCuuzD3EaAp0xURmKdHkfGDiySuJNzQ2M7IwNTE1NjK3NFMS510o
	9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6OLh1rP88BpDmLf3YWlbzPu2uKeuWLSoR2R
	dzj28j6K7KsxOerr0Vuh90w1jGnLGvFORg+xVZ46av/D/joZ7L7RJ2X7+/W38zVntBSFDjEz
	CBScmh2gxrVaSM917ZN43fKy2RzH/SazbnfSvhjGYvvF4dLfe06lZvfV9dYxHMi2Mhb6nG4l
	oMRSnJFoqMVcVJwIAPvT+jEEAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jAV22iW0hBleOSFg8XrOYyeLvpGPs
	Fu+X9TBaXN6vbXH9y3NWi/lHzrFa/JnQymYx6f4EFosbv9pYLXoXXGWzONv0ht1i0+NrrBaX
	d81hs5hxfh9Q/51/bBZLr19ksjh1/TObxeE37awWMya/ZLNYtesPo8XLjydYHEQ91sxbw+jx
	+9ckRo+ds+6ye2xeUu9x5UQTq0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfH
	O8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAfaWkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC
	1zckCK7HyAANJKxhzLi/awVbwTu5il//nrI0MG6R7GLk4JAQMJG4fwzI5AQyxSQu3FvP1sXI
	xSEksIhR4v2Wf8wgCSGBViaJbf8LQWxeAS2JM7tPMILYLAKqErdPzmADsdkEdCWevJ8LVi8q
	ECFxZc0cRoh6QYkfk++xgNgiAtkST98cBlvALLCTWeJ89xSwhLBAjMS2dd3MEJsbGCVWrb0B
	NolTwE1iy5IjYDazgK3EgvfrWCBseYnNa94yT2AUmIVkySwkZbOQlC1gZF7FKJpakFxQnJSe
	a6RXnJhbXJqXrpecn7uJEZxynknvYFzVYHGIUYCDUYmHV8OyLUSINbGsuDL3EKMEB7OSCO/9
	OqAQb0piZVVqUX58UWlOavEhRlNgGExklhJNzgemw7ySeENjE3NTY1NLEwsTM0slcV4le6Am
	gfTEktTs1NSC1CKYPiYOTqkGRknfK88bDF8siznglcC8wjucXfi70SvVefNUxER+HL62dO/u
	CY/t05bNnvD2eVXxzLxrebvVZ89Kfz/l0Onm8ytq1eKYGD3nmKwt/G4y83DymruZd75fcqlV
	dkzYyyizsuTylGRuDeawswcmT5/s5honb3Uoc+O1XeF3DcKW6K5eXHjr59MVGg+VWIozEg21
	mIuKEwE3Y4KUTwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Tuesday 02 December 2014 02:19 PM, Chanwoo Choi wrote:
> This patch adds the mux/divider/gate clocks for CMU_BUS{0|1|2} domains
> which contain global data buses clocked at up the 400MHz. These blocks
> transfer data between DRAM and various sub-blocks. These clock domains
> also contain global peripheral buses clocked at 67/111/200/222/266/333/400
> MHz and used for regiser accesses.

typo: %s/regiser/register

>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---
>   .../devicetree/bindings/clock/exynos5433-clock.txt |  21 +++
>   drivers/clk/samsung/clk-exynos5433.c               | 185 ++++++++++++++++++++-
>   include/dt-bindings/clock/exynos5433.h             |  29 +++-
>   3 files changed, 232 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
> index 9a6ae75..03ae40a 100644
> --- a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
> +++ b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
> @@ -25,6 +25,9 @@ Required Properties:
>       which generates clocks for Display (DECON/HDMI/DSIM/MIXER) IPs.
>     - "samsung,exynos5433-cmu-aud"   - clock controller compatible for CMU_AUD
>       which generates clocks for Cortex-A5/BUS/AUDIO clocks.
> +  - "samsung,exynos5433-cmu-bus0", "samsung,exynos5433-cmu-bus1"
> +    and "samsung,exynos5433-cmu-bus2" - clock controller compatible for CMU_BUS
> +    which generates global data buses clock and global peripheral buses clock.
>
>   - reg: physical base address of the controller and length of memory mapped
>     region.
> @@ -94,6 +97,24 @@ Example 1: Examples of clock controller nodes are listed below.
>   		#clock-cells = <1>;
>   	};
>
> +	cmu_bus0: clock-controller@0x13600000 {
> +		compatible = "samsung,exynos5433-cmu-bus0";
> +		reg = <0x13600000 0x0b04>;
> +		#clock-cells = <1>;
> +	};
> +
> +	cmu_bus1: clock-controller@0x14800000 {
> +		compatible = "samsung,exynos5433-cmu-bus1";
> +		reg = <0x14800000 0x0b04>;
> +		#clock-cells = <1>;
> +	};
> +
> +	cmu_bus2: clock-controller@0x13400000 {
> +		compatible = "samsung,exynos5433-cmu-bus2";
> +		reg = <0x13400000 0x0b04>;
> +		#clock-cells = <1>;
> +	};
> +
>   Example 2: UART controller node that consumes the clock generated by the clock
>   	   controller.
>
> diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
> index 99262e0..5b4ec83 100644
> --- a/drivers/clk/samsung/clk-exynos5433.c
> +++ b/drivers/clk/samsung/clk-exynos5433.c
> @@ -425,7 +425,7 @@ static struct samsung_div_clock top_div_clks[] __initdata = {
>   			DIV_TOP2, 0, 3),
>
>   	/* DIV_TOP3 */
> -	DIV(CLK_DIV_ACLK_IMEM_SSSX, "div_aclk_imem_sssx",
> +	DIV(CLK_DIV_ACLK_IMEM_SSSX_266, "div_aclk_imem_sssx_266",

This change can be moved to patch 1/19 itself.

>   			"mout_bus_pll_user", DIV_TOP3, 24, 3),
>   	DIV(CLK_DIV_ACLK_IMEM_200, "div_aclk_imem_200",
>   			"mout_bus_pll_user", DIV_TOP3, 20, 3),
> @@ -440,6 +440,14 @@ static struct samsung_div_clock top_div_clks[] __initdata = {
>   	DIV(CLK_DIV_ACLK_PERIS_66_A, "div_aclk_peris_66_a",
>   			"mout_bus_pll_user", DIV_TOP3, 0, 3),
>
> +	/* DIV_TOP4 */
> +	DIV(CLK_DIV_ACLK_G3D_400, "div_aclk_g3d_400", "mout_bus_pll_user",
> +			DIV_TOP4, 8, 3),
> +	DIV(CLK_DIV_ACLK_BUS0_400, "div_aclk_bus0_400", "mout_aclk_bus0_400",
> +			DIV_TOP4, 4, 3),
> +	DIV(CLK_DIV_ACLK_BUS1_400, "div_aclk_bus1_400", "mout_bus_pll_user",
> +			DIV_TOP4, 0, 3),
> +

With these changes you can have:

Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>

Thanks,
Pankaj Dubey
