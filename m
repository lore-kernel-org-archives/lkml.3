Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaHKKYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 06:24:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23636 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaHKKYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 06:24:15 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-5a-53e899cda986
From: Jingoo Han <jg1.han@samsung.com>
To: "=?UTF-8?Q?'Andreas_F=C3=A4rber'?=" <afaerber@suse.de>
Cc: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        "'Stephan van Schaik'" <stephan@synkhronix.com>,
        "'Vincent Palatin'" <vpalatin@chromium.org>,
        "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1406868897-26874-1-git-send-email-afaerber@suse.de>
 <1406868897-26874-6-git-send-email-afaerber@suse.de>
 <CAD=FV=WhocoyQ=rU7dU1EPM-PAQq06gg9HhamSOm+BgMDeM8NA@mail.gmail.com>
 <53DBFE8A.7020505@suse.de> <53DBFF22.3010905@gmail.com>
 <000e01cfb0a7$25d0ed70$7172c850$%han@samsung.com> <53E73827.7000703@suse.de>
In-reply-to: <53E73827.7000703@suse.de>
Subject: Re: [PATCH v5 05/10] ARM: dts: Move dp_hpd from exynos5250 into
 smdk5250 and snow
Date: Mon, 11 Aug 2014 19:24:12 +0900
Message-id: <003601cfb54e$655130d0$2ff39270$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+0e6zL3vqggtCXTDSpZZjxR9BZTQA0oMZg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t8zQ92zM18EG6zbIGzRvKnYYtK6A0wW
	84+cY7U4u+wgm0X/m4WsFuderWS0OPq7wOLywkusFr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9
	mddi6fWLTBYTpq9lsWjde4TdYv+xn4wW62e8ZrFYtesPo8W2b3dYHEQ81sxbw+jR0tzD5jG7
	4SKLx+W+XiaPv8+vs3j8XfWC2WPnrLvsHiuXf2Hz2LSqk81j85J6j74tqxg9Np+u9ni67jC7
	x+dNcgF8UVw2Kak5mWWpRfp2CVwZC9/dYyl4p1Nx++UP5gbG24pdjJwcEgImEq1/TjBC2GIS
	F+6tZwOxhQSWMUocfGTVxcgBVrOiQ7eLkQsovIhR4vLrC0wQzm9GiZMzbzCDNLAJqEl8+XKY
	HcQWEbCQ6H2/gRWkiFlgGZvEvA6QIpCO40wSh/p/s4BUcQqoS0y6vgWsQ1ggRmLKy5OsIOtY
	BFQlTs4zAwnzCthKTNjTyQphC0r8mHwPrJUZpHXeImYIW1viybsLrBCXqks8+qsLYooIGEk8
	X+wNUSEise/FO0aQCyQE2jkl5m2dwwSSYBEQkPg2+RALRKusxKYDzJBwkJQ4uOIGywRGiVlI
	Fs9CsngWksWzkKxYwMiyilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMkGfXuYLx9wPoQYzLQ
	+onMUqLJ+cBkllcSb2hsZmRhamJqbGRuaUaasJI4b9LDpCAhgfTEktTs1NSC1KL4otKc1OJD
	jEwcnFINjL3x0mWml/YxJjvbXLywV/8w35vHZ8IVbnu9mWqgO2Vjr2yLRJLty1+md+zbdbd0
	qhQUbziUueBUA/ePhkvMP/VUhXO5j7/MSv/u09ES2Pwjpaap5/GduJJj3wr8xGb3zPt54ckb
	o/8cjQyL/i+P38p1NXZm9sUMPVPmnKCO5SsPJjQ+VjzOpcRSnJFoqMVcVJwIAIjwvBJcAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsVy+t9jAd2zM18EG9z8y2PRvKnYYtK6A0wW
	84+cY7U4u+wgm0X/m4WsFuderWS0OPq7wOLywkusFr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9
	mddi6fWLTBYTpq9lsWjde4TdYv+xn4wW62e8ZrFYtesPo8W2b3dYHEQ81sxbw+jR0tzD5jG7
	4SKLx+W+XiaPv8+vs3j8XfWC2WPnrLvsHiuXf2Hz2LSqk81j85J6j74tqxg9Np+u9ni67jC7
	x+dNcgF8UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+Abpu
	mTlADysplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYMxa+u8dS8E6n4vbL
	H8wNjLcVuxg5OCQETCRWdOh2MXICmWISF+6tZ+ti5OIQEljEKHH59QUmCOc3o8TJmTeYQarY
	BNQkvnw5zA5iiwhYSPS+38AKUsQssIxNYl4HSBFIx3EmiUP9v1lAqjgF1CUmXd8C1iEsECMx
	5eVJVpDVLAKqEifnmYGEeQVsJSbs6WSFsAUlfky+B9bKDNI6bxEzhK0t8eTdBVaIq9UlHv3V
	BTFFBIwkni/2hqgQkdj34h3jBEahWUgGzUIyaBaSQbOQtCxgZFnFKJpakFxQnJSea6RXnJhb
	XJqXrpecn7uJEZzsnknvYFzVYHGIUYCDUYmH9+CX58FCrIllxZW5hxglOJiVRHiXzHgRLMSb
	klhZlVqUH19UmpNafIjRFOjNicxSosn5wEScVxJvaGxiZmRpZGZhZGJuriTOe7DVOlBIID2x
	JDU7NbUgtQimj4mDU6qBcUXBF3ltqZl+kRd0KprbJC9kzKx8P09z/mqvMoaV+sv2K/xyer6r
	7u9hS5lm6etpb/YdVxQ8dnZrw6z5Zz/PXme9qbTQ9O+rRKuF7zvO7dycLB5z86V0mM2nCnZn
	6YMt5UHmH182vWnjDK/Yva/q4saiTPeM1b0ZRQ/Urh13rd//PHyO5KeqECWW4oxEQy3mouJE
	AO6JgzmMAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 10, 2014 6:15 PM, Andreas Farber wrote:
