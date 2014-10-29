Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbaJ2IZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:25:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59272 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbaJ2IZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:25:46 -0400
Date: Wed, 29 Oct 2014 09:25:44 +0100
From: Pavel Machek <pavel@denx.de>
To: atull <atull@opensource.altera.com>
Cc: jgunthorpe@obsidianresearch.com, hpa@zytor.com, monstr@monstr.eu,
        michal.simek@xilinx.com, rdunlap@infradead.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, pantelis.antoniou@konsulko.com,
        robh+dt@kernel.org, grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, broonie@kernel.org, philip@balister.org,
        rubini@gnudd.com, s.trumtrar@pengutronix.de, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, mgerlach@opensource.altera.com,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH v2 1/3] add sysfs document for fpga bridges
Message-ID: <20141029082544.GB22891@amd>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com>
 <1414108267-22058-2-git-send-email-atull@opensource.altera.com>
 <20141024105420.GB20775@amd>
 <alpine.DEB.2.02.1410241009010.23446@atx-linux-37>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1410241009010.23446@atx-linux-37>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-10-24 10:11:26, atull wrote:
> On Fri, 24 Oct 2014, Pavel Machek wrote:
> 
> > On Thu 2014-10-23 18:51:05, atull@opensource.altera.com wrote:
> > > From: Alan Tull <atull@opensource.altera.com>
> > > 
> > > Add sysfs document for fpga bridges.
> > > 
> > > --- /dev/null
> > > +++ b/Documentation/ABI/testing/sysfs-class-fpga-bridge
> > > @@ -0,0 +1,5 @@
> > > +What:		/sys/class/fpga-bridge/<bridge>/enable
> > > +Date:		October 2014
> > > +KernelVersion:	3.18
> > > +Contact:	Alan Tull <atull@opensource.altera.com>
> > > +Description:	Enable bridge.  Write 1 to bring bridge out of reset.
> > 
> > Specify, what happens when 0 is written there?
> 
> Yes, I will add:  'Write 0 has no effect.'

Definitely add it, then. The way it is written, I'd expect 0 to put
bridge into reset.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
