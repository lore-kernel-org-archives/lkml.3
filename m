Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaCFPue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:50:34 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40340 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752095AbaCFPud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:50:33 -0500
Date: Thu, 6 Mar 2014 15:50:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v6 0/8] Move device tree graph parsing helpers to
	drivers/of
Message-ID: <20140306155018.GD21483@n2100.arm.linux.org.uk>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de> <20140306152414.GC21483@n2100.arm.linux.org.uk> <1394120379.3622.37.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394120379.3622.37.camel@paszta.hi.pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 04:39:39PM +0100, Philipp Zabel wrote:
> Am Donnerstag, den 06.03.2014, 15:24 +0000 schrieb Russell King - ARM
> Linux:
> > On Wed, Mar 05, 2014 at 10:20:34AM +0100, Philipp Zabel wrote:
> > > this version of the OF graph helper move series further addresses a few of
> > > Tomi's and Sylwester's comments.
> > 
> > Philipp,
> > 
> > You mention in your other cover for imx-drm bits that this is available
> > via:
> > 
> > 	git://git.pengutronix.de/git/pza/linux.git topic/of-graph
> > 
> > What is this tree based upon?
> 
> It is based on v3.14-rc5.

Great.  As everyone seems happy, can you both send me and Mauro a pull
request for this please?  Once Mauro says it's in his tree, I'll pull
it in for imx-drm stuff.

Thanks.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
