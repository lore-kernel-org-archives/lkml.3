Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaCQX2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 19:28:31 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:42730 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaCQX23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 19:28:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [GIT PULL] Move device tree graph parsing helpers to drivers/of
Date: Tue, 18 Mar 2014 00:30:13 +0100
Message-ID: <5247436.pV9jXGKXCJ@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140314070505.GV1629@pengutronix.de>
References: <1394126000.3622.66.camel@paszta.hi.pengutronix.de> <5321CB04.6090700@samsung.com> <20140314070505.GV1629@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Friday 14 March 2014 08:05:05 Robert Schwebel wrote:
> On Thu, Mar 13, 2014 at 04:13:08PM +0100, Sylwester Nawrocki wrote:
> > My experience and feelings are similar, I started to treat mainline
> > kernel much less seriously after similar DT related blocking issues.
> 
> So how do we proceed now? Philipp implemented any of the suggested variants
> now; nevertheless, there doesn't seem to be a consensus.
> 
> However, we really need a decision of the oftree maintainers. I think we are
> fine with almost any of the available variants, as long as there is a
> decision.
> 
> It would be great if we could soon continue to address the technical issues
> with the IPU, instead of turning around oftree bindings. There is really
> enough complexity left :-)

I agree with you. I know that DT bindings review takes too much time, slows 
development down and is just generally painful. I'm trying to reply to this e-
mail thread as fast as possible, but I'm also busy with other tasks :-/

The lack of formal consensus comes partly from the fact that people are busy 
and that the mail thread is growing big. There's still two open questions from 
my view of the whole discussion:

- Do we really want to drop bidirectional links ? Grant has been pretty vocal 
about that, but there has been several replies with arguments for 
bidirectional links, and no reply from him afterwards. Even though that 
wouldn't be the preferred solution for everybody, there doesn't seem to be a 
strong disagreement about dropping bidirectional links, as long as we can come 
up with a reasonable implementation.

- If we drop bidirectional links, what link direction do we use ? There has 
been several proposals (including "north", which I think isn't future-proof as 
it assumes an earth-centric model) and no real agreement, although there seems 
to be a consensus among several developers that the core OF graph bindings 
could leave that to be specified by subsystem bindings. We would still have to 
agree on a direction for the display subsystem of course.

If my above explanation isn't too far from the reality the next step could be 
to send a new version of the DT bindings proposal as a ping.

-- 
Regards,

Laurent Pinchart

