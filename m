Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3G2Sk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:40:58 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:41013 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab3G2Sk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:40:56 -0400
Date: Mon, 29 Jul 2013 12:40:48 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: DT bindings as ABI [was: Do we have people interested in device
 tree janitoring / cleanup?]
Message-ID: <20130729184048.GE15861@obsidianresearch.com>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726045433.GB4100@netboy>
 <20130726171524.GB28895@obsidianresearch.com>
 <20130727084825.GA4707@netboy>
 <20130729175400.GB15861@obsidianresearch.com>
 <20130729181607.GM24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729181607.GM24642@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.195
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 07:16:07PM +0100, Russell King - ARM Linux wrote:

> What does it take?  Good practice, care, thought and planning.  All
> the qualities which should already be present for kernel _engineers_.
> Not an "lets create something for me, I don't care about anyone else"
> attitude.

I agree with what you've written, but we are looking at this from
different ends of the problem.

I fully agree you can create a main line kernel GIT tree that has a
stable DT ABI.

However, I as an ODM, with time pressure, cannot wait for the kernel
folks to finish this work. So from my perspective the DT will not be
stable, as I will put whatever interm stuff I choose to have a
shippable product.

Thus I have to design my systems for an unstable DT, and the message
from the kernel community to people in my posistion should be:

  When you ship early with non-mainlined DT schema, design your boot
  system around an unstable DT. Plan to migrate your DT to upstream
  once it becomes finalized.

Here is the rub: Once I design for an unstable DT I simply don't
derive value from the kernel communities work to create a stable DT.

So who is getting the benefit of this work, and is it worth the cost?

Jason
