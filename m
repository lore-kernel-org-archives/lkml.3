Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbaDGSDC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:03:02 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39993 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbaDGSDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:03:00 -0400
Date: Mon, 7 Apr 2014 20:02:28 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Michal Simek <monstr@monstr.eu>, Mike Looijmans <mike.looijmans@topic.nl>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH v2 2/5] ARM: zynq: dt: Convert to preprocessor includes
Message-ID: <20140407180228.GN12170@pengutronix.de>
References: <1396653256-28397-1-git-send-email-soren.brinkmann@xilinx.com>
 <1396653256-28397-3-git-send-email-soren.brinkmann@xilinx.com>
 <53423E75.3020008@monstr.eu>
 <53429754.8080105@topic.nl>
 <534298E7.2020409@monstr.eu>
 <20140407171012.GC9952@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407171012.GC9952@obsidianresearch.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:58:11 up 226 days,  3:29, 43 users,  load average: 0,05, 0,07,
 0,12
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, Apr 07, 2014 at 11:10:12AM -0600, Jason Gunthorpe wrote:
> On Mon, Apr 07, 2014 at 02:24:07PM +0200, Michal Simek wrote:
> 
> > Device-tree BSP and in 2014.01 there will be new BSP which just
> > generate them directly from the Vivado tools which just target your
> > reference design.  You can connect your custom IP (or Xilinx or 3rd
> > party) directly to the GIC which using different IRQ sensitivity
> > with whatever register addresses and make no sense to write it by
> > hand.
> 
> On our Zynq design here we ended up being unwilling to use platform
> generation from Vivado. Basically all our IP was custom, so there was
> no win at all to invoking the complexity of the automatic tools.
> 
> Thus we write the DT by hand, and our DT is complex, integrating
> peripherals that span two FPGAs.
> 
> I think the in-kernel DT should use the kernel conventions, which
> means using #include and the binding constants over magic values.
> 

ACK.

If in doubt follow common mainline practice. Although using includes
for DT is not necessarily common practice, readability of DTs is
really important IMHO.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
