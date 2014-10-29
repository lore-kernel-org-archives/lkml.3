Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbaJ2IYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:24:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59208 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbaJ2IYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:24:43 -0400
Date: Wed, 29 Oct 2014 09:24:40 +0100
From: Pavel Machek <pavel@denx.de>
To: atull <atull@opensource.altera.com>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        jgunthorpe@obsidianresearch.com, hpa@zytor.com, monstr@monstr.eu,
        michal.simek@xilinx.com, rdunlap@infradead.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, pantelis.antoniou@konsulko.com,
        robh+dt@kernel.org, grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, broonie@kernel.org, philip@balister.org,
        rubini@gnudd.com, jason@lakedaemon.net, kyle.teske@ni.com,
        nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, mgerlach@opensource.altera.com,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH v2 2/3] ARM: dts: socfpga: fpga bridges bindings docs
Message-ID: <20141029082440.GA22891@amd>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com>
 <1414108267-22058-3-git-send-email-atull@opensource.altera.com>
 <20141024070042.GL10262@pengutronix.de>
 <alpine.DEB.2.02.1410281601570.11910@atx-linux-37>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1410281601570.11910@atx-linux-37>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > +Optional properties:
> > > + - label          : name that you want this bridge to show up as under
> > > +                    /sys/class/fpga-bridge.  Default is br<device#> if this is
> > > +                    not specified.
> > > +
> > 
> > Why? Linux-specific.
> 
> That was a convience for the user.  I can take that out and won't
> miss it.

Actually make it

- label : optional user-readable name for this bridge

...and it is no longer Linux-specific, and you can keep it if it is
otherwise useful...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
