Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138Ab3G0IxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 04:53:22 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:50506 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab3G0IxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 04:53:17 -0400
Date: Sat, 27 Jul 2013 10:53:01 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: DT bindings as ABI [was: Do we have people interested in device
 tree janitoring / cleanup?]
Message-ID: <20130727085259.GA6207@netboy>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726045433.GB4100@netboy>
 <20130726171524.GB28895@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726171524.GB28895@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 11:15:24AM -0600, Jason Gunthorpe wrote:
> On Fri, Jul 26, 2013 at 06:54:33AM +0200, Richard Cochran wrote:
> > I too work on commercial embedded systems, and DT has proven to be
> > one gigantic *PITA*.
> 
> Why do you think our experiences are so different?

Here are a few recent examples:

* What happens when one wants to boot vanilla kernel on the beaglebone?

  http://www.spinics.net/lists/arm-kernel/msg198431.html

* Wanting already merged code to work is too much to ask.

  http://www.spinics.net/lists/linux-omap/msg79731.html

* When people try in good faith to conduct methodical boot tests,
  DT is working against them.

  http://www.spinics.net/lists/linux-omap/msg79960.html

Thanks,
Richard
