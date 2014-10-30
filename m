Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161007AbaJ3PDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:03:15 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56937 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513AbaJ3PDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:03:12 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-e2-5452532c478b
Message-id: <1414681386.26703.6.camel@AMDC1943>
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
Date: Thu, 30 Oct 2014 16:03:06 +0100
In-reply-to: <CAAVeFuLncbkNLGxEAj90yMmugRDNjtjeGoV_QYTMDZ7NVMJCmg@mail.gmail.com>
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
 <1414422226-10948-7-git-send-email-k.kozlowski@samsung.com>
 <544EA4FA.6040704@collabora.co.uk> <1414486356.24949.19.camel@AMDC1943>
 <1414498308.24949.32.camel@AMDC1943> <1414579362.18868.11.camel@AMDC1943>
 <5450C63B.3000602@collabora.co.uk>
 <CAAVeFuLncbkNLGxEAj90yMmugRDNjtjeGoV_QYTMDZ7NVMJCmg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e/4VV2d4KAQg2Uf9Sw2zljPajFp3QEm
	i6kPn7BZXP/ynNVi/pFzrBbnXj1isTj6u8Cid8FVNouzTW/YLe5/Pcpo8e1KB5PFlD/LmSw2
	Pb7GanF51xw2ixnn9zFZ3L7Ma7H2yF12i9PdrA5CHi3NPWwef59fZ/H4u+oFs8fOWXfZPTat
	6mTzuHNtD5vHvJOBHpuX1Hv0bVnF6PF5k1wAVxSXTUpqTmZZapG+XQJXxo2Tc5kLFmtWTHon
	1cC4QL6LkZNDQsBEYs3RD6wQtpjEhXvr2boYuTiEBJYySqzZdJgZwvnMKDFl7XwWkCpeAX2J
	KV87wWxhAXeJ+wsPMYHYbALGEpuXLwHq5uAQEdCQeLROBKSXWWA3m8Sr9udsIDUsAqoSu5Zt
	BrM5BYIl3sx6ALWtnVni8JJdYAlmAXWJSfMWMYMMkhBQlmjsd4PYKyjxY/I9FogSeYnNa94y
	T2AUmIWkYxaSsllIyhYwMq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECIm9LzsYFx+zOsQo
	wMGoxMPrsDEgRIg1say4MvcQowQHs5IIr791UIgQb0piZVVqUX58UWlOavEhRiYOTmBINjcG
	WyRds6p6tmKn4/IcSW8p65SjbLOM2rt2s0RoKL8Ntngyt1Mw/3phbeiPctVXD8JzNHq+lbIZ
	RokYxIqwxPLsLhX1ylqyvd9KSqC6TjVk20xHw9NM984XJUh1bXuldVPZ1IbDevqFzRU3MvJi
	FLhEFwond+/4Jf43x5p9Nvfm2+YNQkosxRmJhlrMRcWJANM0J4mbAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-10-30 at 22:56 +0900, Alexandre Courbot wrote:
