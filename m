Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbaJaHvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:51:47 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17966 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506AbaJaHvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:51:43 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f956d000005ed7-91-54533f8c515c
Content-transfer-encoding: 8BIT
Message-id: <1414741898.20071.8.camel@AMDC1943>
Subject: Re: [PATCH 6/8] regulator: max77686: Add external GPIO control
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 31 Oct 2014 08:51:38 +0100
In-reply-to: <CAAVeFuJo1wTyxOo4FEZM3=GTejuSHi+mnr=QV6HUeV5mAOCmqg@mail.gmail.com>
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
 <1414422226-10948-7-git-send-email-k.kozlowski@samsung.com>
 <544EA4FA.6040704@collabora.co.uk> <1414486356.24949.19.camel@AMDC1943>
 <1414498308.24949.32.camel@AMDC1943> <1414579362.18868.11.camel@AMDC1943>
 <5450C63B.3000602@collabora.co.uk>
 <CAAVeFuLncbkNLGxEAj90yMmugRDNjtjeGoV_QYTMDZ7NVMJCmg@mail.gmail.com>
 <1414681386.26703.6.camel@AMDC1943>
 <CAAVeFuJo1wTyxOo4FEZM3=GTejuSHi+mnr=QV6HUeV5mAOCmqg@mail.gmail.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e/4Vd0e++AQg48zpS02zljPajFp3QEm
	i6kPn7BZXP/ynNVi/pFzrBbnXj1isTj6u8Cid8FVNouzTW/YLe5/Pcpo8e1KB5PFlD/LmSw2
	Pb7GanF51xw2ixnn9zFZ3L7Ma7H2yF12i9PdrA5CHi3NPWwef59fZ/H4u+oFs8fOWXfZPTat
	6mTzuHNtD5vHvJOBHpuX1Hv0bVnF6PF5k1wAVxSXTUpqTmZZapG+XQJXRs/CLraC/zYVm9Z9
	ZW5g/KjXxcjJISFgInFm1gEmCFtM4sK99WxdjFwcQgJLGSU2dyxmA0nwCghK/Jh8j6WLkYOD
	WUBe4silbJAws4C6xKR5i5gh6j8zSnR+vM8CUa8vce/+D1YQW1jAXeL+wkNgC9gEjCU2L1/C
	BjJHREBD4tE6EZBeZoHdbBKv2p+D7WIRUJWYc+cfM4jNKRAssfrDPSaIBV+YJXomPwVrlhBQ
	lmjsd5vAKDALyXmzEM6bheS8BYzMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFCIu/rDsal
	x6wOMQpwMCrx8Gp8CQoRYk0sK67MPcQowcGsJMI76S1QiDclsbIqtSg/vqg0J7X4ECMTB6dU
	A6P7T40V00+dmnD5zGerKepSq7a9+vR98p1/XAVPnTZPWVwZdodx9Qpdg107/kYtvywzM3T7
	tBy3o+yJilq3N12qWC/Bzf78fvG8n8+iN0yau+LlM95X/kc10tfc2pw7S1put9fsu+XpIsly
	/1lXRWovumnwKeiE0FHNe5aMddlWsxabrpk75xgjixJLcUaioRZzUXEiAIY5j+iaAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-10-31 at 12:31 +0900, Alexandre Courbot wrote:
