Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaCMGAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 02:00:49 -0400
Received: from nasmtp02.atmel.com ([204.2.163.16]:15104 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753030AbaCMGAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 02:00:46 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "b.brezillon@overkiz.com" <b.brezillon@overkiz.com>
CC: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "b.brezillon@overkiz.com" <b.brezillon@overkiz.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "<linux-arm-kernel@lists.infradead.org> mailing list" 
	<linux-arm-kernel@lists.infradead.org>,
        "Lin, JM" <JM.Lin@atmel.com>
Subject: RE: [PATCH] pinctrl: at91: add the config GPIO_OUTPUT_x
Thread-Topic: [PATCH] pinctrl: at91: add the config GPIO_OUTPUT_x
Thread-Index: AQHPOBZN5fMe5OwL6UGLX174CVzsdZrRaLsAgACLhMCACS2F4P//qTeAgACud/D//8ZCgIADTc7g
Date: Thu, 13 Mar 2014 06:00:36 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364173008EB4@penmbx01>
References: <1393984400-14687-1-git-send-email-wenyou.yang@atmel.com>
 <635C1A75-4651-4B2C-AB64-E1D170A1F5F9@jcrosoft.com>
 <B256D81BAE5131468A838E5D7A24364172FF4EC4@penmbx01>
 <B256D81BAE5131468A838E5D7A24364172FFB955@penmbx01>
 <F73ABBC2-BFD3-43D5-9BAB-5D17CD585E89@jcrosoft.com>
 <B256D81BAE5131468A838E5D7A24364172FFBC8C@penmbx01>
 <C90D6485-5915-4FC6-AA67-C035265057B6@jcrosoft.com>
In-Reply-To: <C90D6485-5915-4FC6-AA67-C035265057B6@jcrosoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi JC,

> -----Original Message-----
> From: Jean-Christophe PLAGNIOL-VILLARD [mailto:plagnioj@jcrosoft.com]
> Sent: Tuesday, March 11, 2014 7:14 PM
> To: Yang, Wenyou
> Cc: Jean-Christophe PLAGNIOL-VILLARD; mark.rutland@arm.com;
> devicetree@vger.kernel.org; pawel.moll@arm.com;
> ijc+devicetree@hellion.org.uk; linus.walleij@linaro.org; Linux Kernel
> list; b.brezillon@overkiz.com; robh+dt@kernel.org; galak@codeaurora.org;
> <linux-arm-kernel@lists.infradead.org> mailing list; Lin, JM
> Subject: Re: [PATCH] pinctrl: at91: add the config GPIO_OUTPUT_x
> 
> 
> On Mar 11, 2014, at 2:54 PM, Yang, Wenyou <Wenyou.Yang@atmel.com> wrote:
> 
> >
> >
> >> -----Original Message-----
> >> From: Jean-Christophe PLAGNIOL-VILLARD [mailto:plagnioj@jcrosoft.com]
> >> Sent: Tuesday, March 11, 2014 12:16 PM
> >> To: Yang, Wenyou
> >> Cc: Jean-Christophe PLAGNIOL-VILLARD; mark.rutland@arm.com;
> >> devicetree@vger.kernel.org; pawel.moll@arm.com;
> >> ijc+devicetree@hellion.org.uk; linus.walleij@linaro.org; Linux Kernel
> >> list; b.brezillon@overkiz.com; robh+dt@kernel.org;
> >> galak@codeaurora.org; <linux-arm-kernel@lists.infradead.org> mailing
> >> list
> >> Subject: Re: [PATCH] pinctrl: at91: add the config GPIO_OUTPUT_x
> >>
> >>
> >> On Mar 11, 2014, at 9:28 AM, Yang, Wenyou <Wenyou.Yang@atmel.com>
> wrote:
> >>
> >>> Hi JC,
> >>>
> >>>> -----Original Message-----
> >>>> From: Yang, Wenyou
> >>>> Sent: Wednesday, March 05, 2014 1:32 PM
> >>>> To: Jean-Christophe PLAGNIOL-VILLARD
> >>>> Cc: linus.walleij@linaro.org; b.brezillon@overkiz.com; <linux-arm-
> >>>> kernel@lists.infradead.org> mailing list; Linux Kernel list;
> >>>> devicetree@vger.kernel.org; robh+dt@kernel.org; pawel.moll@arm.com;
> >>>> mark.rutland@arm.com; ijc+devicetree@hellion.org.uk;
> >>>> galak@codeaurora.org
> >>>> Subject: RE: [PATCH] pinctrl: at91: add the config GPIO_OUTPUT_x
> >>>>
> >>>> Hi JC,
> >>>>
> >>>>> -----Original Message-----
> >>>>> From: Jean-Christophe PLAGNIOL-VILLARD
> >>>>> [mailto:plagnioj@jcrosoft.com]
> >>>>> Sent: Wednesday, March 05, 2014 12:58 PM
> >>>>> To: Yang, Wenyou
> >>>>> Cc: Jean-Christophe PLAGNIOL-VILLARD; linus.walleij@linaro.org;
> >>>>> b.brezillon@overkiz.com; <linux-arm-kernel@lists.infradead.org>
> >>>>> mailing list; Linux Kernel list; devicetree@vger.kernel.org;
> >>>>> robh+dt@kernel.org; pawel.moll@arm.com; mark.rutland@arm.com;
> >>>>> ijc+devicetree@hellion.org.uk; galak@codeaurora.org
> >>>>> Subject: Re: [PATCH] pinctrl: at91: add the config GPIO_OUTPUT_x
> >>>>>
> >>>>>
> >>>>> On Mar 5, 2014, at 9:53 AM, Wenyou Yang <wenyou.yang@atmel.com>
> >> wrote:
> >>>>>
> >>>>>> In order to support the pinctrl sleep state.
> >>>>>
> >>>>> As I said before NACK
> >>>>>
> >>>>> this is not the job of the pinctrl to describe gpio output or
> >>>>> input state
> >>>> But according to what said in the section "GPIO mode pitfalls" of
> >>>> Documentation/pinctrl.txt.
> >>>> It should be handle by the pinctrl.
> >>>>
> >>>> If not, to deal with the sleep state will be very complicated.
> >>>> Muxing the pins for FUNCTION to enable peripheral, then twist them
> >>>> over to GPIO mode and use gpio_direction_output() to drive it HIGH
> >>>> or LOW during sleep.
> >>>>
> >>>> --->8 ------------
> >>>> The solution is to not think that what the datasheet calls "GPIO
> >> mode"
> >>>> has to be handled by the <linux/gpio.h> interface. Instead view
> >>>> this as a certain pin config setting. Look in e.g.
> >>>> <linux/pinctrl/pinconf- generic.h> and you find this in the
> documentation:
> >>>>
> >>>> PIN_CONFIG_OUTPUT: this will configure the pin in output, use
> >> argument
> >>>>    1 to indicate high level, argument 0 to indicate low level.
> >>>>
> >>>> So it is perfectly possible to push a pin into "GPIO mode" and
> >>>> drive the line low as part of the usual pin control map.
> >>>> ---<8 ------------
> >>>
> >>> Do you have any feedback?
> >>
> >> Here the issue is that you do drive the gpio and use as a gpio
> >>
> >> which means you request it as a GPIO so after you can not reswitch it
> >> to alternative function and the gpio is already requested as
> >> alternative function
> >>
> >> So basically you mess-up with the gpio API and pinctrl API by
> >> bypassing both
> >
> > But I don't agree with you.
> >
> > As I known, in mainline the other SoC vendors provide such function,
> configure the gpio mode with output config by pinctrl.
> >
> > For example, ST. nomadisk.
> > You can see it in the function: nmk_pin_config_set() of the file,
> pinctrl-nomadik.c.
> > It provides GPIO mode and OUTPUT config.
> >
> > This is a good solution, as what said in Documentation/pinctrl.txt,
> >
> > it is perfectly possible to push a pin into "GPIO mode" and drive the
> line low as part of the usual pin control map.
> >
> 
> This is simple if we use gpio mode as pinctrl tomorrow we will see gpio
> configuration in pinctrl such as chip reset, default led state etc...
> 
> The pinctrl is not here to control a *GPIO* but to describe the
> configuration of pin.
What you said is the usual use case.

But, in the Power Management scenario, there are the following requirements to meet:
When running time, the pins are configured as the PERIPH functions by the pinctrl default state as usaul.
When suspending to memory, the pins are configured as GPIO output low, output high or input by the pinctrl sleep state.
When resuming from suspended, the pins are configured back as the PERIPH functions.

I just found the same implementation by Boris which is better.
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-August/194975.html

Boris, Could you have something to say?

> >>>>>>
> >>>>>> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> >>>>>> ---
> >>>>>> Hi Linus,
> >>>>>>
> >>>>>> The patch is based on branch: for-next
> >>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctr
> >>>>>> l
> >>>>>>
> >>>>>> Best Regards,
> >>>>>> Wenyou Yang
> >>>>>>
> >>>>>> drivers/pinctrl/pinctrl-at91.c     |   31
> >>>>> +++++++++++++++++++++++++++++++
> >>>>>> include/dt-bindings/pinctrl/at91.h |    2 ++
> >>>>>> 2 files changed, 33 insertions(+)
> >>>>>>
> >>>>>> diff --git a/drivers/pinctrl/pinctrl-at91.c
> >>>>>> b/drivers/pinctrl/pinctrl-at91.c index 5d24aae..fc51e59 100644
> >>>>>> --- a/drivers/pinctrl/pinctrl-at91.c
> >>>>>> +++ b/drivers/pinctrl/pinctrl-at91.c
> >>>>>> @@ -62,6 +62,8 @@ static int gpio_banks;
> >>>>>> #define DEGLITCH	(1 << 2)
> >>>>>> #define PULL_DOWN	(1 << 3)
> >>>>>> #define DIS_SCHMIT	(1 << 4)
> >>>>>> +#define GPIO_OUTPUT_HIGH	(1 << 5)
> >>>>>> +#define GPIO_OUTPUT_LOW		(1 << 6)
> >>>>>> #define DEBOUNCE	(1 << 16)
> >>>>>> #define DEBOUNCE_VAL_SHIFT	17
> >>>>>> #define DEBOUNCE_VAL	(0x3fff << DEBOUNCE_VAL_SHIFT)
> >>>>>> @@ -152,12 +154,15 @@ struct at91_pinctrl_mux_ops {
> >>>>>> 	void (*set_pulldown)(void __iomem *pio, unsigned mask, bool
> is_on);
> >>>>>> 	bool (*get_schmitt_trig)(void __iomem *pio, unsigned pin);
> >>>>>> 	void (*disable_schmitt_trig)(void __iomem *pio, unsigned
> mask);
> >>>>>> +	bool (*get_gpio_output)(void __iomem *pio, unsigned mask);
> >>>>>> +	void (*set_gpio_output)(void __iomem *pio, unsigned mask,
> >> bool
> >>>>>> +is_high);
> >>>>>> 	/* irq */
> >>>>>> 	int (*irq_type)(struct irq_data *d, unsigned type); };
> >>>>>>
> >>>>>> static int gpio_irq_type(struct irq_data *d, unsigned type);
> >>>>>> static int alt_gpio_irq_type(struct irq_data *d, unsigned type);
> >>>>>> +static void at91_mux_gpio_enable(void __iomem *pio, unsigned
> >>>>>> +mask, bool input);
> >>>>>>
> >>>>>> struct at91_pinctrl {
> >>>>>> 	struct device		*dev;
> >>>>>> @@ -472,6 +477,20 @@ static bool
> >>>>>> at91_mux_pio3_get_schmitt_trig(void
> >>>>> __iomem *pio, unsigned pin)
> >>>>>> 	return (__raw_readl(pio + PIO_SCHMITT) >> pin) & 0x1; }
> >>>>>>
> >>>>>> +static bool at91_mux_pio3_get_gpio_output(void __iomem *pio,
> >>>>>> +unsigned
> >>>>>> +pin) {
> >>>>>> +	return (__raw_readl(pio + PIO_ODSR) >> pin) & 0x1; }
> >>>>>> +
> >>>>>> +static void at91_mux_pio3_set_gpio_output(void __iomem *pio,
> >>>>>> +						unsigned mask,
> >>>>>> +						bool is_high)
> >>>>>> +{
> >>>>>> +	at91_mux_gpio_enable(pio, mask, 0);
> >>>>>> +	writel_relaxed(mask, pio + (is_high ? PIO_SODR : PIO_CODR)); }
> >>>>>> +
> >>>>>> +
> >>>>>> static struct at91_pinctrl_mux_ops at91rm9200_ops = {
> >>>>>> 	.get_periph	= at91_mux_get_periph,
> >>>>>> 	.mux_A_periph	= at91_mux_set_A_periph,
> >>>>>> @@ -495,6 +514,8 @@ static struct at91_pinctrl_mux_ops
> >>>>>> at91sam9x5_ops
> >>>>> = {
> >>>>>> 	.set_pulldown	= at91_mux_pio3_set_pulldown,
> >>>>>> 	.get_schmitt_trig = at91_mux_pio3_get_schmitt_trig,
> >>>>>> 	.disable_schmitt_trig = at91_mux_pio3_disable_schmitt_trig,
> >>>>>> +	.get_gpio_output = at91_mux_pio3_get_gpio_output,
> >>>>>> +	.set_gpio_output = at91_mux_pio3_set_gpio_output,
> >>>>>> 	.irq_type	= alt_gpio_irq_type,
> >>>>>> };
> >>>>>>
> >>>>>> @@ -741,6 +762,10 @@ static int at91_pinconf_get(struct
> >>>>>> pinctrl_dev
> >>>>> *pctldev,
> >>>>>> 		*config |= PULL_DOWN;
> >>>>>> 	if (info->ops->get_schmitt_trig &&
> >>>>>> info->ops->get_schmitt_trig(pio,
> >>>>> pin))
> >>>>>> 		*config |= DIS_SCHMIT;
> >>>>>> +	if (info->ops->get_gpio_output) {
> >>>>>> +		*config |= info->ops->get_gpio_output(pio, pin) ?
> >>>>>> +					GPIO_OUTPUT_HIGH : GPIO_OUTPUT_LOW;
> >>>>>> +	}
> >>>>>>
> >>>>>> 	return 0;
> >>>>>> }
> >>>>>> @@ -778,6 +803,12 @@ static int at91_pinconf_set(struct
> >>>>>> pinctrl_dev
> >>>>> *pctldev,
> >>>>>> 			info->ops->set_pulldown(pio, mask, config &
> PULL_DOWN);
> >>>>>> 		if (info->ops->disable_schmitt_trig && config &
> DIS_SCHMIT)
> >>>>>> 			info->ops->disable_schmitt_trig(pio, mask);
> >>>>>> +		if (info->ops->set_gpio_output) {
> >>>>>> +			if (config & GPIO_OUTPUT_HIGH)
> >>>>>> +				info->ops->set_gpio_output(pio, mask, 1);
> >>>>>> +			if (config & GPIO_OUTPUT_LOW)
> >>>>>> +				info->ops->set_gpio_output(pio, mask, 0);
> >>>>>> +		};
> >>>>>>
> >>>>>> 	} /* for each config */
> >>>>>>
> >>>>>> diff --git a/include/dt-bindings/pinctrl/at91.h
> >>>>>> b/include/dt-bindings/pinctrl/at91.h
> >>>>>> index 0fee6ff..e799268 100644
> >>>>>> --- a/include/dt-bindings/pinctrl/at91.h
> >>>>>> +++ b/include/dt-bindings/pinctrl/at91.h
> >>>>>> @@ -15,6 +15,8 @@
> >>>>>> #define AT91_PINCTRL_DEGLITCH		(1 << 2)
> >>>>>> #define AT91_PINCTRL_PULL_DOWN		(1 << 3)
> >>>>>> #define AT91_PINCTRL_DIS_SCHMIT		(1 << 4)
> >>>>>> +#define AT91_PINCTRL_OUTPUT_HIGH	(1 << 5)
> >>>>>> +#define AT91_PINCTRL_OUTPUT_LOW		(1 << 6)
> >>>>>> #define AT91_PINCTRL_DEBOUNCE		(1 << 16)
> >>>>>> #define AT91_PINCTRL_DEBOUNCE_VAL(x)	(x << 17)
> >>>>>>
> >>>>>> --
> >>>>>> 1.7.9.5
> >>>>>>
> >>>
> >>>
> >>> _______________________________________________
> >>> linux-arm-kernel mailing list
> >>> linux-arm-kernel@lists.infradead.org
> >>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


Bes Regards,
Wenyou Yang

