Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbbAPBVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:21:08 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:36838 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbbAPBVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:21:06 -0500
Date: Fri, 16 Jan 2015 10:20:56 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] Documentation: gpio: fix bindings document
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <2479604.mfbgZIQjOA@avalon>
References: <CAL_JsqL+0C_wQ26=bdwYGLj0X=vzmn8khFfo_Ryet5O=k-XFzw@mail.gmail.com> <2479604.mfbgZIQjOA@avalon>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20150116102056.F108.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent, Rob,


On Thu, 15 Jan 2015 16:10:54 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> Hi Rob,
> 
> On Thursday 15 January 2015 08:07:18 Rob Herring wrote:
> > On Thu, Jan 15, 2015 at 2:52 AM, Masahiro Yamada
> > 
> > <yamada.m@jp.panasonic.com> wrote:
> > > Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> > 
> > Perhaps some explanation. You can't just remove properties. Please
> > explain to what extent the old/wrong name is used. This patch is only
> > okay if there are no users of gpio-phandle.
> 
> As far as I understand the patch just fixes a typo. There has never been a 
> gpio-phandle for GPIO controllers, only for GPIO consumers.


Yes, this patch just fixes typos.
I thought I could be lazy here...



> > > ---
> > > 
> > >  Documentation/devicetree/bindings/gpio/gpio.txt | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt
> > > b/Documentation/devicetree/bindings/gpio/gpio.txt index b9bd1d6..f7a158d
> > > 100644
> > > --- a/Documentation/devicetree/bindings/gpio/gpio.txt
> > > +++ b/Documentation/devicetree/bindings/gpio/gpio.txt
> > > @@ -69,7 +69,8 @@ GPIO pin number, and GPIO flags as accepted by the
> > > "qe_pio_e" gpio-controller.> 
> > >  ----------------------------------
> > >  
> > >  A gpio-specifier should contain a flag indicating the GPIO polarity;
> > >  active-> 
> > > -high or active-low. If it does, the follow best practices should be
> > > followed: +high or active-low. If it does, the following best practices
> > > should be> 
> > > +followed:
> > >  The gpio-specifier's polarity flag should represent the physical level at
> > >  the GPIO controller that achieves (or represents, for inputs) a
> > >  logically asserted> 
> > > @@ -147,7 +148,7 @@ contains information structures as follows:
> > >         numeric-gpio-range ::=
> > >         
> > >                         <pinctrl-phandle> <gpio-base> <pinctrl-base>
> > >                         <count>
> > >         
> > >         named-gpio-range ::= <pinctrl-phandle> <gpio-base> '<0 0>'
> > > 
> > > -       gpio-phandle : phandle to pin controller node.
> > > +       pinctrl-phandle : phandle to pin controller node
> > > 
> > >         gpio-base : Base GPIO ID in the GPIO controller
> > >         pinctrl-base : Base pinctrl pin ID in the pin controller
> > >         count : The number of GPIOs/pins in this range
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


