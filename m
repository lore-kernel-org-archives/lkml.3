Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaETOkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:40:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:32839 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753580AbaETOkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:40:08 -0400
Date: Tue, 20 May 2014 16:40:03 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, linux-ide@vger.kernel.org,
        alexandre.belloni@free-electrons.com, jszhang@marvell.com,
        tj@kernel.org, linux-arm-kernel@lists.infradead.org,
        sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH v4 1/7] phy: add a driver for the Berlin SATA PHY
Message-ID: <20140520144003.GD21579@kwain>
References: <1400576675-25265-1-git-send-email-antoine.tenart@free-electrons.com>
 <1400576675-25265-2-git-send-email-antoine.tenart@free-electrons.com>
 <1821771.zFvTDGF2Ae@amdc1032>
 <20140520134942.GC9873@lunn.ch>
 <20140520140325.GA21579@kwain>
 <20140520140631.GF9873@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140520140631.GF9873@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 04:06:31PM +0200, Andrew Lunn wrote:
> > > > > +config PHY_BERLIN_SATA
> > > > > +	bool
> > > > 
> > > > Is there any real reason why this cannot be tristate?
> > > 
> > > What we have seen with SATA drivers and phys, is there is link time
> > > breakage if the SATA driver is built in and the phy is modular.
> > > 
> > > Maybe this has been fixed now? 
> > 
> > Using tristate shouldn't be a problem. I compiled without the PHY
> > driver, no link issue.
> 
> The problem i think was when the PHY core and driver was a module and
> SATA built in. Please give that configuration a go.

I tested, it went fine.

This was actually fixed by:
b51fbf9fb0c3 phy-core: Don't allow building phy-core as a module

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
