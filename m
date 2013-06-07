Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab3FGS7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:59:46 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51692 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094Ab3FGS7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:59:45 -0400
Date: Fri, 7 Jun 2013 20:59:40 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: "luke.leighton" <luke.leighton@gmail.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        debian-kernel@lists.debian.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
Message-ID: <20130607205940.4816fed5@skate>
In-Reply-To: <CAPweEDzW60poOYahm31aW3_A=NvZmyBPPPgM9PzdvuPJnju69A@mail.gmail.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	<1370475609.20454.44.camel@localhost>
	<CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com>
	<1733666.lHUBcfUXq9@flatron>
	<20130606112723.71ddd70c@skate>
	<CAPweEDzW60poOYahm31aW3_A=NvZmyBPPPgM9PzdvuPJnju69A@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, 7 Jun 2013 19:26:49 +0100, luke.leighton wrote:

> > Have you noticed that it is already the case in mainline?
> 
>  i knew there was a little bit, but not the extent of the commits.

Then you could probably use a bit of your time to read the kernel
commit logs rather than writing hundreds of e-mails, no?

> > My colleague Maxime Ripard (Cc'ed)
> 
>  maxime: we need to talk :)
> 
>  please tell me in 4 or 5 sentences what you've managed to do so far,
> expanding a little on what thomas says below, more specifically what
> it achieves and/or allows rather than technically what it does
> (suitable for managers and directors in other words), and what plans
> you'd like to see happen.

Maxime will reply to this in more details, but I believe the status is:

 * Interrupt controller is working.
 * Clock drivers are working.
 * Pinctrl is working.
 * GPIO is working.
 * Timer is working.
 * UART is working
 * Watchdog is on its way (patches posted)
 * Ethernet is on its way (patches posted)
 * I2C is on its way (patches posted)

Cubieboard (A10), Hackberry (A10), Mini XPlus (A10) And OLinuxino (A13)
are supported.

See arch/arm/boot/dts/sun{4,5}i* for a good overview.

> > All in mainline, completely Device Tree based.
> 
>  great.  which version did it first hit, i.e. what will the first
> signs of this be when allwinner begin doing "git pulls"?

The very first support landed in 3.8.

> > So isn't this entire discussion completely moot?
> 
>  no because it's totally in isolation from allwinner.  i need to give
> them a heads-up, and get them involved, giving them specific
> incentives [which nobody's yet given!!] for following a particular
> path [or paths] yet to be recommended.

You really believe you're more important than you really are, I'd say.

My colleague Maxime is in contact with Allwinner, he has regular
discussion with them, started reviewing some of the kernel code they're
writing, has received datasheets from them, and evaluation boards.

So this work is definitely not done in isolation from Allwinner, and
they have received much more than an heads-up from Maxime.

> > The mainline support
> > for sunxi has already started since 6 months or so, and has been Device
> > Tree based from day one.
> 
> to clarify: the *community-driven* mainline support for sunxi.  ok -
> which chips?  sun3i (ARM9), sun4i (Cortex A8), sun5i, sun6i and sun7i
> (Dual-Core Cortex A7)?  which ones are in?

So far, A10 and A13. Maxime has received a A31 evaluation board from
Allwinner very recently, and also A10S and A20 boards. I suppose he
will be working on those fairly and posting the corresponding patches
fairly soon.

In other words, it looks like you've started an entire discussion about
the mainline support for Allwinner SoCs without having a look at what
"git log" tells you... Which by itself is a very good indicator that
you're probably not the best interlocutor for Allwinner as far as
mainline development is concerned.

Best regards,

Thomas Petazzoni
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
