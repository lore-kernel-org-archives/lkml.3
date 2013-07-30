Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab3G3AmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 20:42:24 -0400
Received: from mail.lang.hm ([64.81.33.126]:51782 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab3G3AmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 20:42:21 -0400
Date: Mon, 29 Jul 2013 17:41:11 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Jason Cooper <jason@lakedaemon.net>
cc: Dave Martin <Dave.Martin@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Subject: Re: [Ksummit-2013-discuss] Defining schemas for Device Tree
In-Reply-To: <20130729172339.GT29916@titan.lakedaemon.net>
Message-ID: <alpine.DEB.2.02.1307291739150.13736@nftneq.ynat.uz>
References: <2469263.vMN09Q7Tzi@flatron> <20130729150124.GS29916@titan.lakedaemon.net> <20130729164905.GB2280@localhost.localdomain> <20130729172339.GT29916@titan.lakedaemon.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jul 2013, Jason Cooper wrote:

> 
>>
>> I don't think that siblings have any defined order in DT.  If reading a
>> device tree, there's no guarantee you get nodes or properties out in the
>> same order as the original .dts file.
>
> That's why I raised the point.  If people think encoding initialization
> order in the DT is a good idea, then we should change the dtc so it
> compiles/decompiles in the same order.

if you make the initializaiton order 'magicly' correct by following the order of 
the flat representation, how do you reflect the case where initialization can be 
overlapped for different devices?

you are just trading one side of the problem for the other.

David Lang
