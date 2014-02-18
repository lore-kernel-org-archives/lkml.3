Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaBRHGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 02:06:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50077 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaBRHGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 02:06:47 -0500
Date: Tue, 18 Feb 2014 08:06:24 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
Message-ID: <20140218070624.GP17250@pengutronix.de>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
 <CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com>
 <20140217181451.7EB7FC4044D@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217181451.7EB7FC4044D@trevor.secretlab.ca>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:04:39 up 177 days, 16:35, 45 users,  load average: 0.04, 0.12,
 0.09
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Mon, Feb 17, 2014 at 06:14:51PM +0000, Grant Likely wrote:
> On Tue, 11 Feb 2014 07:56:33 -0600, Rob Herring <robherring2@gmail.com> wrote:
> > On Tue, Feb 11, 2014 at 5:45 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > > From: Philipp Zabel <philipp.zabel@gmail.com>
> > >
> > > This patch moves the parsing helpers used to parse connected graphs
> > > in the device tree, like the video interface bindings documented in
> > > Documentation/devicetree/bindings/media/video-interfaces.txt, from
> > > drivers/media/v4l2-core to drivers/of.
> > 
> > This is the opposite direction things have been moving...
> > 
> > > This allows to reuse the same parser code from outside the V4L2 framework,
> > > most importantly from display drivers. There have been patches that duplicate
> > > the code (and I am going to send one of my own), such as
> > > http://lists.freedesktop.org/archives/dri-devel/2013-August/043308.html
> > > and others that parse the same binding in a different way:
> > > https://www.mail-archive.com/linux-omap@vger.kernel.org/msg100761.html
> > >
> > > I think that all common video interface parsing helpers should be moved to a
> > > single place, outside of the specific subsystems, so that it can be reused
> > > by all drivers.
> > 
> > Perhaps that should be done rather than moving to drivers/of now and
> > then again to somewhere else.
> 
> This is just parsing helpers though, isn't it? I have no problem pulling
> helper functions into drivers/of if they are usable by multiple
> subsystems. I don't really understand the model being used though. I
> would appreciate a description of the usage model for these functions
> for poor folks like me who can't keep track of what is going on in
> subsystems.

You can find it under Documentation/devicetree/bindings/media/video-interfaces.txt

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
