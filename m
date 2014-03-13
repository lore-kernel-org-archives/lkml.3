Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaCMLgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 07:36:07 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50980 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753920AbaCMLfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 07:35:51 -0400
Date: Thu, 13 Mar 2014 11:35:28 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PULL] Move device tree graph parsing helpers to drivers/of
Message-ID: <20140313113527.GM21483@n2100.arm.linux.org.uk>
References: <1394126000.3622.66.camel@paszta.hi.pengutronix.de> <20140307182330.75168C40AE3@trevor.secretlab.ca> <20140310102630.3cb1bcd7@samsung.com> <20140310143758.3734FC405FA@trevor.secretlab.ca> <1394708896.3577.21.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394708896.3577.21.camel@paszta.hi.pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 12:08:16PM +0100, Philipp Zabel wrote:
> I'm not sure if maybe I misunderstood or missed a mail, but I haven't
> seen a proposal to resolve the situation without rewinds. Given that
> Mauro already reverted the media tree and applied conflicting changes,
> that's probably not going to happen?

Grant and myself have exchanged emails in private on this discussing what
should happen - essentially Grant's position is that he's happy to leave
this stuff queued provided a resolution to his concerns are forthcoming.

However, what I find incredibly unfair is that we're taking the rap for
these bad bindings.  From what I can see, these bad bindings were merged
into the V4L2 code with _zero_ review by DT maintainers.  It's quite
clear that DT maintainers would have objected to them had they seen them,
but they didn't.  And the lack of documentation of the bindings which
has been something that's been insisted on is also disgusting.

And now we're now taking the pain for that oversight.

So... frankly, I've walked away from this dysfunctional situation.  I
don't see imx-drm moving out of drivers/staging due to this debacle for
many months - possibly never now given that no one can agree on this
stuff.  This just goes to show what a fscking joke mainline kernels are,
and why people just give up and go to vendor kernels which offer /much/
better support all round.

As far as I can see, it's proved impossible to define a set of bindings
for display devices which satisfy everyone.  So, rather than doing
/something/ so we can move forward, we end up doing /nothing/.

It's times like this where I start believing that /board files/ were the
best solution for ARM, because DT just carries soo many thorny issues
(such as these) and is a continual blocker.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
