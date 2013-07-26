Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab3GZEyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 00:54:51 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:39649 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3GZEys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 00:54:48 -0400
Date: Fri, 26 Jul 2013 06:54:33 +0200
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
Message-ID: <20130726045433.GB4100@netboy>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725213753.GC17616@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 03:37:53PM -0600, Jason Gunthorpe wrote:

> We use DT has a kernel configuration input. Our environment is
> designed to guarantee 100% that the kernel and DT match exactly. DT
> very deliberately isn't an ABI boundary in our systems.

It is nice that you use DT in that way, but that is not how DT is
supposed to work. If you must keep your DT in sync with the kernel,
then there is no advantage over the old platfrom device method. At
least that had the virtue of being a C language interface (ABI), and
some mistakes were be caught by the compiler.

> We've been doing this for years and have a proven in the field track
> record of upgrades from pre-2.6.16 to 3.7 and beyond with multiple
> SOCs. The same bootloader that was shipped to support non-DT 2.6.16
> boots DT 3.7 just fine.

Try that with Freescale PowerPCs.  Good luck.

Heck, even Paul's OMAP test reports have been spoiled by his not
deleting old dtb files. Of course, that is his fault (and not DT's, no
never).
 
> For closed system embedded DT has proven *WONDERFUL*.

I too work on commercial embedded systems, and DT has proven to be
one gigantic *PITA*.

Thanks,
Richard


