Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab3JDQ05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:26:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab3JDQ0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:26:55 -0400
Date: Fri, 4 Oct 2013 09:26:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Joe Perches <joe@perches.com>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, Alan Tull <atull@altera.com>,
        Pavel Machek <pavel@ucw.cz>, Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        David Brown <davidb@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2] fpga: Introduce new fpga subsystem
Message-ID: <20131004162654.GA16666@kroah.com>
References: <cover.1380727889.git.michal.simek@xilinx.com>
 <fe4f34387011339efe9f5868a7eec9d549462d8f.1380727889.git.michal.simek@xilinx.com>
 <1380729996.2081.59.camel@joe-AO722>
 <524EE9A0.2020404@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524EE9A0.2020404@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 06:15:28PM +0200, Michal Simek wrote:
> > Probably all of the "return ret ?: count;" uses
> > would be more easily understood on 3 lines.
> 
> This structure is also quite common in the kernel
> git grep "? :"  | wc -l
> 415
> 
> git grep "?:"  | wc -l
> 541

And it should all be removed and fixed up properly to make it easier to
read and understand.  Please don't add new instances of it, I sure will
not take it.

greg k-h
