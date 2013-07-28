Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab3G1JNB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 05:13:01 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:37731 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3G1JM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 05:12:59 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
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
Date: Sun, 28 Jul 2013 11:12:53 +0200
Message-ID: <1416484.XDfk5G56BI@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130728085650.GA4683@netboy>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <1441731.8CGUI1tUxh@flatron> <20130728085650.GA4683@netboy>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 of July 2013 10:56:52 Richard Cochran wrote:
> On Sat, Jul 27, 2013 at 11:51:06AM -0700, Tomasz Figa wrote:
> > On Saturday 27 of July 2013 20:31:01 Richard Cochran wrote:
> > > Frankly, I am really surprised and shocked at the cavalier attitude
> > > expressed here WRT DT bindings in released kernels. Think about the
> > > *users* of this code. Not everyone working with ARM Linux is a
> > > kernel
> > > developer or a DT guru. There is really no indication at all that
> > > the
> > > ARM Linux DT stuff released so far are not stable and trustworthy.
> 
> Read the above again, please.

I'm not really sure what effect on users this has. Maybe you should define 
"users".

Sure, if you don't like the fact that it is not cleary said, whether we 
use a) or b) (see below), then it's hard to disagree with you - it should 
have been said. We are trying to fix this now.

> > Well, it depends on how we use the DT. There are (at least) two
> > possible> 
> > usage scenarios:
> >  a) using DT as direct replacement for board files - this means that
> >  you
> >  
> >     are free to say that DTSes are strictly coupled with kernel
> >     version
> >     and you are free to modify the bindings - see the analogy to board
> >     files, where you could modify the platform data structures and
> >     could
> >     not directly copy board file from one kernel version to another,
> >  
> >  b) using DT as an ABI - this is the original way, i.e. define stable
> >  
> >     bindings and make sure that anu DTB built for older kernel will
> >     work,
> >     with equal or greater set of functionality on newer kernels.
> > 
> > Now I believe in this thread the point whether we should use a) or b)
> > or a combination of both has been raised.
> 
> If you seriously want to pursue a) then you are thinking only of
> yourself.
> 
> Please consider the needs of the people trying to use your code in
> actual practice.

Care to explain this reasoning?

Let's say I'm not strongly for neither of above and I'd like you to 
convince me to one of the options.

Best regards,
Tomasz

