Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbaCTQDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:03:37 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:58772 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325AbaCTQDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:03:31 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [GIT PULL] Move device tree graph parsing helpers to drivers/of
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
In-Reply-To: <20140313113527.GM21483@n2100.arm.linux.org.uk>
References: <1394126000.3622.66.camel@paszta.hi.pengutronix.de> < 20140307182330.75168C40AE3@trevor.secretlab.ca> <20140310102630.3cb1bcd7@ samsung.com> <20140310143758.3734FC405FA@trevor.secretlab.ca> <1394708896. 3577.21.camel@paszta.hi.pengutronix.de> <20140313113527.GM21483@n2100.arm. linux.org.uk>
Date: Thu, 20 Mar 2014 16:03:26 +0000
Message-Id: <20140320160326.DF57CC4067A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014 11:35:28 +0000, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Thu, Mar 13, 2014 at 12:08:16PM +0100, Philipp Zabel wrote:
> > I'm not sure if maybe I misunderstood or missed a mail, but I haven't
> > seen a proposal to resolve the situation without rewinds. Given that
> > Mauro already reverted the media tree and applied conflicting changes,
> > that's probably not going to happen?
> 
> Grant and myself have exchanged emails in private on this discussing what
> should happen - essentially Grant's position is that he's happy to leave
> this stuff queued provided a resolution to his concerns are forthcoming.
> 
> However, what I find incredibly unfair is that we're taking the rap for
> these bad bindings.  From what I can see, these bad bindings were merged
> into the V4L2 code with _zero_ review by DT maintainers.  It's quite
> clear that DT maintainers would have objected to them had they seen them,
> but they didn't.  And the lack of documentation of the bindings which
> has been something that's been insisted on is also disgusting.

When a binding is limited to a single driver, review isn't critical.
When it is local to a single subsystem the bar is a little higher. Yes,
it should have had more review, but the surface area is still minimal.
By turning the binding into a generic pattern that all subsystems are
welcome to use the bar becomes higher still. It is not unreasonable for
a binding a new round of review when it is being adapted to become more
generic.

V4L2 can and should continue to use what it has. It certainly is not
okay to break existing platforms. All of my issues are directed toward
new users.

Despite my concerns, I do want this series to get merged in the next
merge window.

g.

