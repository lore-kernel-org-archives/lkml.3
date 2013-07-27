Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab3G0FE0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 01:04:26 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:33651 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3G0FEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 01:04:23 -0400
Date: Sat, 27 Jul 2013 07:04:08 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
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
Message-ID: <20130727050406.GB4221@netboy>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726080115.GA5436@netboy>
 <1374831744.2923.42.camel@shinybook.infradead.org>
 <20130726130927.GC4219@netboy>
 <20130726141016.GF9858@sirena.org.uk>
 <CAOesGMhEr3DiFm5uSgoHPFUMY4jWu4HkeTU2UmOGj=dS75Vk+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMhEr3DiFm5uSgoHPFUMY4jWu4HkeTU2UmOGj=dS75Vk+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 08:49:43AM -0700, Olof Johansson wrote:
> 
> Long term, final goal is likely to be close to what Russell is saying

Why is this a long term goal? Start today.

> -- nothing should go into the kernel tree unless the binding is in a
> fully stable state. However, we have a transitional period between now
> and then, and even when we're at the final state there will be need to
> have some sort of sandbox for development and test of future bindings.

Why not just set up a git tree right away?

> Dealing with all that, as well as the actual process for locking in
> bindings, is what needs to be sorted out.
> 
> I think we're all in agreement that bindings that change over time are
> nothing but pain, but we're arguing that in circles anyway.

No.

I keep saying, the bindings must be stable ABI, *today*.

You keep saying, maybe later, but until then we will make things up as
we go along.

Thanks,
Richard
