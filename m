Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568Ab3CGWSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:18:35 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53043 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759041Ab3CGWSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:18:33 -0500
Date: Fri, 8 Mar 2013 00:18:27 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ADP1653 board code for Nokia RX-51
Message-ID: <20130307221827.GE31984@valkosipuli.retiisi.org.uk>
References: <201302171616.50152@pali>
 <20130217190303.GC2317@blackmetal.musicnaut.iki.fi>
 <201303062112.06417@pali>
 <201303062120.17303@pali>
 <20130306214440.GA11874@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130306214440.GA11874@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

On Wed, Mar 06, 2013 at 10:44:41PM +0100, Sebastian Reichel wrote:
> On Wed, Mar 06, 2013 at 09:20:16PM +0100, Pali Rohár wrote:
> > On Wednesday 06 March 2013 21:12:06 Pali Rohár wrote:
> > > On Sunday 17 February 2013 20:03:03 Aaro Koskinen wrote:
> > > > On Sun, Feb 17, 2013 at 04:16:49PM +0100, Pali Rohár wrote:
> > > > > +/*
> > > > > + * arch/arm/mach-omap2/board-rx51-camera.c
> > > > > + *
> > > > > + * Copyright (C) 2008 Nokia Corporation
> > > > > + *
> > > > > + * Contact: Sakari Ailus <sakari.ailus@nokia.com>
> > > > > + *          Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
> > > > 
> > > > You should put these people to CC... Just to see if the
> > > > addresses are still valid (which I doubt).
> > > 
> > > Ok, trying :-)
> > > 
> > 
> > I got "Delivery Status Notification (Failure)" for both addresses.

This is expected.

> Sakari Ailus hosts some code on github [0], which has the following
> email address: sakari.ailus+gitorious@retiisi.org.uk
> 
> I added it to this mail's CC.
> 
> [0] https://gitorious.org/~sailus

Nice to hear people are interested in this. ;-)

The primary reason I haven't tried submitting this to mainline is that ARM
board code has a bad reputation these days. The N900 does not have yet
support for device tree (AFAIK), which also would require a few bits and
pieces on the flash driver to work.

Also the sensor and lens drivers would need at least some work before being
ready for submission to mainline for camera to be usable. Unfortunately I
haven't had recently time to work on this. N9(50) support has higher
priority for myself. That, too, is pending the DT support for the device.

There's indeed more up-to-date code in my repository. Even if it's not too
close to mainline anymore it should be a better starting point than the old
kernel from MeeGo.

<URL:https://gitorious.org/omap3camera/pages/Home>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
