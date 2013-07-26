Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab3GZEnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 00:43:20 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:57769 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3GZEnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 00:43:18 -0400
Date: Fri, 26 Jul 2013 06:43:03 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
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
Message-ID: <20130726044303.GA4100@netboy>
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
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 11:53:49AM -0700, Stephen Warren wrote:
> On 07/25/2013 11:48 AM, Richard Cochran wrote:
> > On Thu, Jul 25, 2013 at 07:29:20PM +0100, Mark Rutland wrote:
> >>
> >> As long as we can make sufficiently clear that trying to use an unstable
> >> binding is going to be *very* painful, and not necessarily supported.

IOW, its okay to break DT setups with every release, as long as we
tell people first.

Well, at least you are being honest about it now.

> That's exactly why we're starting to think about which bindings should
> be considered stable and immutable, and when that should happen. As Olof
> pointed out, we haven't fully enforced that yet. Preferably bindings
> will be marked stable very fast, but mistakes are always going to happen
> in early development. ABIs are very hard.

They are even harder if you cannot decide what the ABI is in the first
place.

Thanks,
Richard
