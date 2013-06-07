Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab3FGS0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:26:52 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:42270 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab3FGS0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:26:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130606112723.71ddd70c@skate>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	<1370475609.20454.44.camel@localhost>
	<CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com>
	<1733666.lHUBcfUXq9@flatron>
	<20130606112723.71ddd70c@skate>
Date: Fri, 7 Jun 2013 19:26:49 +0100
Message-ID: <CAPweEDzW60poOYahm31aW3_A=NvZmyBPPPgM9PzdvuPJnju69A@mail.gmail.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: "luke.leighton" <luke.leighton@gmail.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        debian-kernel@lists.debian.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thomas i _very_ briefly spotted this when i was extremely busy
yesterday, and i'm grateful to the 2 or 3 people who've given me the
keywords and/or links to catch up.

On Thu, Jun 6, 2013 at 10:27 AM, Thomas Petazzoni
<thomas.petazzoni@free-electrons.com> wrote:
> Dear Tomasz Figa,
>
> On Thu, 06 Jun 2013 02:01:14 +0200, Tomasz Figa wrote:
>
>> I don't see any other solution here than moving all the Allwinner
>> code to DT (as it has been suggested in this thread several times
>> already), as this is the only hardware description method supported
>> by ARM Linux.
>
> Have you noticed that it is already the case in mainline?

 i knew there was a little bit, but not the extent of the commits.

> My colleague Maxime Ripard (Cc'ed)

 maxime: we need to talk :)

 please tell me in 4 or 5 sentences what you've managed to do so far,
expanding a little on what thomas says below, more specifically what
it achieves and/or allows rather than technically what it does
(suitable for managers and directors in other words), and what plans
you'd like to see happen.

> is the maintainer of the mainline Allwinner sunxi
> effort. It already supports a number of boards, has a pinctrl driver, a
> GPIO driver, serial port is working, network is working, I2C is
> working.
>
> All in mainline, completely Device Tree based.

 great.  which version did it first hit, i.e. what will the first
signs of this be when allwinner begin doing "git pulls"?

 and which boards.  bear in mind that one of those "boards" should
really be "the total range of products available across hundreds of
chinese tablet clone manufacturers".

 specific question: is one of the "boards" the one that tom cubie
submitted, which covers virtually every android tablet product
manufactured in the millions by chinese tablet clone manufacturers?


> So isn't this entire discussion completely moot?

 no because it's totally in isolation from allwinner.  i need to give
them a heads-up, and get them involved, giving them specific
incentives [which nobody's yet given!!] for following a particular
path [or paths] yet to be recommended.

> The mainline support
> for sunxi has already started since 6 months or so, and has been Device
> Tree based from day one.

to clarify: the *community-driven* mainline support for sunxi.  ok -
which chips?  sun3i (ARM9), sun4i (Cortex A8), sun5i, sun6i and sun7i
(Dual-Core Cortex A7)?  which ones are in?

l.
