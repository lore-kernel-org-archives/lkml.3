Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaCGQio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:38:44 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54770 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaCGQin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:38:43 -0500
Message-ID: <1394210312.16309.22.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH] of: Fix of_graph_parse_endpoint stub for !CONFIG_OF
 builds
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Fri, 07 Mar 2014 17:38:32 +0100
In-Reply-To: <20140307154953.GL21483@n2100.arm.linux.org.uk>
References: <1394204235-28706-1-git-send-email-p.zabel@pengutronix.de>
	 <1394204770.16309.16.camel@paszta.hi.pengutronix.de>
	 <20140307154953.GL21483@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Am Freitag, den 07.03.2014, 15:49 +0000 schrieb Russell King - ARM
Linux:
> On Fri, Mar 07, 2014 at 04:06:10PM +0100, Philipp Zabel wrote:
> > I have also updated the git branch. The following changes since commit
> > d484700a36952c6675aa47dec4d7a536929aa922:
> > 
> >   of: Warn if of_graph_parse_endpoint is called with the root node
> > (2014-03-06 17:41:54 +0100)
> > 
> > are available in the git repository at:
> > 
> >   git://git.pengutronix.de/git/pza/linux.git topic/of-graph
> > 
> > for you to fetch changes up to 00fd9619120db1d6a19be2f9e3df6f76234b311b:
> > 
> >   of: Fix of_graph_parse_endpoint stub for !CONFIG_OF builds (2014-03-07
> > 16:02:46 +0100)
> 
> Thanks, I'll re-pull it shortly.  The other good news is that I've thrown
> your patches on top of the previous pull, merged them into my test tree
> and everything seems to work as it should on the SolidRun Hummingboard.
>
> What base have you used for those imx-drm patches?  I assume it would
> be something like a merge of my imx-drm commits and the of-graph branch?

I have based the topic/imx-drm-dt branch on the staging-next branch of
the staging tree, at the time it was created:
    17b02809cfa77abcab155ce3afbb1467e7f0744f "Merge 3.14-rc5 into staging-next"

The topic/imx-drm-dt branch is not based on topic/of-graph at all.

> Let me put this a different way: I'd be happy to pull those changes if
> they're sensibly based in your git tree.

Thanks!

regards
Philipp

