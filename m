Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab3G0E5p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 00:57:45 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:32983 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3G0E5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 00:57:42 -0400
Date: Sat, 27 Jul 2013 06:57:24 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Rob Herring <robherring2@gmail.com>
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130727045723.GA4221@netboy>
References: <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726080115.GA5436@netboy>
 <1374831744.2923.42.camel@shinybook.infradead.org>
 <20130726130927.GC4219@netboy>
 <20130726141016.GF9858@sirena.org.uk>
 <CAOesGMhEr3DiFm5uSgoHPFUMY4jWu4HkeTU2UmOGj=dS75Vk+g@mail.gmail.com>
 <51F2A57D.1090704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F2A57D.1090704@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 11:36:13AM -0500, Rob Herring wrote:
> On 07/26/2013 10:49 AM, Olof Johansson wrote:
> > On Fri, Jul 26, 2013 at 7:10 AM, Mark Brown <broonie@kernel.org> wrote:
> >> On Fri, Jul 26, 2013 at 03:09:29PM +0200, Richard Cochran wrote:
> >>
> >>> Unless I totally misunderstood, the thread is talking about letting
> >>> established bindings change with each new kernel version.  I am
> >>> opposed to that.
> >>
> >> No, nobody is really saying that is a particularly good idea.  There is
> >> some debate about how we work out what an established binding is but
> >> there's no serious suggestion that we don't want stable bindings.
> > 
> > Yes, what Mark said -- _today_ all bindings are subject to change and
> > can be changed in lockstep with the kernel. This has been necessary as
> > part of development to sort out all of the various bootstrapping
> > issues across platforms.

This statement is an incredible piece of doublespeak. "Of course we
want stable bindings. That is why 'all bindings are subject to change
and can be changed in lockstep with the kernel.'"

If you want to get away from the DT churn, then you have got to tell
people in no uncertain terms that bindings in a released kernel are a
stable ABI and must be supported into the future.

If you need a playground for new ideas, refactoring platforms, etc,
then go right ahead and create one, but please don't do this with
released kernels.

> This is absolutely not true on a global basis. Any binding used on
> powerpc or sparc is not subject to change. Furthermore, there are ARM
> platforms such as highbank where the bindings are expected to be stable.
> That's not saying they don't change (new properties for SATA just
> today), but they only change in a backwards compatible way.

Right, and lets hope the arm tree can also take this stand.

Thanks,
Richard
