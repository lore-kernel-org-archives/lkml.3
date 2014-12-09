Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbaLIGGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 01:06:45 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:17740 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbaLIGGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 01:06:43 -0500
X-AuditID: cbfee68e-f79b46d000002b74-18-54869165eaa0
Message-id: <54869167.1010007@samsung.com>
Date: Tue, 09 Dec 2014 11:36:31 +0530
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
Subject: Re: [PATCH 07/19] clk: samsung: exynos5433: Add clocks for CMU_DISP
 domain
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
 <1417510196-6714-8-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1417510196-6714-8-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkVjd1YluIwazzshaP1yxmsvg76Ri7
	xftlPYwWl/drW1z/8pzVYv6Rc6wWfya0sllMuj+BxeLGrzZWi94FV9kszja9YbfY9Pgaq8Xl
	XXPYLGac3wfUf+cfm8XS6xeZLE5d/8xmcfhNO6vFjMkv2SxW7frDaPHy4wkWB1GPNfPWMHr8
	/jWJ0WPnrLvsHpuX1HtcOdHE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZnUcSC5oiK2ZM
	Xs7UwHjes4uRk0NCwERi99/TzBC2mMSFe+vZuhi5OIQEljJKzGrYwQ5T9O/7F3aIxCJGiXt7
	djBCOK1MEp3fV7GAVPEKaEls3/aaFcRmEVCVmP9nPpjNJqAr8eT9XLAVogIRElfWzGGEqBeU
	+DH5HliviEC2xNM3h8FWMwvsZJY43z0FLCEsECrReewME4gtJFAvsWfZZrCTOAVcJZp/7GcD
	sZkFbCUWvF/HAmHLS2xe85YZZJCEwB4Oif//97NAXCQg8W3yISCbAyghK7HpANTPkhIHV9xg
	mcAoNgvJTbOQjJ2FZOwCRuZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIFJ4fS/Z307GG8e
	sD7EKMDBqMTDq2nZFiLEmlhWXJl7iNEU6IqJzFKiyfnA1JNXEm9obGZkYWpiamxkbmmmJM6b
	IPUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOjroBpCVcIT7w8IwObNJPhkpi0Pf9ZnW5F
	2TvqywWvVdV+c9rNxfB+nsuPNffv7vp0Ujuz5dLTlj+bmSun+YptYDBMqrNut4madPKpcGWe
	hczJxU5KBiuybTdcTjsavoXnT1rgSqFXrraXVi6+UKzmPynxfS571uy1l7eq7J1u2HBs8aOo
	qHdKLMUZiYZazEXFiQCUXxIiBQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jAd3UiW0hBsfmClo8XrOYyeLvpGPs
	Fu+X9TBaXN6vbXH9y3NWi/lHzrFa/JnQymYx6f4EFosbv9pYLXoXXGWzONv0ht1i0+NrrBaX
	d81hs5hxfh9Q/51/bBZLr19ksjh1/TObxeE37awWMya/ZLNYtesPo8XLjydYHEQ91sxbw+jx
	+9ckRo+ds+6ye2xeUu9x5UQTq0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfH
	O8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAfaWkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC
	1zckCK7HyAANJKxhzOg8kljQFFkxY/JypgbG855djJwcEgImEv++f2GHsMUkLtxbz9bFyMUh
	JLCIUeLenh2MEE4rk0Tn91UsIFW8AloS27e9ZgWxWQRUJeb/mQ9mswnoSjx5P5cZxBYViJC4
	smYOI0S9oMSPyffAekUEsiWevjkMtoFZYCezxPnuKWAJYYFQic5jZ5hAbCGBeok9yzaDncQp
	4CrR/GM/G4jNLGArseD9OhYIW15i85q3zBMYBWYh2TELSdksJGULGJlXMYqmFiQXFCel5xrq
	FSfmFpfmpesl5+duYgSnnGdSOxhXNlgcYhTgYFTi4dW0bAsRYk0sK67MPcQowcGsJMJ7vw4o
	xJuSWFmVWpQfX1Sak1p8iNEUGAQTmaVEk/OB6TCvJN7Q2MTc1NjU0sTCxMxSSZxXyR6oSSA9
	sSQ1OzW1ILUIpo+Jg1OqgTG94gOvzgz5k06p2jZbrbkC+gN/3pCYLBnbuLctx5Ftp9EHm4yo
	P/VHIr6K6WoeDZ3kIZys8kYpLP7lyw0BBQk9zaoBqUGqM11nhbYXcpQKrPZsj3bmmPrQa6OV
	gOSs5sYr9T77jnZw314gGuu+fGHfK5XWmozt99PdZjsfaZjF++9kEtMrJZbijERDLeai4kQA
	lK94v08DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Tuesday 02 December 2014 02:19 PM, Chanwoo Choi wrote:
