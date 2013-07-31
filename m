Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555Ab3GaPYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:24:45 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:57255 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760385Ab3GaPYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:24:42 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: mbizon@freebox.fr, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        Arend van Spriel <arend@broadcom.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people interested in device tree janitoring / cleanup?]
Date: Wed, 31 Jul 2013 17:23:35 +0200
Message-ID: <1999586.84BnWE5EUh@thinkpad>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130731150717.GD4904@netboy>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <1479410.BSGDrOcRvP@thinkpad> <20130731150717.GD4904@netboy>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 of July 2013 17:07:19 Richard Cochran wrote:
> On Wed, Jul 31, 2013 at 12:59:59PM +0200, Tomasz Figa wrote:
> > On Wednesday 31 of July 2013 12:37:37 Maxime Bizon wrote:
> > > Board files are C code anyone has the skill to edit/understand/refactor.
> > > Moving to DT and keep them in tree tightly coupled with the kernel
> > > version just adds another layer of indirection for *no purpose*.
> 
> +1
> 
> That is exactly what I tried to say.

I agree with you to some extent. Don't be so extreme though. As I already 
said, this is not entirely "no purpose", as there are more benefits of having 
device tree than just separation from kernel tree.

> > > Linus started the whole thing some years ago by refusing to pull ARM
> > > tree [1]. Reread his post, what he wants is clearly b).
> > > 
> > > Going a) does not solve any problem. You are just moving churn to
> > > somewhere else. We had board files churn, then defconfigs churn, DTS
> > > files (and associated drivers) will be next.
> 
> And at this rate, we are headed for another Linus ultimatum, sooner or
> later.

(see end of the message)

> > > DT is self inflicted pain. It has to be for the greater good.
> > 
> > It has several benefits over board files that I mentioned above, possible
> > without fully separating them from kernel tree.
> 
> Every time a criticism is voiced about DT, the DT people stick their
> fingers in their ears and say, "NAH, NAH, NAH, I CAN'T HEAR YOU!"

I won't comment this...

> WRT to DT-as-platform-device, we would rather stick with the C code,
> please. Just pushing the configuration tables into an external form
> does not simplify the problem. In fact, it creates new problems by
> inviting the possibility of a bootloader/DT/kernel mismatch.

Care to stop ignoring my points other than those defending ideas (nowhere 
stated as good or bad) from extreme opinions?

I said it many, many times, that a) and b) I proposed are just two extremes. 
It is unlikely that an extreme solution will be the best option to choose. I 
am strongly for something in the middle, just like I wrote in several of my 
previous replies.

This is something that should be commented, not those extreme options.

Best regards,
Tomasz

