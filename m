Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab3ISLRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 07:17:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40300 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab3ISLRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 07:17:21 -0400
Date: Thu, 19 Sep 2013 13:17:19 +0200
From: Pavel Machek <pavel@denx.de>
To: Michal Simek <monstr@monstr.eu>
Cc: Alan Tull <atull@altera.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
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
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
Message-ID: <20130919111719.GA26246@amd.pavel.ucw.cz>
References: <cover.1379519753.git.michal.simek@xilinx.com>
 <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
 <20130918191517.GQ19937@titan.lakedaemon.net>
 <20130918203247.GA11181@obsidianresearch.com>
 <1379539063.31417.23.camel@atx-linux-37>
 <523AD814.1060406@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523AD814.1060406@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > This code also creates a set of files under /sys for each separate fpga.
> > I.e. checking status by looking at /sys/class/fpga/fpag0/status.  It
> > would be pretty small changes to control reseting the fpga by adding a
> > 'reset' file there also (added first to the framework, and an interface
> > into the low level fpga manager driver).
> 
> Status is just there and for my zynq devcfg driver I do export some status
> bits.
> 
> root@petalinux:~# cat /sys/class/fpga/fpga0/status
> partial_bitstream_status: 0
> prog_done_status: 1
> dbg_lock_status: 0
> seu_lock_status: 0
> aes_en_lock_status: 0
> aes_status: 0
> seu_status: 0
> spniden_status: 1
> spiden_status: 1
> niden_status: 1
> dbgen_status: 1
> dap_en_status: 7

This is single file? If so, it needs to be changed. Greg is rather
clear about that.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