> On Fri, Oct 31, 2014 at 12:03 AM, Krzysztof Kozlowski
> <k.kozlowski@samsung.com> wrote:
> > On czw, 2014-10-30 at 22:56 +0900, Alexandre Courbot wrote:
> >> Hi, and thanks for bringing this issue to us!
> >>
> >> On Wed, Oct 29, 2014 at 7:49 PM, Javier Martinez Canillas
> >> <javier.martinez@collabora.co.uk> wrote:
> >> > [adding Linus and Alexandre to the cc list]
> >> >
> >> > Hello Krzysztof,
> >> >
> >> > On 10/29/2014 11:42 AM, Krzysztof Kozlowski wrote:
> >> >> On wto, 2014-10-28 at 13:11 +0100, Krzysztof Kozlowski wrote:
> >> >>> On wto, 2014-10-28 at 09:52 +0100, Krzysztof Kozlowski wrote:
> >> >>> > On pon, 2014-10-27 at 21:03 +0100, Javier Martinez Canillas wrote:
> >> >>> > > Hello Krzysztof,
> >> >>> > >
> >> >>> > > On 10/27/2014 04:03 PM, Krzysztof Kozlowski wrote:
> >> >>> > > > @@ -85,6 +91,9 @@ struct max77686_data {
> >> >>> > > >        struct max77686_regulator_data *regulators;
> >> >>> > > >        int num_regulators;
> >> >>> > > >
> >> >>> > > > +      /* Array of size num_regulators with GPIOs for external control. */
> >> >>> > > > +      int *ext_control_gpio;
> >> >>> > > > +
> >> >>> > >
> >> >>> > > The integer-based GPIO API is deprecated in favor of the descriptor-based GPIO
> >> >>> > > interface (Documentation/gpio/consumer.txt). Could you please use the later?
> >> >>> >
> >> >>> > Sure, I can. Please have in mind that regulator core still accepts old
> >> >>> > GPIO so I will have to use desc_to_gpio(). That should work... and
> >> >>> > should be future-ready.
> >> >>>
> >> >>> It seems I was too hasty... I think usage of the new gpiod API implies
> >> >>> completely different bindings.
> >> >>>
> >> >>> The gpiod_get() gets GPIO from a device level, not from given sub-node
> >> >>> pointer. This means that you cannot have DTS like this:
> >> >>> ldo21_reg: ldo21 {
> >> >>>      regulator-compatible = "LDO21";
> >> >>>      regulator-name = "VTF_2.8V";
> >> >>>      regulator-min-microvolt = <2800000>;
> >> >>>      regulator-max-microvolt = <2800000>;
> >> >>>      ec-gpio = <&gpy2 0 0>;
> >> >>> };
> >> >>>
> >> >>> ldo22_reg: ldo22 {
> >> >>>      regulator-compatible = "LDO22";
> >> >>>      regulator-name = "VMEM_VDD_2.8V";
> >> >>>      regulator-min-microvolt = <2800000>;
> >> >>>      regulator-max-microvolt = <2800000>;
> >> >>>      ec-gpio = <&gpk0 2 0>;
> >> >>> };
> >> >>>
> >> >>>
> >> >>> I could put GPIOs in device node:
> >> >>>
> >> >>> max77686_pmic@09 {
> >> >>>      compatible = "maxim,max77686";
> >> >>>      interrupt-parent = <&gpx0>;
> >> >>>      interrupts = <7 0>;
> >> >>>      reg = <0x09>;
> >> >>>      #clock-cells = <1>;
> >> >>>      ldo21-gpio = <&gpy2 0 0>;
> >> >>>      ldo22-gpio = <&gpk0 2 0>;
> >> >>>
> >> >>>      ldo21_reg: ldo21 {
> >> >>>              regulator-compatible = "LDO21";
> >> >>>              regulator-name = "VTF_2.8V";
> >> >>>              regulator-min-microvolt = <2800000>;
> >> >>>              regulator-max-microvolt = <2800000>;
> >> >>>      };
> >> >>>
> >> >>>      ldo22_reg: ldo22 {
> >> >>>              regulator-compatible = "LDO22";
> >> >>>              regulator-name = "VMEM_VDD_2.8V";
> >> >>>              regulator-min-microvolt = <2800000>;
> >> >>>              regulator-max-microvolt = <2800000>;
> >> >>>      };
> >> >>>
> >> >>> This would work but I don't like it. The properties of a regulator are
> >> >>> above the node configuring that regulator.
> >> >>>
> >> >>> Any ideas?
> >> >>>
> >> >>
> >> >> Continuing talking to myself... I found another problem - GPIO cannot be
> >> >> requested more than once (-EBUSY). In case of this driver (and board:
> >> >> Trats2) one GPIO is connected to regulators. The legacy GPIO API and
> >> >> regulator core handle this.
> >> >>
> >> >> With new GPIO API I would have to implement some additional steps in
> >> >> such case...
> >> >>
> >> >> So there are 2 issues:
> >> >> 1. Cannot put GPIO property in regulator node.
> >>
> >> For this problem you will probably want to use the
> >> dev(m)_get_named_gpiod_from_child() function from the following patch:
> >>
> >> https://lkml.org/lkml/2014/10/6/529
> >>
> >> It should reach -next soon now.
> >
> > Thanks! Probably I would switch to "top" level gpios property anyway
> > (other reasons) but it would be valuable in some cases to specify them
> > per child node.
> 
> Mmm, but doesn't it make more sense to have them in the child nodes?

Yes, it makes more sense. Using old way of parsing regulators from DT it
was straightforward.

However new DT style parsing (regulator_of_get_init_data()) does the
basic parsing stuff and this removes a lot of code from driver. The
driver no longer parses all regulaotrs but the regulator core does it.
Unfortunately regulator core does not parse custom bindings (like such
GPIOs) so I would have to iterate once again through all regulators just
to find "gpios" property.

It is simpler just to do something like (5 regulators can be controlled
by GPIO):

max77686_pmic_dt_parse_gpio_control(struct platform_device *pdev, *gpio)
{
  gpio[MAX77686_LDO20] = of_get_named_gpio(np, "ldo20-gpios", 0);
  gpio[MAX77686_LDO21] = of_get_named_gpio(np, "ldo21-gpios", 0);
  gpio[MAX77686_LDO22] = of_get_named_gpio(np, "ldo22-gpios", 0);
  gpio[MAX77686_BUCK8] = of_get_named_gpio(np, "buck8-gpios", 0);
  gpio[MAX77686_BUCK9] = of_get_named_gpio(np, "buck9-gpios", 0);
}

> Besides if the bindings of this driver have already been published,
> I'm afraid you will have to maintain backward compability.

These are new bindings. Driver exists but I am adding new functionality:
the "GPIO enable control".

> >>
> >> >> 2. Cannot request some GPIO more than once.
> >>
> >> We have been confronted to this problem with the regulator core as well:
> >>
> >> http://marc.info/?l=linux-arm-kernel&m=140417649119733&w=1
> >>
> >> I have a draft patch that allows GPIOs to be requested by several
> >> clients. What prevented me from submitting it was that I wanted to
> >> make sure the different requested configurations were compatible, but
> >> maybe I am overthinking this. There are also a couple of other patches
> >> that this depends on (like removal of the big descs array), so I don't
> >> think it will be available too soon, sadly.
> >
> > Shouldn't be the nature of get()/put() interface to allow multiple
> > requests?
> 
> Only if it makes sense for the resource to be requested multiple
> times. GPIOs are kind of a difficult case here. Consumers could ask
> for e.g. conflicting directions.

Right, I haven't thought about conflicts.

> But for cases where it should work I
> agree that multiple consumers would be welcome.
> 
> > To me it was a kind of intuitive that I could do another
> > devm_gpiod_get() for the same gpio. But then it hit me with EBUSY :).
> >
> >>
> >> So maybe your best shot for now is to keep using the integer API, as
> >> much as I hate it. Once we become able to request the same GPIO
> >> several times, you should be good to switch to descriptors. Sorry this
> >> has not been done faster.
> >
> > I'll do it legacy way but I'll try to use bindings gpiolib-safe. This
> > way future transition in the driver should not affect bindings.
> 
> For DT bindings, please refer to these brand-new instructions:
> 
> https://lkml.org/lkml/2014/10/29/98
> 
> Personally I think having the GPIO phandle in the child node would
> be the most intuitive. You will also have to use the "-gpios" suffix, no
> "-gpio", if you can still change the bindings.

Thanks! I'll adjust to new style.

Best regards,
Krzysztof

