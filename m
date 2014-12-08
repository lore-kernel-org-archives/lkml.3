Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaLHFG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 00:06:59 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:63325 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaLHFG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 00:06:56 -0500
X-AuditID: cbfee68d-f79296d000004278-eb-548531ee7350
Date: Mon, 08 Dec 2014 05:06:53 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [RFC 1/3] devfreq: dt-bindings: Document Exynos3250 devfreq driver
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20141208050125092@myungjoo.ham
Msgkey: 20141208050125092@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141208050125092@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <1647680679.696101418015213383.JavaMail.weblogic@epmlwas04c>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWyRsSkRPedYWuIwbM9rBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSuj/ewupoI7qhXPb11mbmC8o9LFyMkhJKAusWjJSTYQW0LAROLg
	1n5WCFtM4sK99UBxLqCapYwSj1+eZIEp2nB+KStEYg6jxPazH9hBEiwCKhKnN/5h6mLk4GAT
	0JOY+TkZJCws4C8xo6OZEaReROARi8T7441gg5gFpjBKrPiRCXGFksSafa/A4rwCghInZz6B
	WqYqMbn9LjtEXE1i1aoHUHFxiQtzL7FD2LwSM9qfQsXlJKZ9XcMMYUtLnJ+1gRHmm8XfH0PF
	+SWO3d7BBGELSEw9cxCqRkvi79fD0JDgk1iz8C0LTP2uU8uZYXbd3zIXqldCYmvLE1aIXxQl
	pnQ/ZAf5nVlAU2L9Ln10r/AKeEhc+XyDBRQOEgITOSQu/17OPoFRaRaSullIRs1CGIWsZAEj
	yypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MwMRw+t+z3h2Mtw9YH2IU4GBU4uFd8KAlRIg1
	say4MvcQoykwliYyS4km5wPTT15JvKGxmZGFqYmpsZG5pZmSOK+i1M9gIYH0xJLU7NTUgtSi
	+KLSnNTiQ4xMHJxSDYzHpXPvy3FM+yr79ZXBrOMnNqa63y2O/KH7cNEtqyJrRoUnfVMXmxUo
	nFJfzJUf4/EpZfKehQLchz80yKjN2i5kufdsY5Ns16+65dN2H9q9dtdcm6e/tcyEWv9EWyZ/
	vmbisuBI25/7y/Q+/22b9f3AixfLp6me4v++4JHE/PuvjQXVzmVZnjjDq8RSnJFoqMVcVJwI
	ADBqZiUHAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t/tft13hq0hBieELC7vmsPmwOjxeZNc
	AGNUmk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0Ewl
	hbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1StKG5kZ6RgZ6pkZ6hcayVoYGBkSlQTUJaRvvZ
	XUwFd1Qrnt+6zNzAeEeli5GTQ0hAXWLRkpNsILaEgInEhvNLWSFsMYkL99YDxbmAauYwSmw/
	+4EdJMEioCJxeuMfpi5GDg42AT2JmZ+TQcLCAv4SMzqaGUHqRQQesUi8P97IApJgFpjCKLHi
	RybEMiWJNftegcV5BQQlTs58wgKxTFVicvtddoi4msSqVQ+g4uISF+ZeYoeweSVmtD+FistJ
	TPu6hhnClpY4P2sDI8zRi78/horzSxy7vYMJwhaQmHrmIFSNlsTfr4ehHuaTWLPwLQtM/a5T
	y5lhdt3fMheqV0Jia8sTVohfFCWmdD9kB/mdWUBTYv0ufXSv8Ap4SFz5fINlAqPsLCSpWUi6
	ZyF0IytZwMiyilE0tSC5oDgpvcJIrzgxt7g0L10vOT93EyM4BT1btIPx33nrQ4wCHIxKPLwL
	HrSECLEmlhVX5h5ilOBgVhLhXf4ZKMSbklhZlVqUH19UmpNafIjRFBhnE5mlRJPzgekxryTe
	0NjYxMzE1NLEwsDUXEmc9/+53BAhgfTEktTs1NSC1CKYPiYOTqkGxpdmJSdXKCtkhthHbo6e
	s7J2uQCD9fIZVSGyn5uOusnXTjkgd3DS14qDlz3fGhUI/7fkuzX/i/C7CbpluqvYolvMe9K0
	d5c6XBE6w2Vx/bt+YqzEcdcwx4Vv6hbfF3rUuzQy9UTMQd4MS8YwXb8ZJrWHSrqubr13mD1i
	1t6zkfsDpB/1xuU9VWIpzkg01GIuKk4EALWMKOtXAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB857EPQ023186

