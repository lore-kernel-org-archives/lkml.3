Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbbAOOKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:10:32 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:51460 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbbAOOK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:10:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
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
Subject: Re: [PATCH] Documentation: gpio: fix bindings document
Date: Thu, 15 Jan 2015 16:10:54 +0200
Message-ID: <2479604.mfbgZIQjOA@avalon>
User-Agent: KMail/4.14.3 (Linux/3.17.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <CAL_JsqL+0C_wQ26=bdwYGLj0X=vzmn8khFfo_Ryet5O=k-XFzw@mail.gmail.com>
References: <1421311960-4120-1-git-send-email-yamada.m@jp.panasonic.com> <CAL_JsqL+0C_wQ26=bdwYGLj0X=vzmn8khFfo_Ryet5O=k-XFzw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Thursday 15 January 2015 08:07:18 Rob Herring wrote:
> On Thu, Jan 15, 2015 at 2:52 AM, Masahiro Yamada
> 
> <yamada.m@jp.panasonic.com> wrote:
> > Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> 
> Perhaps some explanation. You can't just remove properties. Please
> explain to what extent the old/wrong name is used. This patch is only
> okay if there are no users of gpio-phandle.

As far as I understand the patch just fixes a typo. There has never been a 
gpio-phandle for GPIO controllers, only for GPIO consumers.

> > ---
> > 
> >  Documentation/devicetree/bindings/gpio/gpio.txt | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt
> > b/Documentation/devicetree/bindings/gpio/gpio.txt index b9bd1d6..f7a158d
> > 100644
> > --- a/Documentation/devicetree/bindings/gpio/gpio.txt
> > +++ b/Documentation/devicetree/bindings/gpio/gpio.txt
> > @@ -69,7 +69,8 @@ GPIO pin number, and GPIO flags as accepted by the
> > "qe_pio_e" gpio-controller.> 
> >  ----------------------------------
> >  
> >  A gpio-specifier should contain a flag indicating the GPIO polarity;
> >  active-> 
> > -high or active-low. If it does, the follow best practices should be
> > followed: +high or active-low. If it does, the following best practices
> > should be> 
> > +followed:
> >  The gpio-specifier's polarity flag should represent the physical level at
> >  the GPIO controller that achieves (or represents, for inputs) a
> >  logically asserted> 
> > @@ -147,7 +148,7 @@ contains information structures as follows:
> >         numeric-gpio-range ::=
> >         
> >                         <pinctrl-phandle> <gpio-base> <pinctrl-base>
> >                         <count>
> >         
> >         named-gpio-range ::= <pinctrl-phandle> <gpio-base> '<0 0>'
> > 
> > -       gpio-phandle : phandle to pin controller node.
> > +       pinctrl-phandle : phandle to pin controller node
> > 
> >         gpio-base : Base GPIO ID in the GPIO controller
> >         pinctrl-base : Base pinctrl pin ID in the pin controller
> >         count : The number of GPIOs/pins in this range

-- 
Regards,

Laurent Pinchart

