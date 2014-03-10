Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaCJOiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:38:07 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:49536 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaCJOiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:38:03 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [GIT PULL] Move device tree graph parsing helpers to drivers/of
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
In-Reply-To: <20140310102630.3cb1bcd7@samsung.com>
References: <1394126000.3622.66.camel@paszta.hi.pengutronix.de> < 20140307182330.75168C40AE3@trevor.secretlab.ca> <20140310102630.3cb1bcd7@ samsung.com>
Date: Mon, 10 Mar 2014 14:37:58 +0000
Message-Id: <20140310143758.3734FC405FA@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 10:26:30 -0300, Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:
> Em Fri, 07 Mar 2014 18:23:30 +0000
> Grant Likely <grant.likely@linaro.org> escreveu:
> 
> > On Thu, 06 Mar 2014 18:13:20 +0100, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > > Hi Mauro, Russell,
> > > 
> > > I have temporarily removed the simplified bindings at Sylwester's
> > > request and updated the branch with the acks. The following changes
> > > since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:
> > > 
> > >   Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.pengutronix.de/git/pza/linux.git topic/of-graph
> > > 
> > > for you to fetch changes up to d484700a36952c6675aa47dec4d7a536929aa922:
> > > 
> > >   of: Warn if of_graph_parse_endpoint is called with the root node (2014-03-06 17:41:54 +0100)
> > 
> > Nak. I made comments that haven't been resolved yet. I've replied with
> > more detail tonight. The big issues are how drivers handle the optional
> > 'ports' node and I do not agree to the double-linkage in the binding
> > description.
> 
> If I understood well, you're requesting to revert all those six patches
> that were imported via git pull from my tree (and from Greg and Russell),
> right?
> 
> E. g. reverting those changesets:
> 	d484700a3695 f2a575f67695 4329b93b283c 6ff60d397b17 4d56ed5a009b fd9fdb78a9bf
> 
> as it seems that there's no easy way to revert a git pull.

All trees containing the branch would need to be reverted.

> I suspect that this will likely cause some harm when merging from our
> trees upstream.

It means any tree containing that branch *must* be rewound. See my reply
to rmk. I've made a proposal on how I could be happy with leaving the
branches alone. I'm not particularly happy, but there is a way to
resolve things without reverts or rewinds.

g.