> Hi, and thanks for bringing this issue to us!
> 
> On Wed, Oct 29, 2014 at 7:49 PM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
> > [adding Linus and Alexandre to the cc list]
> >
> > Hello Krzysztof,
> >
> > On 10/29/2014 11:42 AM, Krzysztof Kozlowski wrote:
> >> On wto, 2014-10-28 at 13:11 +0100, Krzysztof Kozlowski wrote:
> >>> On wto, 2014-10-28 at 09:52 +0100, Krzysztof Kozlowski wrote:
> >>> > On pon, 2014-10-27 at 21:03 +0100, Javier Martinez Canillas wrote:
> >>> > > Hello Krzysztof,
> >>> > >
> >>> > > On 10/27/2014 04:03 PM, Krzysztof Kozlowski wrote:
> >>> > > > @@ -85,6 +91,9 @@ struct max77686_data {
> >>> > > >        struct max77686_regulator_data *regulators;
> >>> > > >        int num_regulators;
> >>> > > >
> >>> > > > +      /* Array of size num_regulators with GPIOs for external control. */
> >>> > > > +      int *ext_control_gpio;
> >>> > > > +
> >>> > >
> >>> > > The integer-based GPIO API is deprecated in favor of the descriptor-based GPIO
> >>> > > interface (Documentation/gpio/consumer.txt). Could you please use the later?
> >>> >
> >>> > Sure, I can. Please have in mind that regulator core still accepts old
> >>> > GPIO so I will have to use desc_to_gpio(). That should work... and
> >>> > should be future-ready.
> >>>
> >>> It seems I was too hasty... I think usage of the new gpiod API implies
> >>> completely different bindings.
> >>>
> >>> The gpiod_get() gets GPIO from a device level, not from given sub-node
> >>> pointer. This means that you cannot have DTS like this:
> >>> ldo21_reg: ldo21 {
> >>>      regulator-compatible = "LDO21";
> >>>      regulator-name = "VTF_2.8V";
> >>>      regulator-min-microvolt = <2800000>;
> >>>      regulator-max-microvolt = <2800000>;
> >>>      ec-gpio = <&gpy2 0 0>;
> >>> };
> >>>
> >>> ldo22_reg: ldo22 {
> >>>      regulator-compatible = "LDO22";
> >>>      regulator-name = "VMEM_VDD_2.8V";
> >>>      regulator-min-microvolt = <2800000>;
> >>>      regulator-max-microvolt = <2800000>;
> >>>      ec-gpio = <&gpk0 2 0>;
> >>> };
> >>>
> >>>
> >>> I could put GPIOs in device node:
> >>>
> >>> max77686_pmic@09 {
> >>>      compatible = "maxim,max77686";
> >>>      interrupt-parent = <&gpx0>;
> >>>      interrupts = <7 0>;
> >>>      reg = <0x09>;
> >>>      #clock-cells = <1>;
> >>>      ldo21-gpio = <&gpy2 0 0>;
> >>>      ldo22-gpio = <&gpk0 2 0>;
> >>>
> >>>      ldo21_reg: ldo21 {
> >>>              regulator-compatible = "LDO21";
> >>>              regulator-name = "VTF_2.8V";
> >>>              regulator-min-microvolt = <2800000>;
> >>>              regulator-max-microvolt = <2800000>;
> >>>      };
> >>>
> >>>      ldo22_reg: ldo22 {
> >>>              regulator-compatible = "LDO22";
> >>>              regulator-name = "VMEM_VDD_2.8V";
> >>>              regulator-min-microvolt = <2800000>;
> >>>              regulator-max-microvolt = <2800000>;
> >>>      };
> >>>
> >>> This would work but I don't like it. The properties of a regulator are
> >>> above the node configuring that regulator.
> >>>
> >>> Any ideas?
> >>>
> >>
> >> Continuing talking to myself... I found another problem - GPIO cannot be
> >> requested more than once (-EBUSY). In case of this driver (and board:
> >> Trats2) one GPIO is connected to regulators. The legacy GPIO API and
> >> regulator core handle this.
> >>
> >> With new GPIO API I would have to implement some additional steps in
> >> such case...
> >>
> >> So there are 2 issues:
> >> 1. Cannot put GPIO property in regulator node.
> 
> For this problem you will probably want to use the
> dev(m)_get_named_gpiod_from_child() function from the following patch:
> 
> https://lkml.org/lkml/2014/10/6/529
> 
> It should reach -next soon now.

Thanks! Probably I would switch to "top" level gpios property anyway
(other reasons) but it would be valuable in some cases to specify them
per child node.

> 
> >> 2. Cannot request some GPIO more than once.
> 
> We have been confronted to this problem with the regulator core as well:
> 
> http://marc.info/?l=linux-arm-kernel&m=140417649119733&w=1
> 
> I have a draft patch that allows GPIOs to be requested by several
> clients. What prevented me from submitting it was that I wanted to
> make sure the different requested configurations were compatible, but
> maybe I am overthinking this. There are also a couple of other patches
> that this depends on (like removal of the big descs array), so I don't
> think it will be available too soon, sadly.

Shouldn't be the nature of get()/put() interface to allow multiple
requests? To me it was a kind of intuitive that I could do another
devm_gpiod_get() for the same gpio. But then it hit me with EBUSY :).

> 
> So maybe your best shot for now is to keep using the integer API, as
> much as I hate it. Once we become able to request the same GPIO
> several times, you should be good to switch to descriptors. Sorry this
> has not been done faster.

I'll do it legacy way but I'll try to use bindings gpiolib-safe. This
way future transition in the driver should not affect bindings.

Best regards,
Krzysztof


