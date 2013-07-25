Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab3GYVlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 17:41:39 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:33120 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab3GYVlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:41:35 -0400
Date: Thu, 25 Jul 2013 23:41:39 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: DT bindings as ABI [was: Do we have people interested in device
 tree janitoring / cleanup?]
Message-ID: <20130725214139.GA22296@glitch>
Mail-Followup-To: Stephen Warren <swarren@wwwdotorg.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Olof Johansson <olof@lixom.net>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"ksummit-2013-discuss@lists.linuxfoundation.org" <ksummit-2013-discuss@lists.linuxfoundation.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Dave P Martin <Dave.Martin@arm.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Ian Campbell <ian.campbell@citrix.com>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <51F1743D.7050007@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F1743D.7050007@wwwdotorg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 11:53:49AM -0700, Stephen Warren wrote:
> On 07/25/2013 11:48 AM, Richard Cochran wrote:
> > On Thu, Jul 25, 2013 at 07:29:20PM +0100, Mark Rutland wrote:
> >> On Thu, Jul 25, 2013 at 07:05:48PM +0100, Stephen Warren wrote:
> >>>
> >>> I don't think having people "rely" on the bindings is the issue so much
> >>> as the awareness that if they do, there will be compatibility issues for
> >>> unstable bindings.
> >>
> >> As long as we can make sufficiently clear that trying to use an unstable
> >> binding is going to be *very* painful, and not necessarily supported.
> > 
> > Oh, man.
> > 
> > The introduction of DT into ARM Linux was supposed to make everyone's
> > life sooo much easier. Of course, based on experience with powerpc, I
> > never believed it*, but still I would expect to hear that the DT
> > bindings are, well, a *binding* contract between the board developer,
> > boot loader, and the kernel.
> > 
> > Once it is working with a particular kernel, a DT board description
> > file should continue to work indefinitely with newer kernels. Anything
> > less is a regression, pure and simple.
> > 
> > If you go around changing the bindings willy nilly, then what is point
> > of having DT at all?
> 
> That's exactly why we're starting to think about which bindings should
> be considered stable and immutable, and when that should happen. As Olof
> pointed out, we haven't fully enforced that yet. Preferably bindings
> will be marked stable very fast, but mistakes are always going to happen
> in early development. ABIs are very hard.

If it was possible to clearly distinguish stable and unstable bindings,
then the kernel could allow unstable bindings only from appended DTBs.

This would prevent unwanted DT ABIs while leaving plenty of room for
the developers.

2c
