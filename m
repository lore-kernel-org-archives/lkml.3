Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaLHJqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:46:23 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63800 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbaLHJqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:46:21 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-a5-5485736be24c
Message-id: <1418031977.6084.13.camel@AMDC1943>
Subject: Re: [RFC 1/3] devfreq: dt-bindings: Document Exynos3250 devfreq driver
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: myungjoo.ham@samsung.com
Cc: =?UTF-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        =?UTF-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Date: Mon, 08 Dec 2014 10:46:17 +0100
In-reply-to: <1647680679.696101418015213383.JavaMail.weblogic@epmlwas04c>
References: <1647680679.696101418015213383.JavaMail.weblogic@epmlwas04c>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e/4Vd3s4tYQg7cd3BYbZ6xntbj+5Tmr
	xfwj51gt+h+/ZrY42/SG3WLT42usFpd3zWGz+Nx7hNFixvl9TBa3L/NarD1yl93iduMKNotV
	u/4wOvB6tDT3sHnsnHWX3WPTqk42j81L6j36tqxi9Pi8SS6ALcrNJiM1MSW1SCE1Lzk/JTMv
	3VYpNMRN10JJIS8xN9VWKULXNyRISaEsMacUyDMyQAMOzgHuwUr6dgluGe9fz2Uv2ClXMf/c
	Q7YGxg6JLkZODgkBE4lvK3YwQ9hiEhfurWfrYuTiEBJYyigxYcV9KOczo8STvZuYQKp4BfQl
	1k+9zAhiCwv4S8zoaAaz2QSMJTYvX8IGYosIyEhc3bidBaSZWWAzq8S+M+fBilgEVCUWHlsH
	NohTwFPi5bXZYHEhAQ+J5V9+gTUzC6hLTJq3COgkDqCTlCUa+90g9gpK/Jh8jwWiRF5i85q3
	zBMYBWYh6ZiFpGwWkrIFjMyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUIi9OsOxqXHrA4x
	CnAwKvHwbihvDhFiTSwrrsw9xCjBwawkwpsY1xoixJuSWFmVWpQfX1Sak1p8iDEZ6KGJzFKi
	yfnA5JFXEm9oYmhuaWhkbGFhbmREmrCSOG/l15YQIYH0xJLU7NTUgtQimC1MHJxSDYwyd9et
	0Fjuy9j+W7b4xa71Zg6zmc5nV+uG6N8+/e/w/jgTwbvZtR2yTj2yS2TDdnRvajKueHZ/SmqR
	T+HejVLyD5k8406+W+UibpSn8dukzEJc68CqA7KzJBi/fCp6cJpxjdW/LTuuH+j41jk/oCeg
	c5VrwB99Ud927gM2S04eSNk5YVWVt40SS3FGoqEWc1FxIgA8+1/XFAMAAA==
X-MTR: 20000000000000000@CPGS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-12-08 at 05:06 +0000, MyungJoo Ham wrote:
> >   
> >  Add documentation for bindings used by Exynos3250 devfreq driver.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  .../bindings/arm/samsung/exynos3250-devfreq.txt    | 66 ++++++++++++++++++++++
> >  1 file changed, 66 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt b/Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt
> > new file mode 100644
> > index 000000000000..047955e9e371
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt
> > @@ -0,0 +1,66 @@
> > +Samsung Exynos3250 devfreq driver
> > +=================================
> > +
> > +The driver support changing frequencies and voltage for:
> > + - memory controller and bus,
> > + - peripheral buses (left and right).
> > +
> > +Memory controller and bus
> > +=========================
> > +Required properties:
> > + - compatible : should be "samsung,exynos3250-busfreq-mif"
> > + - reg : two sets (offset and length of the register) for PPMU registers
> > +	used by this devfreq driver
> > + - clock-names : one clock of name "dmc" to manage frequency
> > + - clocks : phandle and specifier for clock listed in clock-names property
> > + - vdd_mif-supply : phandle to MIF voltage regulator
> > +
> > +Peripheral buses
> > +================
> > +Required properties:
> > + - compatible : should be "samsung,exynos3250-busfreq-int"
> > + - reg : two sets (offset and length of the register) for PPMU registers
> > +	used by this devfreq driver
> > + - clock-names : names for PPMU clocks and bus clocks to manage frequencies;
> > +	All following clock names (and corresponding phandles) must be
> > +	provided:
> > +	- "ppmu_left", "ppmu_right",
> > +	- "aclk_400", "aclk_266", "aclk_200", "aclk_160", "aclk_gdl", "aclk_gdr", "mfc";
> > + - clocks : phandles and specifiers for clocks listed in clock-names property
> > + - vdd_mif-supply : phandle to INT voltage regulator
> > +
> > +Example
> > +=======
> > +	busfreq_mif: busfreq@106A0000 {
> > +		compatible = "samsung,exynos3250-busfreq-mif";
> > +		reg = <0x106A0000 0x2000>, <0x106B0000 0x2000>;
> > +		clocks = <&cmu_dmc CLK_DIV_DMC>;
> > +		clock-names = "dmc";
> > +		vdd_mif-supply = <&buck1_reg>;
> > +		status = "okay";
> > +	};
> 
> The hardware you are binding hereby is "Exynos PPMU".
> You may consider to bind PPMU (DMC PPMU or BUS PPMU whichever hardware
> you want to use) with DT and then let exynos bus devfreq driver use
> the already-bound devices if found, ... in principle.
> In other words or point of view, you may implement PPMU driver in
> devfreq class device driver so that you let it bind PPMU device with DT.
> It may be done similarly with the device below.

Yes, you're right. I saw also similar case for Tegra Activity Monitor. 

Thanks for pointing this,
Krzysztof


> 
> 
> Cheers,
> MyungJoo.
> 
> 
> > +
> > +	busfreq_int: busfreq@116A0000 {
> > +		compatible = "samsung,exynos3250-busfreq-int";
> > +		reg = <0x116A0000 0x2000>, <0x112A0000 0x2000>;
> > +		clocks = <&cmu CLK_PPMULEFT>,
> > +			<&cmu CLK_PPMURIGHT>,
> > +			<&cmu CLK_DIV_ACLK_400_MCUISP>,
> > +			<&cmu CLK_DIV_ACLK_266>,
> > +			<&cmu CLK_DIV_ACLK_200>,
> > +			<&cmu CLK_DIV_ACLK_160>,
> > +			<&cmu CLK_DIV_GDL>,
> > +			<&cmu CLK_DIV_GDR>,
> > +			<&cmu CLK_DIV_MFC>;
> > +		clock-names = "ppmuleft",
> > +			"ppmuright",
> > +			"aclk_400",
> > +			"aclk_266",
> > +			"aclk_200",
> > +			"aclk_160",
> > +			"aclk_gdl",
> > +			"aclk_gdr",
> > +			"mfc";
> > +		vdd_int-supply = <&buck3_reg>;
> > +		status = "okay";
> > +	};
> > -- 
> > 1.9.1
> > 