>   
>  Add documentation for bindings used by Exynos3250 devfreq driver.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  .../bindings/arm/samsung/exynos3250-devfreq.txt    | 66 ++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt b/Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt
> new file mode 100644
> index 000000000000..047955e9e371
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt
> @@ -0,0 +1,66 @@
> +Samsung Exynos3250 devfreq driver
> +=================================
> +
> +The driver support changing frequencies and voltage for:
> + - memory controller and bus,
> + - peripheral buses (left and right).
> +
> +Memory controller and bus
> +=========================
> +Required properties:
> + - compatible : should be "samsung,exynos3250-busfreq-mif"
> + - reg : two sets (offset and length of the register) for PPMU registers
> +	used by this devfreq driver
> + - clock-names : one clock of name "dmc" to manage frequency
> + - clocks : phandle and specifier for clock listed in clock-names property
> + - vdd_mif-supply : phandle to MIF voltage regulator
> +
> +Peripheral buses
> +================
> +Required properties:
> + - compatible : should be "samsung,exynos3250-busfreq-int"
> + - reg : two sets (offset and length of the register) for PPMU registers
> +	used by this devfreq driver
> + - clock-names : names for PPMU clocks and bus clocks to manage frequencies;
> +	All following clock names (and corresponding phandles) must be
> +	provided:
> +	- "ppmu_left", "ppmu_right",
> +	- "aclk_400", "aclk_266", "aclk_200", "aclk_160", "aclk_gdl", "aclk_gdr", "mfc";
> + - clocks : phandles and specifiers for clocks listed in clock-names property
> + - vdd_mif-supply : phandle to INT voltage regulator
> +
> +Example
> +=======
> +	busfreq_mif: busfreq@106A0000 {
> +		compatible = "samsung,exynos3250-busfreq-mif";
> +		reg = <0x106A0000 0x2000>, <0x106B0000 0x2000>;
> +		clocks = <&cmu_dmc CLK_DIV_DMC>;
> +		clock-names = "dmc";
> +		vdd_mif-supply = <&buck1_reg>;
> +		status = "okay";
> +	};

The hardware you are binding hereby is "Exynos PPMU".
You may consider to bind PPMU (DMC PPMU or BUS PPMU whichever hardware
you want to use) with DT and then let exynos bus devfreq driver use
the already-bound devices if found, ... in principle.
In other words or point of view, you may implement PPMU driver in
devfreq class device driver so that you let it bind PPMU device with DT.
It may be done similarly with the device below.


Cheers,
MyungJoo.


> +
> +	busfreq_int: busfreq@116A0000 {
> +		compatible = "samsung,exynos3250-busfreq-int";
> +		reg = <0x116A0000 0x2000>, <0x112A0000 0x2000>;
> +		clocks = <&cmu CLK_PPMULEFT>,
> +			<&cmu CLK_PPMURIGHT>,
> +			<&cmu CLK_DIV_ACLK_400_MCUISP>,
> +			<&cmu CLK_DIV_ACLK_266>,
> +			<&cmu CLK_DIV_ACLK_200>,
> +			<&cmu CLK_DIV_ACLK_160>,
> +			<&cmu CLK_DIV_GDL>,
> +			<&cmu CLK_DIV_GDR>,
> +			<&cmu CLK_DIV_MFC>;
> +		clock-names = "ppmuleft",
> +			"ppmuright",
> +			"aclk_400",
> +			"aclk_266",
> +			"aclk_200",
> +			"aclk_160",
> +			"aclk_gdl",
> +			"aclk_gdr",
> +			"mfc";
> +		vdd_int-supply = <&buck3_reg>;
> +		status = "okay";
> +	};
> -- 
> 1.9.1
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