> Am 05.08.2014 13:16, schrieb Jingoo Han:
> > On Saturday, August 02, 2014 5:57 AM, Tomasz Figa wrote:
> >> On 01.08.2014 22:54, Andreas Färber wrote:
> >>> Am 01.08.2014 22:33, schrieb Doug Anderson:
> >>>> On Thu, Jul 31, 2014 at 9:54 PM, Andreas Färber <afaerber@suse.de> wrote:
> >>>>> Spring uses a different GPIO, so this is not a generic SoC piece.
> >>>>>
> >>>>> Suggested-by: Tomasz Figa <t.figa@samsung.com>
> >>>>> Signed-off-by: Andreas Färber <afaerber@suse.de>
> >>>>> ---
> >>>>>  v5: New (Tomasz Figa)
> >>>>>  Frees dp_hpd for Spring.
> >>>>>
> >>>>>  arch/arm/boot/dts/exynos5250-pinctrl.dtsi | 7 -------
> >>>>>  arch/arm/boot/dts/exynos5250-smdk5250.dts | 9 +++++++++
> >>>>>  arch/arm/boot/dts/exynos5250-snow.dts     | 7 +++++++
> >>>>>  3 files changed, 16 insertions(+), 7 deletions(-)
> >>>>>
> >>>>> diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-
> pinctrl.dtsi
> >>>>> index 886cfca044ac..ed0e5230514b 100644
> >>>>> --- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> >>>>> +++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> >>>>> @@ -581,13 +581,6 @@
> >>>>>                         samsung,pin-pud = <0>;
> >>>>>                         samsung,pin-drv = <0>;
> >>>>>                 };
> >>>>> -
> >>>>> -               dp_hpd: dp_hpd {
> >>>>> -                       samsung,pins = "gpx0-7";
> >>>>> -                       samsung,pin-function = <3>;
> >>>>> -                       samsung,pin-pud = <0>;
> >>>>> -                       samsung,pin-drv = <0>;
> >>>>> -               };
> >>>>>         };
> >>>>>
> >>>>>         pinctrl@13400000 {
> >>>>> diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-
> smdk5250.dts
> >>>>> index aaa055ac0fe3..5d30fe1dcda4 100644
> >>>>> --- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
> >>>>> +++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> >>>>> @@ -414,3 +414,12 @@
> >>>>>                 };
> >>>>>         };
> >>>>>  };
> >>>>> +
> >>>>> +&pinctrl_0 {
> >>>>> +       dp_hpd: dp_hpd {
> >>>>> +               samsung,pins = "gpx0-7";
> >>>>> +               samsung,pin-function = <3>;
> >>>>> +               samsung,pin-pud = <0>;
> >>>>> +               samsung,pin-drv = <0>;
> >>>>> +       };
> >>>>> +};
> >>>>> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> >>>>> index c4b0c73c736d..a9a2f2743794 100644
> >>>>> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> >>>>> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> >>>>> @@ -547,6 +547,13 @@
> >>>>>  };
> >>>>>
> >>>>>  &pinctrl_0 {
> >>>>> +       dp_hpd: dp_hpd {
> >>>>> +               samsung,pins = "gpx0-7";
> >>>>> +               samsung,pin-function = <3>;
> >>>>> +               samsung,pin-pud = <0>;
> >>>>> +               samsung,pin-drv = <0>;
> >>>>> +       };
> >>>>> +
> >>>>
> >>>> NAK.  dp_hpd is a generic SoC piece.  Pin function 0 and 1 are GPIOs.
> >>>> Pin function 3 is special function.  This pin _is_ the hot plug detect
> >>>> pin for display port.  When it's set as special function 3 it goes
> >>>> straight into the hot plug logic of the display port controller.
> >>>>
> >>>> Spring may have had its reasons to detect hot plug events on a GPIO
> >>>> instead of using this pin, but that doesn't make this pin any less the
> >>>> "hot plug pin".
> >>>
> >>> Please advise how to handle it then: Should there be two different
> >>> pinctrl entries (if so, how should it be named?),
> >>
> >> IMHO this is the right way. Just name the GPIO variant dp_hpd_gpio.
> >
> > Hi Andreas Färber,
> >
> > I agree with Tomasz Figa and Doug Anderson.
> > Please refer to the following.
> >
> > 1. case: Standard HPD pin is used. (smdk5420)
> > arch/arm/boot/dts/exynos5420-pinctrl.dts
> > 	pinctrl@13400000 {
> > 		dp_hpd: dp_hpd {
> > 			samsung,pins = "gpx0-7";
> > 			samsung,pin-function = <3>;
> > 			samsung,pin-pud = <0>;
> > 			samsung,pin-drv = <0>;
> > 		};
> > arch/arm/boot/dts/exynos5420-smdk5420.dts
> > 	dp-controller@145B0000 {
> > 		pinctrl-names = "default";
> > 		pinctrl-0 = <&dp_hpd>;
> > 		...
> >
> > 2. case: non-standard HPD pin such as GPIO is used. (peach pit)
> > arch/arm/boot/dts/exynos5420-peach-pit.dts
> > 	pinctrl@13400000 {
> > 		dp_hpd_gpio: dp_hpd_gpio {
> > 			samsung,pins = "gpx2-6";
> > 			samsung,pin-function = <0>;
> > 			samsung,pin-pud = <3>;
> > 			samsung,pin-drv = <0>;
> > 		};
> > 	dp-controller@145B0000 {
> > 		pinctrl-names = "default";
> > 		pinctrl-0 = <&dp_hpd_gpio>;
> > 		...
> > 		samsung,hpd-gpio = <&gpx2 6 0>;
> >
> > So, you need to follow the second case.
> > "dp_hpd_gpio" can be used for Spring board.
> 
> I believe I already did so in v6 [0]? Please take a look there and let
> me know if you still need anything changed. The label name seems
> identical, whereas for the node name I adopted the dashes convention.

OK, I checked v6 patches.
I have no objection. It looks good.
Thank you.

Best regards,
Jingoo Han

> 
> Thanks,
> Andreas
> 
> [0] https://patchwork.kernel.org/patch/4664691/
> 
> --
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
> GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

