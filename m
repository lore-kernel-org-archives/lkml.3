Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbbAOVxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:53:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51229 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbAOVxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:53:04 -0500
Date: Thu, 15 Jan 2015 22:52:59 +0100
From: Pavel Machek <pavel@denx.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        atull <atull@opensource.altera.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
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
Message-ID: <20150115215259.GA31850@amd>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
 <1420575219-27061-3-git-send-email-atull@opensource.altera.com>
 <20150107084819.GA1887@amd>
 <alpine.DEB.2.02.1501091302370.30067@linuxheads99>
 <20150109205643.GA5761@amd>
 <4D4EA2D5-68DD-49F7-9E2D-3A0A8F6AF9CA@konsulko.com>
 <20150110151118.GA16036@amd>
 <alpine.DEB.2.10.1501111009180.2556@shineypoop>
 <20150112180608.GA11295@obsidianresearch.com>
 <20150113162133.2a4d1116@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113162133.2a4d1116@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2015-01-13 16:21:33, One Thousand Gnomes wrote:
> On Mon, 12 Jan 2015 11:06:08 -0700
> Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> 
> > On Sun, Jan 11, 2015 at 10:29:00AM -0600, atull wrote:
> > > the FPGA image.  If someone wants there to be only one FPGA image on
> > > the FGPA forever, they will probably not be using this framework; their
> > > FPGA will probably be loaded before Linux boots up.
> > 
> > Nonsense, loading the FPGA through Linux is much better
> 
> You need both. There are platforms where the FPGA must be loaded to even
> boot the OS (for example Linux running an FPGA soft 486 can't run until
> the FPGA has the CPU loaded into it.

Well, but then the thing that programs FPGA is not Linux, so this is
little off-topic here. [But yes, there are systems where you want to
program FPGA from bootloader, because it is easier that way, or maybe
because it provides your video card.]

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
