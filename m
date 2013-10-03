Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab3JCGtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:49:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48538 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab3JCGtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:49:18 -0400
Date: Thu, 3 Oct 2013 08:49:15 +0200
From: Pavel Machek <pavel@denx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu, Alan Tull <atull@altera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
Message-ID: <20131003064915.GB17155@amd.pavel.ucw.cz>
References: <cover.1380727889.git.michal.simek@xilinx.com>
 <524C6D64.8080801@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524C6D64.8080801@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-10-02 12:00:52, H. Peter Anvin wrote:
> On 10/02/2013 08:35 AM, Michal Simek wrote:
> > 
> > Based on my discussion at ELC with Greg KH the new driver should
> > support firmware interface for loading bitstream.
> > 
> 
> As I have previously stated, I think this is a mistake simply because
> the firmware interface is a bad mapping on requirements for an FPGA,
> especially once you account for the vast number of ways an FPGA can
> get loaded and you take partial reconfiguration into account.  I
> happen to be at a face to face meeting with Greg today, so I'll pick
> his brain a bit.

Umm. Could the discussion be kept on line?

Yes, more than one bitstream makes sense for fpga, but more than one
firmware makes sense for most other devices, too... 

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
