Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaL2SDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 13:03:05 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:51597 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaL2SDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 13:03:02 -0500
Date: Mon, 29 Dec 2014 20:02:52 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Nishanth Menon <nm@ti.com>, linux-omap <linux-omap@vger.kernel.org>,
        sre@debian.org, Tony Lindgren <tony@atomide.com>, sre@ring0.de,
        ivo.g.dimitrov.75@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: v3.19-rc1 regression(?) on N900
Message-ID: <20141229180252.GE582@fuloong-minipc.musicnaut.iki.fi>
References: <549B44E2.6080202@ti.com>
 <201412250932.40403@pali>
 <20141225091121.GA20355@amd>
 <20141225222122.GB582@fuloong-minipc.musicnaut.iki.fi>
 <54A10B1E.7030800@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A10B1E.7030800@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 29, 2014 at 10:04:46AM +0200, Tomi Valkeinen wrote:
> On 26/12/14 00:21, Aaro Koskinen wrote:
> 
> > ...however, I can confirm that framebuffer is broken:
> > 
> > [    8.230743] omapfb omapfb: no displays
> > [    8.255584] omapfb omapfb: failed to setup omapfb
> > [    8.260620] platform omapfb: Driver omapfb requests probe deferral
> > [    8.284118] of_get_named_gpiod_flags: parsed 'reset-gpios' property of node
> > '/ocp/spi@48098000/acx565akm@2[0]' - status (0)
> > [    8.284271] acx565akm spi1.2: failed to find video source
> > [    8.290069] spi spi1.2: Driver acx565akm requests probe deferral
> > 
> > I bisected it to ef691ff48bc8 (OMAPDSS: DT: Get source endpoint
> > by matching reg-id). When I revert that, also FB works with 3.19-rc1.
> 
> I've attached a patch for this. Only hack-tested on OMAP3 beagle, so
> please report if it works.

That works, thanks.

A.
