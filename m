Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaCGMGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:06:47 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41727 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751457AbaCGMGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:06:46 -0500
Date: Fri, 7 Mar 2014 12:06:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v6 0/8] Move device tree graph parsing helpers to
	drivers/of
Message-ID: <20140307120633.GJ21483@n2100.arm.linux.org.uk>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de> <53170C00.20200@ti.com> <1394030554.8754.31.camel@paszta.hi.pengutronix.de> <20140306141657.GB21483@n2100.arm.linux.org.uk> <20140306121721.6186dafb@samsung.com> <5318988C.2030004@samsung.com> <1394122879.3622.47.camel@paszta.hi.pengutronix.de> <5318A331.2070603@samsung.com> <1394124630.3622.64.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394124630.3622.64.camel@paszta.hi.pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 05:50:30PM +0100, Philipp Zabel wrote:
> Am Donnerstag, den 06.03.2014, 17:32 +0100 schrieb Sylwester Nawrocki:
> > On 06/03/14 17:21, Philipp Zabel wrote:
> > > Am Donnerstag, den 06.03.2014, 16:47 +0100 schrieb Sylwester Nawrocki:
> > >> Yes, it's going to conflict with my patch series. I thought it could be
> > >> put onto a stable a topic branch, e.g. at git://linuxtv.org/media_tree.git,
> > >> which could be then pulled into the media master branch and anywhere
> > >> else it is needed ?
> > > 
> > > Mauro, are you ok with handling the conflict in the merge, or should I
> > > rebase on top of the media tree after you merged Sylwester's changes?
> > 
> > I could rebase and resolve any conflicts before sending my pull request
> > to Mauro. I don't think it's a good idea to rebase this series onto the
> > media tree, since it is touching drivers/of.
> 
> Excellent, thanks. I will send a pull request to Mauro and Russell
> shortly.

Unless we can find some way to resolve the problem which just happened
(Mauro applied the of-graph as patches to his tree inspite of this
discussion), I don't see the imx-drm DT changes being able to be pulled
in for the upcoming merge window - because otherwise it means that
whatever Mauro has applied your of-graph changes on top of in his tree
also gets pulled into my tree and Greg's tree.

I'm afraid this has turned into a total shambles, and I'm totally
hacked off at Mauro over this.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
