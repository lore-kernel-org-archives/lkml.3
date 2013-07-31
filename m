Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144Ab3GaPHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:07:36 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:49757 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab3GaPHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:07:35 -0400
Date: Wed, 31 Jul 2013 17:07:19 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
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
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130731150717.GD4904@netboy>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <1441731.8CGUI1tUxh@flatron>
 <1375267057.20042.52.camel@sakura.staff.proxad.net>
 <1479410.BSGDrOcRvP@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479410.BSGDrOcRvP@thinkpad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 12:59:59PM +0200, Tomasz Figa wrote:
> On Wednesday 31 of July 2013 12:37:37 Maxime Bizon wrote:
> > 
> > Board files are C code anyone has the skill to edit/understand/refactor.
> > Moving to DT and keep them in tree tightly coupled with the kernel
> > version just adds another layer of indirection for *no purpose*.

+1

That is exactly what I tried to say.

> > Linus started the whole thing some years ago by refusing to pull ARM
> > tree [1]. Reread his post, what he wants is clearly b).
> > 
> > Going a) does not solve any problem. You are just moving churn to
> > somewhere else. We had board files churn, then defconfigs churn, DTS
> > files (and associated drivers) will be next.

And at this rate, we are headed for another Linus ultimatum, sooner or
later.

> > DT is self inflicted pain. It has to be for the greater good.
> 
> It has several benefits over board files that I mentioned above, possible 
> without fully separating them from kernel tree.

Every time a criticism is voiced about DT, the DT people stick their
fingers in their ears and say, "NAH, NAH, NAH, I CAN'T HEAR YOU!"

WRT to DT-as-platform-device, we would rather stick with the C code,
please. Just pushing the configuration tables into an external form
does not simplify the problem. In fact, it creates new problems by
inviting the possibility of a bootloader/DT/kernel mismatch.

Thanks,
Richard

