Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaCGLzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:55:37 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41716 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752019AbaCGLzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:55:36 -0500
Date: Fri, 7 Mar 2014 11:55:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PULL] Move device tree graph parsing helpers to drivers/of
Message-ID: <20140307115517.GI21483@n2100.arm.linux.org.uk>
References: <1394126000.3622.66.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394126000.3622.66.camel@paszta.hi.pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 06:13:20PM +0100, Philipp Zabel wrote:
> Hi Mauro, Russell,
> 
> I have temporarily removed the simplified bindings at Sylwester's
> request and updated the branch with the acks. The following changes
> since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:
> 
>   Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)
> 
> are available in the git repository at:
> 
>   git://git.pengutronix.de/git/pza/linux.git topic/of-graph

Okay, this has all gone wrong.  Mauro has applied your changes as patches,
and I've pulled this set of changes.  So we're going to be all set for
merge conflicts....... just fscking great.

I really don't know why I bother trying to do the right thing sometimes.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
