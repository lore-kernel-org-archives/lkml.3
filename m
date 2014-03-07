Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaCHFak (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 00:30:40 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:51050 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbaCHFa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 00:30:28 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v6 0/8] Move device tree graph parsing helpers to drivers/of
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
In-Reply-To: <20140306155018.GD21483@n2100.arm.linux.org.uk>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de> < 20140306152414.GC21483@n2100.arm.linux.org.uk> <1394120379.3622.37.camel@ paszta.hi.pengutronix.de> <20140306155018.GD21483@n2100.arm.linux.org.uk>
Date: Fri, 07 Mar 2014 18:49:34 +0000
Message-Id: <20140307184934.5F6D2C40D2A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014 15:50:18 +0000, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Thu, Mar 06, 2014 at 04:39:39PM +0100, Philipp Zabel wrote:
> > Am Donnerstag, den 06.03.2014, 15:24 +0000 schrieb Russell King - ARM
> > Linux:
> > > On Wed, Mar 05, 2014 at 10:20:34AM +0100, Philipp Zabel wrote:
> > > > this version of the OF graph helper move series further addresses a few of
> > > > Tomi's and Sylwester's comments.
> > > 
> > > Philipp,
> > > 
> > > You mention in your other cover for imx-drm bits that this is available
> > > via:
> > > 
> > > 	git://git.pengutronix.de/git/pza/linux.git topic/of-graph
> > > 
> > > What is this tree based upon?
> > 
> > It is based on v3.14-rc5.
> 
> Great.  As everyone seems happy, can you both send me and Mauro a pull
> request for this please?  Once Mauro says it's in his tree, I'll pull
> it in for imx-drm stuff.
> 
> Thanks.

I'm really not. There are still unresolved issues.

g.

