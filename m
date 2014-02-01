Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417AbaBAVwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 16:52:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51563 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbaBAVv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 16:51:59 -0500
Date: Sat, 1 Feb 2014 22:51:40 +0100
From: Philipp Zabel <pza@pengutronix.de>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        arm@kernel.org, Rob Herring <robherring2@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCH v7 0/7] ARM: rockchip: add smp functionality
Message-ID: <20140201215140.GA1375@pengutronix.de>
References: <4970034.fqvMoHdOyd@phil>
 <13010296.nzTT2PqdSR@phil>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13010296.nzTT2PqdSR@phil>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:49:55 up 11 days, 10:18,  9 users,  load average: 0,06, 0,18,
 0,20
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: pza@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Fri, Jan 31, 2014 at 11:03:03PM +0100, Heiko Stübner wrote:
> On Monday, 20. January 2014 16:41:43 Heiko Stübner wrote:
> > This series enables the use of the additional cores on Rockchip
> > Cortex-A9 SoCs.
> 
> So, two weeks without any general complaints, but I guess part of the more 
> general patches could use an ack.
> 
> Going forward, what would be best way to merge them?
> As one pull request to arm-soc, or for example splitting them into the first 
> three patches going through the misc tree and the rockchip specific stuff going 
> through arm-soc? Or something else altogether?
> 
> 
> > Heiko Stuebner (7):
> >   of: add functions to count number of elements in a property
> 
> One of the intermediate versions of this patch got a
> 	Reviewed-by: Mark Rutland <mark.rutland@arm.com> .
> Mark, is this still true for this variant addressing some additional wished 
> from Rob?
> 
> And this final version got a "Looks good" from Rob Herring in the original 
> thread, but a more formal "ack" might be nice :-) .
> 
> 
> >   dt-bindings: sram: describe option to reserve parts of the memory
> >   misc: sram: implement mmio-sram-reserved option
> 
> Philipp, you acked an intermediate version, and this v7 now should also 
> contain the two separate loops (1st gathering data and 2nd creating the pool 
> parts) you asked for.
> 
> Could I persuade you to take a look again?

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
