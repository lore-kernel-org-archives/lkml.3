Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbaLHJJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:09:12 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8841 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaLHJJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:09:09 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-01-54856ab238d7
Content-transfer-encoding: 8BIT
Message-id: <1418029742.6084.8.camel@AMDC1943>
Subject: Re: [RFC 1/3] devfreq: dt-bindings: Document Exynos3250 devfreq driver
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Date: Mon, 08 Dec 2014 10:09:02 +0100
In-reply-to: <20141205165356.GC12849@leverpostej>
References: <1417797988-29225-1-git-send-email-k.kozlowski@samsung.com>
 <1417797988-29225-2-git-send-email-k.kozlowski@samsung.com>
 <20141205165356.GC12849@leverpostej>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e/4Fd1NWa0hBktfs1lsnLGe1eL6l+es
	FvOPnGO16H/8mtnibNMbdotNj6+xWlzeNYfN4nPvEUaLGef3MVncvsxrsfbIXXaLpdcvAnmN
	K9gsVu36w+jA57Fm3hpGj5bmHjaPnbPusntsWtXJ5rF5Sb1H35ZVjB6fN8kFsEe52WSkJqak
	Fimk5iXnp2TmpdsqhYa46VooKeQl5qbaKkXo+oYEKSmUJeaUAnlGBmjAwTnAPVhJ3y7BLeP9
	6m+sBbOVK1rXNrE1ML6Q7mLk4JAQMJH4vs+ui5ETyBSTuHBvPVsXIxeHkMBSRolF5/4ygyR4
	BQQlfky+xwJSzywgL3HkUjZImFlAXWLSvEXMEPWfGSXWP3jABFGvJ/H6+FM2EFtYwF9iRkcz
	I4jNJmAssXn5ErC4CFBzz64vLCDNzALLWSVOXT3KApJgEVCV2H7vL1gRp4ChxLv2Q1Ab1jBK
	bPrWxAhxtbJEY7/bBEaBWUjum4Vw3ywk9y1gZF7FKJpamlxQnJSea6RXnJhbXJqXrpecn7uJ
	ERKxX3cwLj1mdYhRgINRiYd3Q3lziBBrYllxZe4hRgkOZiUR3sS41hAh3pTEyqrUovz4otKc
	1OJDjMlAx05klhJNzgcmk7ySeEMTQ3NLQyNjCwtzIyPShJXEeSu/toQICaQnlqRmp6YWpBbB
	bGHi4JRqYFy7T+pFlU7J7QS/5cvf9ktd1ORY/m5bW5jD9N2n5kWU7NFbX3KyYjrbOl1x1RuN
	Jr9s7A5M2Vu//OwhJqMdOy/tnvtmXWpoywyd1UZSzVFRVwX3nbG07uzYrGPu83Fzx4K9XSd+
	BtTmXpiqlP+eL71v5b0NXxT/LHiWtufT6SPmgrGuT18H1HUqsRRnJBpqMRcVJwIAi1ufyRwD	AAA=
X-MTR: 20000000000000000@CPGS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-12-05 at 16:53 +0000, Mark Rutland wrote:
> On Fri, Dec 05, 2014 at 04:46:26PM +0000, Krzysztof Kozlowski wrote:
> > Add documentation for bindings used by Exynos3250 devfreq driver.
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
> 
> The binding should describe the hardware, not a particular driver of
> that hardware. Please write the binding (and its documentation) with
> that in mind, and drop references to the driver and "busfreq".
> 
> With an adequate binding we can probe the device and forward the
> information to relevant driver(s) as necessary.

OK

> 
> > +=================================
> > +
> > +The driver support changing frequencies and voltage for:
> > + - memory controller and bus,
> > + - peripheral buses (left and right).
> 
> 
> What do left and right mean in this context?

These are names for clock domains associated with buses between memory
controller and peripherals. They're called "leftbus" and "rightbus" in
documentation.

> 
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
> 
> s/_/-/ in property names please.

Sure.

> 
> > +
> > +Peripheral buses
> > +================
> > +Required properties:
> > + - compatible : should be "samsung,exynos3250-busfreq-int"
> 
> What does "int" mean here?

It is the name of power source (VDD_INT) and regulator supplying certain
power domains in SoC. However I have no clue what engineers meant by
this abbreviation.

> 
> > + - reg : two sets (offset and length of the register) for PPMU registers
> > +	used by this devfreq driver
> > + - clock-names : names for PPMU clocks and bus clocks to manage frequencies;
> > +	All following clock names (and corresponding phandles) must be
> > +	provided:
> > +	- "ppmu_left", "ppmu_right",
> > +	- "aclk_400", "aclk_266", "aclk_200", "aclk_160", "aclk_gdl", "aclk_gdr", "mfc";
> > + - clocks : phandles and specifiers for clocks listed in clock-names property
> > + - vdd_mif-supply : phandle to INT voltage regulator
> 
> s/_/-/ here too.

OK

Thanks for feedback.

Best regards,
Krzysztof


> Thanks,
> Mark.
> 
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
> > --
> > To unsubscribe from this list: send the line "unsubscribe devicetree" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 

