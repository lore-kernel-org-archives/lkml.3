Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab3G2SjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:39:17 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:44493 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab3G2SjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:39:12 -0400
Date: Mon, 29 Jul 2013 20:38:52 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Arend van Spriel <arend@broadcom.com>,
        Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
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
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130729183851.GB4209@netboy>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <1441731.8CGUI1tUxh@flatron>
 <20130728085650.GA4683@netboy>
 <1416484.XDfk5G56BI@flatron>
 <20130728131901.GA8864@netboy>
 <20130729073123.GB1441@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729073123.GB1441@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 09:31:23AM +0200, Maxime Ripard wrote:
> 
> I'm afraid this kind of use case will never be properly supported, DT
> stable ABI or not.
> 
> Think about this: what kernel will actually be shipped in that board?
> Most likely, it will be a BSP kernel from the vendor. Does the vendor
> will have made that commitment to have a stable ABI for the DT? Will it
> use the same bindings than mainline? Do we want to support all the crazy
> bindings every vendor will come up with?
> 
> I'm afraid the answer to these three questions will most of the time be
> "no.".

Yes, I know, and it is sad but true.
 
We can't stop the vendors from shipping half-baked BSPs. I really
don't mind that they do that. After all, they want to get *something*
working when they launch their chips.

> That doesn't mean we shouldn't aim for *mainline* having a stable DT
> ABI, but that kind of use case doesn't seem very realistic to me.

Right, we can and should do better. I got the beaglebone Ethernet
working in mainline (not by writing the driver, but by complaining
over and over again). I except that it will continue to work and not
fall victim to some random DT change.

Thanks,
Richard




