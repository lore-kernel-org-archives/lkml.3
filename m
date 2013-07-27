Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab3G0Jvk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 05:51:40 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:62121 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3G0Jvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 05:51:36 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
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
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people interested in device tree janitoring / cleanup?]
Date: Sat, 27 Jul 2013 11:51:29 +0200
Message-ID: <2007664.vYsECFSKrV@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130727050406.GB4221@netboy>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <CAOesGMhEr3DiFm5uSgoHPFUMY4jWu4HkeTU2UmOGj=dS75Vk+g@mail.gmail.com> <20130727050406.GB4221@netboy>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 of July 2013 07:04:08 Richard Cochran wrote:
> On Fri, Jul 26, 2013 at 08:49:43AM -0700, Olof Johansson wrote:
> > Long term, final goal is likely to be close to what Russell is saying
> 
> Why is this a long term goal? Start today.
> 
> > -- nothing should go into the kernel tree unless the binding is in a
> > fully stable state. However, we have a transitional period between now
> > and then, and even when we're at the final state there will be need to
> > have some sort of sandbox for development and test of future bindings.
> 
> Why not just set up a git tree right away?
> 
> > Dealing with all that, as well as the actual process for locking in
> > bindings, is what needs to be sorted out.
> > 
> > I think we're all in agreement that bindings that change over time are
> > nothing but pain, but we're arguing that in circles anyway.
> 
> No.
> 
> I keep saying, the bindings must be stable ABI, *today*.
> 
> You keep saying, maybe later, but until then we will make things up as
> we go along.

We have currently a lot of broken bindings, because people didn't know how 
to define ones and those they defined have not been properly reviewed. Do 
you really want such broken ABI in the kernel?

Sure, there are many existing bindings that can be just made stable and 
well they probably are already de facto stable. This is mostly about 
subsystem bindings and whatever already has many users, both made them get 
more thought when designing and more review before merging.

Still, a lot of device and platform-specific bindings are simply broken. 
Take max8925 backlight driver, that Olof started this whole discussion 
with, as an example. We need to sort them out before they can be 
stabilized.

This is the whole point of having distinction between stable and staging 
bindings.

Best regards,
Tomasz

