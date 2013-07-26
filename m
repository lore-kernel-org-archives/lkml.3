Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab3GZNJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:09:51 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:35246 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab3GZNJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:09:46 -0400
Date: Fri, 26 Jul 2013 15:09:29 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130726130927.GC4219@netboy>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726080115.GA5436@netboy>
 <1374831744.2923.42.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374831744.2923.42.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 10:42:24AM +0100, David Woodhouse wrote:
> On Fri, 2013-07-26 at 10:01 +0200, Richard Cochran wrote:
> > On Thu, Jul 25, 2013 at 03:37:53PM -0600, Jason Gunthorpe wrote:
> > > 
> > > We use DT has a kernel configuration input. Our environment is
> > > designed to guarantee 100% that the kernel and DT match exactly. DT
> > > very deliberately isn't an ABI boundary in our systems.
> > 
> > Think about what you just said.
> > 
> > The DT describes the *hardware* not the kernel. Why should you ever
> > need to update your DT at all?
> 
> Well, the nodes which describe hardware devices, according to the
> bindings which form an ABI contract between DT and drivers, should not
> normally change. Although they *can* change, if for example you change
> the MAC address and that's stored there. Or you change the PHY you want
> it to use. Or something like that. The *ABI* doesn't change, but the
> data you express *using* that ABI can change. That's kind of the point.

Unless I totally misunderstood, the thread is talking about letting
established bindings change with each new kernel version.  I am
opposed to that.

Of course, a user may want to change the values of his MAC addresses,
if he needs to. But he should never have to change *how* he specifies
those addresses.

So, as long as everyone can agree to the principle that a working DT
should remain working after a kernel upgrade, then I'll shut up. In
actual fact, this is not the case today, nor was it ever so in the
past, AFAICT, but it never hurts to set goals.

Thanks,
Richard
