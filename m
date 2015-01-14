Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbbANQA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:00:56 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:44776 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbbANQAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:00:54 -0500
Date: Wed, 14 Jan 2015 15:58:15 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Pavel Machek <pavel@denx.de>, atull <atull@opensource.altera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, hpa@zytor.com,
        Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>, rdunlap@infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        Grant Likely <grant.likely@linaro.org>, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        philip@balister.org, rubini@gnudd.com,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, Felipe Balbi <balbi@ti.com>,
        m.chehab@samsung.com, davidb@codeaurora.org,
        Rob Landley <rob@landley.net>, davem@davemloft.net, cesarb@cesarb.net,
        sameo@linux.intel.com, akpm@linux-foundation.org,
        Linus Walleij <linus.walleij@linaro.org>, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devel@driverdev.osuosl.org,
        Alan Tull <delicious.quinoa@gmail.com>, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
Message-ID: <20150114155815.41e0680b@lxorguk.ukuu.org.uk>
In-Reply-To: <027665D5-EB1F-47D1-B727-FE236C009FA7@konsulko.com>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
	<1420575219-27061-3-git-send-email-atull@opensource.altera.com>
	<20150107084819.GA1887@amd>
	<alpine.DEB.2.02.1501091302370.30067@linuxheads99>
	<20150109205643.GA5761@amd>
	<20150112210134.687176ed@lxorguk.ukuu.org.uk>
	<20150112214314.GA18610@obsidianresearch.com>
	<20150113162847.2778b5a5@lxorguk.ukuu.org.uk>
	<027665D5-EB1F-47D1-B727-FE236C009FA7@konsulko.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Those people have failed to show up and provide input and/or code.

That doesn't excuse failing to design the code properly.

> 
> >> It is one thing to context switch a maths algorithm that is built to
> >> be stateless, it is quite another to context switch between, say an
> >> ethernet core with an operating Linux Net driver doing DMA and a maths
> >> algorithm.
> > 
> > And people already do it with thins like maths algorithms.
> > 
> 
> Again those people have failed to show up and provide input and/or code.

Actually there is a whole academic world out there, lots of papers and
research OS code including Linux based bits. 

> We have a lot of well known use cases that this patchset addresses
> satisfactorily. The possible users of the cases you point out are 
> welcome to provide input and working code to address their needs.

So you want to shove crap in the kernel with a broken ABI someone (no
doubt not you) will have to keep maintained forever ?
 
> At this point in time, no-one has showed up; is there a reason for
> this needed capability to be delayed in order to address something
> that no-one has expressed interest for?

I'm not suggesting it's delayed - I'm suggesting its designed properly in
the first place.

We know the kind of use cases that are coming. Designing in complete
ignorance of them is just stupidity.

Atul wants to put something in staging, and grow it from there. That's
not delaying it, but trying to get it done right.

Alan
