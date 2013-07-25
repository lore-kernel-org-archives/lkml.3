Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab3GYSsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:48:54 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:39777 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab3GYSsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:48:52 -0400
Date: Thu, 25 Jul 2013 20:48:34 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Olof Johansson <olof@lixom.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: DT bindings as ABI [was: Do we have people interested in device
 tree janitoring / cleanup?]
Message-ID: <20130725184834.GA8296@netboy>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 07:29:20PM +0100, Mark Rutland wrote:
> On Thu, Jul 25, 2013 at 07:05:48PM +0100, Stephen Warren wrote:
> > 
> > I don't think having people "rely" on the bindings is the issue so much
> > as the awareness that if they do, there will be compatibility issues for
> > unstable bindings.
> 
> As long as we can make sufficiently clear that trying to use an unstable
> binding is going to be *very* painful, and not necessarily supported.

Oh, man.

The introduction of DT into ARM Linux was supposed to make everyone's
life sooo much easier. Of course, based on experience with powerpc, I
never believed it*, but still I would expect to hear that the DT
bindings are, well, a *binding* contract between the board developer,
boot loader, and the kernel.

Once it is working with a particular kernel, a DT board description
file should continue to work indefinitely with newer kernels. Anything
less is a regression, pure and simple.

If you go around changing the bindings willy nilly, then what is point
of having DT at all?

Thanks,
Richard

* http://lists.infradead.org/pipermail/linux-arm-kernel/2011-April/046963.html
  http://lists.infradead.org/pipermail/linux-arm-kernel/2011-May/050255.html
  http://lists.infradead.org/pipermail/linux-arm-kernel/2011-May/050256.html
  http://lists.infradead.org/pipermail/linux-arm-kernel/2011-May/050264.html
