Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaETOD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:03:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60752 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753681AbaETODa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:03:30 -0400
Date: Tue, 20 May 2014 16:03:25 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, linux-ide@vger.kernel.org,
        alexandre.belloni@free-electrons.com, jszhang@marvell.com,
        tj@kernel.org, linux-arm-kernel@lists.infradead.org,
        sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH v4 1/7] phy: add a driver for the Berlin SATA PHY
Message-ID: <20140520140325.GA21579@kwain>
References: <1400576675-25265-1-git-send-email-antoine.tenart@free-electrons.com>
 <1400576675-25265-2-git-send-email-antoine.tenart@free-electrons.com>
 <1821771.zFvTDGF2Ae@amdc1032>
 <20140520134942.GC9873@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140520134942.GC9873@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 03:49:42PM +0200, Andrew Lunn wrote:
> On Tue, May 20, 2014 at 02:34:20PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Tuesday, May 20, 2014 11:04:29 AM Antoine Ténart wrote:
> > > 
> > > diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> > > index 4906c27fa3bd..b31b1986fda4 100644
> > > --- a/drivers/phy/Kconfig
> > > +++ b/drivers/phy/Kconfig
> > > @@ -15,6 +15,11 @@ config GENERIC_PHY
> > >  	  phy users can obtain reference to the PHY. All the users of this
> > >  	  framework should select this config.
> > >  
> > > +config PHY_BERLIN_SATA
> > > +	bool
> > 
> > Is there any real reason why this cannot be tristate?
> 
> What we have seen with SATA drivers and phys, is there is link time
> breakage if the SATA driver is built in and the phy is modular.
> 
> Maybe this has been fixed now? 

Using tristate shouldn't be a problem. I compiled without the PHY
driver, no link issue.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
