Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab3GaTM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 15:12:28 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:50766 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab3GaTM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 15:12:26 -0400
Date: Wed, 31 Jul 2013 21:12:09 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: mbizon@freebox.fr, Mark Rutland <mark.rutland@arm.com>,
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
        Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        Arend van Spriel <arend@broadcom.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130731191209.GA8027@netboy>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <1479410.BSGDrOcRvP@thinkpad>
 <20130731150717.GD4904@netboy>
 <1999586.84BnWE5EUh@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1999586.84BnWE5EUh@thinkpad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 05:23:35PM +0200, Tomasz Figa wrote:
> 
> I said it many, many times, that a) and b) I proposed are just two extremes. 
> It is unlikely that an extreme solution will be the best option to choose. I 
> am strongly for something in the middle, just like I wrote in several of my 
> previous replies.
> 
> This is something that should be commented, not those extreme options.

We are saying that pursuing a) is useless because it adds pain and
complexity without adding benefit. I simply don't buy your argument
that DT makes a better platform data, but that is besides the point.

I had said, think about the users.  You said, what users?  I wrote a
clear and concise use case.  You said, lets think about a) and b) and
all the shades of gray in between.

In order to support the use case, you will have to provide a stable
ABI. You can't have a compromise solution. At the end of the day,
either you have a stable ABI, or you don't.

It was apparent to me that the arm/dt thing has been meandering around
since its inception, but what was surprising is that people were doing
this on purpose, and now they are defending this. Why can't we get a
firm commitment on having a stable ABI?

Thanks,
Richard


