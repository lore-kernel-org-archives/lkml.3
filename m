Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbbAULFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:05:18 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:58169 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbbAULFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:05:09 -0500
MIME-Version: 1.0
In-Reply-To: <20150120200740.GY4367@lukather>
References: <1421417021-3247-1-git-send-email-vishnupatekar0510@gmail.com>
 <1421417021-3247-6-git-send-email-vishnupatekar0510@gmail.com>
 <54BE8A0E.30604@gmail.com> <20150120200740.GY4367@lukather>
From: Vishnu Patekar <vishnupatekar0510@gmail.com>
Date: Wed, 21 Jan 2015 16:34:45 +0530
Message-ID: <CAEzqOZsWYQ+Aep6HBZXVtKGEJgKYAKJU2b0=nGvP0jPKECxn7g@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v4 5/5] ARM: sunxi: dts: Add PS2 nodes for
 A20 lime2 board
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Iain Paton <ipaton0@gmail.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 21, 2015 at 1:37 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
>
> On Tue, Jan 20, 2015 at 05:02:06PM +0000, Iain Paton wrote:
> > On 16/01/15 14:03, Vishnu Patekar wrote:
> > > Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
> > > ---
> > >  arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts |   12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > >
> > > diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> > > index ed364d5..3365f12 100644
> > > --- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> > > +++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> > > @@ -113,6 +113,18 @@
> > >                     status = "okay";
> > >             };
> > >
> > > +           ps20: ps2@01c2a000 {
> > > +                   pinctrl-names = "default";
> > > +                   pinctrl-0 = <&ps20_pins_a>;
> > > +                   status = "okay";
> > > +           };
> > > +
> > > +           ps21: ps2@01c2a400 {
> > > +                   pinctrl-names = "default";
> > > +                   pinctrl-0 = <&ps21_pins_a>;
> > > +                   status = "okay";
> > > +           };
> > > +
> > >             i2c0: i2c@01c2ac00 {
> > >                     pinctrl-names = "default";
> > >                     pinctrl-0 = <&i2c0_pins_a>;
> > >
> >
> > As the Lime2 doesn't actually have any PS2 connectors on the board,
> > I'd prefer that these are not enabled unconditionally. Doing so
> > only makes it more difficult for people who want to use these pins
> > for other functions.
> >
> > Device tree overlays seem to be close to being merged, perhaps we
> > could leave enabling this to an overlay?
>
> I already had the exact same reasoning, and this was even removed at
> some point. For some reason, it was added back, and I don't really
> know why.
This was removed in consideration that these pins conflict with HDMI,
however, these is not conflict.

It was kept there as an example. But, as there is no ps2 connector on
board, I've no problem to remove these nodes from Lime2 dts file.

>
> Maxime
>
>
> --
> Maxime Ripard, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com
