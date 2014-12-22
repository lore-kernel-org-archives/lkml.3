Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaLVTQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:16:23 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:49620 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbaLVTQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:16:22 -0500
Date: Mon, 22 Dec 2014 20:14:35 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Simon Guinot <simon.guinot@sequanux.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Lior Amsalem <alior@marvell.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Ryan Press <ryan@presslab.us>, Nadav Haklai <nadavh@marvell.com>,
        Greg Ungerer <gerg@uclinux.org>, Benoit Masson <yahoo@perenite.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "klightspeed @ killerwolves . net" <klightspeed@killerwolves.net>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Florian Fainelli <florian@openwrt.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Simon Baatz <gmbnomis@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 00/27] ARM: mvebu: armada-*: Relicense the device tree
 under GPLv2+/X11
Message-ID: <20141222191435.GI32716@lunn.ch>
References: <20141218191528.GY967@titan.lakedaemon.net>
 <549437DD.7040602@free-electrons.com>
 <20141219160230.GZ967@titan.lakedaemon.net>
 <54944DAC.1000709@free-electrons.com>
 <20141219170328.GA967@titan.lakedaemon.net>
 <54945C5C.2080801@free-electrons.com>
 <20141219174300.GB967@titan.lakedaemon.net>
 <20141219181616.GG19261@kw.sim.vm.gnt>
 <20141221235000.GC28117@titan.lakedaemon.net>
 <20141222112933.GK19261@kw.sim.vm.gnt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141222112933.GK19261@kw.sim.vm.gnt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > In the long term, we're attempting to provide one neutral place [1] for
> > the bootloaders and kernels to pull devicetrees from and contribute
> > changes back to.
> 
> OK, let's see if I understand correctly.
> 
> If I don't agree with the GPLv2+/x11 relicensing, then support for
> almost all the LaCie boards will be removed from the Linux kernel (maybe
> during the next merge window) ? Is that correct ?

I would NAK such a removal. 

	   Andrew