> This patch adds the the mux/divider/gate clocks for CMU_DISP domain which
> includes the clocks of Display IPs (DECON/HDMI/DSIM/MIXER). The CMU_DISP clocks
> is used to need the source clock of CMU_MIF domain so, the CMU_MIF's clocks
> related to CMU_DISP should be always on state.
>
> Also, CMU_DISP must need the source clock of 'sclk_hdmi_spdif_disp'
> from CMU_TOP domain. This patch adds the clocks of CMU_TOP related to HDMI.
>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---
>   .../devicetree/bindings/clock/exynos5433-clock.txt |   9 +
>   drivers/clk/samsung/clk-exynos5433.c               | 465 ++++++++++++++++++++-
>   include/dt-bindings/clock/exynos5433.h             | 114 ++++-
>   3 files changed, 577 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
> index 27dd77b..8d3dad4 100644
> --- a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
> +++ b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
> @@ -21,6 +21,8 @@ Required Properties:
>       which generates clocks for USB/UFS/SDMMC/TSI/PDMA IPs.
>     - "samsung,exynos5433-cmu-g2d"   - clock controller compatible for CMU_G2D
>       which generates clocks for G2D/MDMA IPs.
> +  - "samsung,exynos5433-cmu-disp"  - clock controller compatible for CMU_DISP
> +    which generates clocks for Display (DECON/HDMI/DSIM/MIXER) IPs.
>
>   - reg: physical base address of the controller and length of memory mapped
>     region.
> @@ -78,6 +80,13 @@ Example 1: Examples of clock controller nodes are listed below.
>   		#clock-cells = <1>;
>   	};
>
> +	cmu_disp: clock-controller@0x13b90000 {
> +		compatible = "samsung,exynos5433-cmu-disp";
> +		reg = <0x13b90000 0x0c04>;
> +		#clock-cells = <1>;
> +	};
> +
> +
>   Example 2: UART controller node that consumes the clock generated by the clock
>   	   controller.
>
> diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
> index 10197a1..ec23e97 100644
> --- a/drivers/clk/samsung/clk-exynos5433.c
> +++ b/drivers/clk/samsung/clk-exynos5433.c
> @@ -245,6 +245,8 @@ PNAME(mout_sclk_audio1_p)	= { "ioclk_audiocdclk1", "fin_pll",
>   PNAME(mout_sclk_audio0_p)	= { "ioclk_audiocdclk0", "fin_pll",
>   				    "mout_aud_pll_user_t",};
>
> +PNAME(mout_sclk_hdmi_spdif_p)	= { "sclk_audio1", "ioclk_spdif_extclk", };
> +
>   static struct samsung_fixed_factor_clock top_fixed_factor_clks[] __initdata = {
>   	FFACTOR(0, "sclk_bus_pll", "fout_bus_pll", 1, 1, 0),
>   	FFACTOR(0, "sclk_mfc_pll", "fout_mfc_pll", 1, 1, 0),
> @@ -397,6 +399,10 @@ static struct samsung_mux_clock top_mux_clks[] __initdata = {
>   			MUX_SEL_TOP_PERIC1, 4, 2),
>   	MUX(CLK_MOUT_SCLK_AUDIO0, "mout_sclk_audio0", mout_sclk_audio0_p,
>   			MUX_SEL_TOP_PERIC1, 0, 2),
> +
> +	/* MUX_SEL_TOP_DISP */
> +	MUX(CLK_MOUT_SCLK_HDMI_SPDIF, "mout_sclk_hdmi_spdif",
> +			mout_sclk_hdmi_spdif_p, MUX_SEL_TOP_DISP, 0, 1),
>   };
>
>   static struct samsung_div_clock top_div_clks[] __initdata = {
> @@ -1256,9 +1262,9 @@ static struct samsung_gate_clock mif_gate_clks[] __initdata = {
>
>   	/* ENABLE_ACLK_MIF3 */
>   	GATE(CLK_ACLK_BUS2_400, "aclk_bus2_400", "div_aclk_bus2_400",
> -			ENABLE_ACLK_MIF3, 4, 0, 0),
> +			ENABLE_ACLK_MIF3, 4, CLK_IGNORE_UNUSED, 0),
>   	GATE(CLK_ACLK_DISP_333, "aclk_disp_333", "div_aclk_disp_333",
> -			ENABLE_ACLK_MIF3, 1, 0, 0),
> +			ENABLE_ACLK_MIF3, 1, CLK_IGNORE_UNUSED, 0),
>   	GATE(CLK_ACLK_CPIF_200, "aclk_cpif_200", "div_aclk_cpif_200",
>   			ENABLE_ACLK_MIF3, 0, CLK_IGNORE_UNUSED, 0),
>
> @@ -1333,21 +1339,30 @@ static struct samsung_gate_clock mif_gate_clks[] __initdata = {
>
>   	/* ENABLE_SCLK_MIF */
>   	GATE(CLK_SCLK_DSIM1_DISP, "sclk_dsim1_disp", "div_sclk_dsim1",
> -			ENABLE_SCLK_MIF, 15, 0, 0),
> +			ENABLE_SCLK_MIF, 15, CLK_IGNORE_UNUSED, 0),
>   	GATE(CLK_SCLK_DECON_TV_VCLK_DISP, "sclk_decon_tv_vclk_disp",
> -			"div_sclk_decon_tv_vclk", ENABLE_SCLK_MIF, 14, 0, 0),
> +			"div_sclk_decon_tv_vclk", ENABLE_SCLK_MIF,
> +			14, CLK_IGNORE_UNUSED, 0),
>   	GATE(CLK_SCLK_DSIM0_DISP, "sclk_dsim0_disp", "div_sclk_dsim0",
> -			ENABLE_SCLK_MIF, 9, 0, 0),
> +			ENABLE_SCLK_MIF, 9, CLK_IGNORE_UNUSED, 0),
>   	GATE(CLK_SCLK_DSD_DISP, "sclk_dsd_disp", "div_sclk_dsd",
> -			ENABLE_SCLK_MIF, 8, 0, 0),
> +			ENABLE_SCLK_MIF, 8, CLK_IGNORE_UNUSED, 0),
>   	GATE(CLK_SCLK_DECON_TV_ECLK_DISP, "sclk_decon_tv_eclk_disp",
> -			"div_sclk_decon_tv_eclk", ENABLE_SCLK_MIF, 7, 0, 0),
> +			"div_sclk_decon_tv_eclk", ENABLE_SCLK_MIF,
> +			7, CLK_IGNORE_UNUSED, 0),
>   	GATE(CLK_SCLK_DECON_VCLK_DISP, "sclk_decon_vclk_disp",
> -			"div_sclk_decon_vclk", ENABLE_SCLK_MIF, 6, 0, 0),
> +			"div_sclk_decon_vclk", ENABLE_SCLK_MIF,
> +			6, CLK_IGNORE_UNUSED, 0),
>   	GATE(CLK_SCLK_DECON_ECLK_DISP, "sclk_decon_eclk_disp",
> -			"div_sclk_decon_eclk", ENABLE_SCLK_MIF, 5, 0, 0),
> +			"div_sclk_decon_eclk", ENABLE_SCLK_MIF,
> +			5, CLK_IGNORE_UNUSED, 0),
>   	GATE(CLK_SCLK_HPM_MIF, "sclk_hpm_mif", "div_sclk_hpm_mif",
> -			ENABLE_SCLK_MIF, 4, 0, 0),
> +			ENABLE_SCLK_MIF, 4, CLK_IGNORE_UNUSED, 0),
> +
> +	/* ENABLE_SCLK_TOP_DISP */
> +	GATE(CLK_SCLK_HDMI_SPDIF_DISP, "sclk_hdmi_spdif_disp",
> +			"mout_sclk_hdmi_spdif", ENABLE_SCLK_TOP_DISP, 0,
> +			CLK_IGNORE_UNUSED, 0),
>   };
>
>   static struct samsung_cmu_info mif_cmu_info __initdata = {
> @@ -2009,3 +2024,433 @@ static void __init exynos5433_cmu_g2d_init(struct device_node *np)
>
>   CLK_OF_DECLARE(exynos5433_cmu_g2d, "samsung,exynos5433-cmu-g2d",
>   		exynos5433_cmu_g2d_init);
> +
> +/*
> + * Register offset definitions for CMU_DISP
> + */
> +#define DISP_PLL_LOCK			0x0000
> +#define DISP_PLL_CON0			0x0100
> +#define DISP_PLL_CON1			0x0104
> +#define DISP_PLL_FREQ_DET		0x0108
> +#define MUX_SEL_DISP0			0x0200
> +#define MUX_SEL_DISP1			0x0204
> +#define MUX_SEL_DISP2			0x0208
> +#define MUX_SEL_DISP3			0x020c
> +#define MUX_SEL_DISP4			0x0210
> +#define MUX_ENABLE_DISP0		0x0300
> +#define MUX_ENABLE_DISP1		0x0304
> +#define MUX_ENABLE_DISP2		0x0308
> +#define MUX_ENABLE_DISP3		0x030c
> +#define MUX_ENABLE_DISP4		0x0310
> +#define MUX_STAT_DISP0			0x0400
> +#define MUX_STAT_DISP1			0x0404
> +#define MUX_STAT_DISP2			0x0408
> +#define MUX_STAT_DISP3			0x040c
> +#define MUX_STAT_DISP4			0x0410
> +#define MUX_IGNORE_DISP2		0x0508
> +#define DIV_DISP			0x0600
> +#define DIV_DISP_PLL_FREQ_DET		0x0604
> +#define DIV_STAT_DISP			0x0700
> +#define DIV_STAT_DISP_PLL_FREQ_DET	0x0704
> +#define ENABLE_ACLK_DISP0		0x0800
> +#define ENABLE_ACLK_DISP1		0x0804
> +#define ENABLE_PCLK_DISP		0x0900
> +#define ENABLE_SCLK_DISP		0x0a00
> +#define ENABLE_IP_DISP0			0x0b00
> +#define ENABLE_IP_DISP1			0x0b04
> +#define CLKOUT_CMU_DISP			0x0c00
> +#define CLKOUT_CMU_DISP_DIV_STAT	0x0c04
> +
> +static unsigned long disp_clk_regs[] __initdata = {
> +	DISP_PLL_LOCK,
> +	DISP_PLL_CON0,
> +	DISP_PLL_CON1,
> +	DISP_PLL_FREQ_DET,
> +	MUX_SEL_DISP0,
> +	MUX_SEL_DISP1,
> +	MUX_SEL_DISP2,
> +	MUX_SEL_DISP3,
> +	MUX_SEL_DISP4,
> +	MUX_ENABLE_DISP0,
> +	MUX_ENABLE_DISP1,
> +	MUX_ENABLE_DISP2,
> +	MUX_ENABLE_DISP3,
> +	MUX_ENABLE_DISP4,
> +	MUX_STAT_DISP0,
> +	MUX_STAT_DISP1,
> +	MUX_STAT_DISP2,
> +	MUX_STAT_DISP3,
> +	MUX_STAT_DISP4,
> +	MUX_IGNORE_DISP2,
> +	DIV_DISP,
> +	DIV_DISP_PLL_FREQ_DET,
> +	DIV_STAT_DISP,
> +	DIV_STAT_DISP_PLL_FREQ_DET,
> +	ENABLE_ACLK_DISP0,
> +	ENABLE_ACLK_DISP1,
> +	ENABLE_PCLK_DISP,
> +	ENABLE_SCLK_DISP,
> +	ENABLE_IP_DISP0,
> +	ENABLE_IP_DISP1,
> +	CLKOUT_CMU_DISP,
> +	CLKOUT_CMU_DISP_DIV_STAT,
> +};
> +
> +/* list of all parent clock list */
> +PNAME(mout_disp_pll_p)			= { "fin_pll", "fout_disp_pll", };
> +PNAME(mout_sclk_dsim1_user_p)		= { "fin_pll", "sclk_dsim1_disp", };
> +PNAME(mout_sclk_dsim0_user_p)		= { "fin_pll", "sclk_dsim0_disp", };
> +PNAME(mout_sclk_dsd_user_p)		= { "fin_pll", "sclk_dsd_disp", };
> +PNAME(mout_sclk_decon_tv_eclk_user_p)	= { "fin_pll",
> +					    "sclk_decon_tv_eclk_disp", };
> +PNAME(mout_sclk_decon_vclk_user_p)	= { "fin_pll",
> +					    "sclk_decon_vclk_disp", };
> +PNAME(mout_sclk_decon_eclk_user_p)	= { "fin_pll",
> +					    "sclk_decon_eclk_disp", };
> +PNAME(mout_sclk_decon_tv_vlkc_user_p)	= { "fin_pll",
> +					    "sclk_decon_tv_vclk_disp", };
> +PNAME(mout_aclk_disp_333_user_p)	= { "fin_pll", "aclk_disp_333", };
> +
> +PNAME(mout_phyclk_mipidphy1_bitclkdiv8_user_p)	= { "fin_pll",
> +					"phyclk_mipidphy1_bitclkdiv8_phy", };
> +PNAME(mout_phyclk_mipidphy1_rxclkesc0_user_p)	= { "fin_pll",
> +					"phyclk_mipidphy1_rxclkesc0_phy", };
> +PNAME(mout_phyclk_mipidphy0_bitclkdiv8_user_p)	= { "fin_pll",
> +					"phyclk_mipidphy0_bitclkdiv8_phy", };
> +PNAME(mout_phyclk_mipidphy0_rxclkesc0_user_p)	= { "fin_pll",
> +					"phyclk_mipidphy0_rxclkesc0_phy", };
> +PNAME(mout_phyclk_hdmiphy_tmds_clko_user_p)	= { "fin_pll",
> +					"phyclk_hdmiphy_tmds_clko_phy", };
> +PNAME(mout_phyclk_hdmiphy_pixel_clko_user_p)	= { "fin_pll",
> +					"phyclk_hdmiphy_pixel_clko_phy", };
> +
> +PNAME(mout_sclk_dsim0_p)		= { "mout_disp_pll",
> +					    "mout_sclk_dsim0_user", };
> +PNAME(mout_sclk_decon_tv_eclk_p)	= { "mout_disp_pll",
> +					    "mout_sclk_decon_tv_eclk_user", };
> +PNAME(mout_sclk_decon_vclk_p)		= { "mout_disp_pll",
> +					    "mout_sclk_decon_vclk_user", };
> +PNAME(mout_sclk_decon_eclk_p)		= { "mout_disp_pll",
> +					    "mout_sclk_decon_eclk_user", };
> +
> +PNAME(mout_sclk_dsim1_b_disp_p)		= { "mout_sclk_dsim1_a_disp",
> +					    "mout_sclk_dsim1_user", };
> +PNAME(mout_sclk_dsim1_a_disp_p)		= { "mout_disp_pll",
> +					    "mout_sclk_dsim0_user", };

mout_sclk_dsim1_a_disp_p and mout_sclk_dsim0_p has same parent list, so 
one can be dropped.

> +PNAME(mout_sclk_decon_tv_vclk_c_disp_p)	= {
> +				"mout_phyclk_hdmiphy_pixel_clko_user",
> +				"mout_sclk_decon_tv_vclk_b_disp", };
> +PNAME(mout_sclk_decon_tv_vclk_b_disp_p)	= { "mout_sclk_decon_tv_vclk_a_disp",
> +					    "mout_sclk_decon_tv_vclk_user", };
> +PNAME(mout_sclk_decon_tv_vclk_a_disp_p)	= { "mout_disp_pll",
> +					    "mout_sclk_decon_vclk_user", };
> +

mout_sclk_decon_tv_vclk_a_disp_p and mout_sclk_decon_vclk_p has same 
parent list, so one of them can be dropped.

> +static struct samsung_pll_clock disp_pll_clks[] __initdata = {
> +	PLL(pll_35xx, CLK_FOUT_DISP_PLL, "fout_disp_pll", "fin_pll",
> +		DISP_PLL_LOCK, DISP_PLL_CON0, exynos5443_pll_rates),
> +};
> +
> +static struct samsung_fixed_factor_clock disp_fixed_factor_clks[] __initdata = {
> +	/*
> +	 * sclk_rgb_{vclk|tv_vclk} is half clock of sclk_decon_{vclk|tv_vclk}.
> +	 * The divider has fixed value (2) betwwen sclk_rgb_{vclk|tv_vclk}

typo: %s/betwwen/between

> +	 * and sclk_decon_{vclk|tv_vclk}.
> +	 */
> +	FFACTOR(CLK_SCLK_RGB_VCLK, "sclk_rgb_vclk", "sclk_decon_vclk",
> +			1, 2, 0),
> +	FFACTOR(CLK_SCLK_RGB_TV_VCLK, "sclk_rgb_tv_vclk", "sclk_decon_tv_vclk",
> +			1, 2, 0),
> +};
> +

Thanks,
Pankaj Dubey
