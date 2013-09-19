Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3ISPSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 11:18:06 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36394 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3ISPSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 11:18:04 -0400
MIME-Version: 1.0
In-Reply-To: <523AD814.1060406@monstr.eu>
References: <cover.1379519753.git.michal.simek@xilinx.com>
	<cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
	<20130918191517.GQ19937@titan.lakedaemon.net>
	<20130918203247.GA11181@obsidianresearch.com>
	<1379539063.31417.23.camel@atx-linux-37>
	<523AD814.1060406@monstr.eu>
Date: Thu, 19 Sep 2013 10:18:03 -0500
Message-ID: <CADuitaCjNv2HFCg_y2qpkvXmUmO-jKUVQ2Ra8ACOne1hwAmKJA@mail.gmail.com>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
From: Yves Vandervennet <rocket.yvanderv@gmail.com>
To: monstr@monstr.eu
Cc: Alan Tull <atull@altera.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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

On Thu, Sep 19, 2013 at 5:55 AM, Michal Simek <monstr@monstr.eu> wrote:

>> Is there some way a per-device userspace helper can be added that can
>> handle adding the headers?  Such that different fpga types get different
>> helpers?
>
> What do you exactly mean by that? Any example what do you want to achieve?
Bit streams may not be in raw format, so using 'cat' is not possible.
Xilinx and Altera have their own bit stream "richer" format, that need
to be processed before they are presented to the driver(s). So, a
hotplug helper per manufacturer/FPGA is required. Assuming 'cat' will
be used is too limiting.
Does it make sense to you?

Thanks
Yves
Altera Corp.
