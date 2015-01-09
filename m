Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbbAIU4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:56:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33590 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbbAIU4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:56:47 -0500
Date: Fri, 9 Jan 2015 21:56:44 +0100
From: Pavel Machek <pavel@denx.de>
To: atull <atull@opensource.altera.com>
Cc: gregkh@linuxfoundation.org, jgunthorpe@obsidianresearch.com, hpa@zytor.com,
        monstr@monstr.eu, michal.simek@xilinx.com, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        pantelis.antoniou@konsulko.com, robh+dt@kernel.org,
        grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, broonie@kernel.org, philip@balister.org,
        rubini@gnudd.com, s.trumtrar@pengutronix.de, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devel@driverdev.osuosl.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
Message-ID: <20150109205643.GA5761@amd>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
 <1420575219-27061-3-git-send-email-atull@opensource.altera.com>
 <20150107084819.GA1887@amd>
 <alpine.DEB.2.02.1501091302370.30067@linuxheads99>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1501091302370.30067@linuxheads99>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2015-01-09 13:14:24, atull wrote:
> On Wed, 7 Jan 2015, Pavel Machek wrote:
> 
> > On Tue 2015-01-06 14:13:37, atull@opensource.altera.com wrote:
> > > +
> > > +What:		/sys/class/fpga_manager/<fpga>/firmware
> > > +Date:		October 2014
> > > +KernelVersion:	3.18
> > > +Contact:	Alan Tull <atull@opensource.altera.com>
> > > +Description:	Name of the FPGA image file to load using firmware
> > > class.
> > 
> > This one is ugly: it unneccessarily passes firmware name through the
> > kernel. Just make interface and code simpler by always passing
> > "socfpga-fpga-image" or something like that.
> > 
> > Thanks,
> > 									Pavel
> 
> Hi Pavel,
> 
> It might be ugly.  It's not unnecessary.  Some uses of FPGAs involve
> switching out the FPGA images dynamically under control of the userspace.

Then configure udev to load right firmware for you, or ln -s
image-i-want-now socfpga-fpga-image to select the one to read...?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
