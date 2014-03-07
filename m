Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbaCGPuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:50:07 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41946 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751573AbaCGPuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:50:05 -0500
Date: Fri, 7 Mar 2014 15:49:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] of: Fix of_graph_parse_endpoint stub for !CONFIG_OF
	builds
Message-ID: <20140307154953.GL21483@n2100.arm.linux.org.uk>
References: <1394204235-28706-1-git-send-email-p.zabel@pengutronix.de> <1394204770.16309.16.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394204770.16309.16.camel@paszta.hi.pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 04:06:10PM +0100, Philipp Zabel wrote:
> I have also updated the git branch. The following changes since commit
> d484700a36952c6675aa47dec4d7a536929aa922:
> 
>   of: Warn if of_graph_parse_endpoint is called with the root node
> (2014-03-06 17:41:54 +0100)
> 
> are available in the git repository at:
> 
>   git://git.pengutronix.de/git/pza/linux.git topic/of-graph
> 
> for you to fetch changes up to 00fd9619120db1d6a19be2f9e3df6f76234b311b:
> 
>   of: Fix of_graph_parse_endpoint stub for !CONFIG_OF builds (2014-03-07
> 16:02:46 +0100)

Thanks, I'll re-pull it shortly.  The other good news is that I've thrown
your patches on top of the previous pull, merged them into my test tree
and everything seems to work as it should on the SolidRun Hummingboard.

What base have you used for those imx-drm patches?  I assume it would
be something like a merge of my imx-drm commits and the of-graph branch?

Let me put this a different way: I'd be happy to pull those changes if
they're sensibly based in your git tree.

Thanks.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
