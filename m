Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab3IYNzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:55:55 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52968 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab3IYNzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:55:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130924221802.GC3837@kroah.com>
References: <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
	<20130918191517.GQ19937@titan.lakedaemon.net>
	<20130918203247.GA11181@obsidianresearch.com>
	<1379539063.31417.23.camel@atx-linux-37>
	<20130919100833.GC19346@amd.pavel.ucw.cz>
	<523AD9C5.8060006@monstr.eu>
	<1379710523.21515.4.camel@atx-linux-37>
	<1380038126.13235.12.camel@atx-linux-37>
	<5241B6BC.1010301@monstr.eu>
	<1380039774.14129.6.camel@atx-linux-37>
	<20130924221802.GC3837@kroah.com>
Date: Wed, 25 Sep 2013 08:55:53 -0500
Message-ID: <CADuitaBT2xqPoSRUTU13GXsayJNHfPcM7ZoSLEy5Ai+W+htmRg@mail.gmail.com>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
From: Yves Vandervennet <rocket.yvanderv@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Tull <atull@altera.com>, Michal Simek <monstr@monstr.eu>,
        Pavel Machek <pavel@denx.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

>> The default hotplug-script doesn't do anything special (that the kernel
>> couldn't do by itself).  What's great is that it could call another
>> script that adds headers or does whatever other special un-gzipping or
>> other massaging that the firmware image needs before it gets loaded.
>
> Only if you need to do something "special" like this could it justify
> not using the in-kernel firmware loader.  Also note that I think future
> versions of udev will have the udev firmware loader removed entirely, so
> watch out for that.
If the bit stream is in raw format, the kernel can deal with it.
however, there are "richer" formats for the FPGA bit streams that need
to be parsed in order to extract the raw data that an FPGA accepts. In
this case, user space must be involved.

Regards
Yves

>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
