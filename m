Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3J3A1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:27:09 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:41756 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3J3A1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:27:07 -0400
Date: Wed, 30 Oct 2013 09:27:02 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] clocksource: sh_cmt: Add clk_prepare/unprepare
 support
Message-ID: <20131030002702.GK21262@verge.net.au>
References: <1383000569-8916-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <9952506.6pWpQZf7WG@avalon>
 <20131030001018.GF21262@verge.net.au>
 <1577850.BRVoxx5piP@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1577850.BRVoxx5piP@avalon>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 01:13:40AM +0100, Laurent Pinchart wrote:
> Hi Simon,
> 
> On Wednesday 30 October 2013 09:10:19 Simon Horman wrote:
> > On Tue, Oct 29, 2013 at 10:55:05AM +0100, Laurent Pinchart wrote:
> > > On Tuesday 29 October 2013 14:55:35 Simon Horman wrote:
> > > > On Mon, Oct 28, 2013 at 11:49:18PM +0100, Laurent Pinchart wrote:
> > > > > Prepare the clock at probe time, as there is no other appropriate
> > > > > place in the driver where we're allowed to sleep.
> > > > > 
> > > > > Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> > > > > Cc: linux-kernel@vger.kernel.org
> > > > > Signed-off-by: Laurent Pinchart
> > > > > <laurent.pinchart+renesas@ideasonboard.com>
> > > > 
> > > > Thanks Laurent,
> > > > 
> > > > I have queued this up in the clocksources branch of my renesas tree.
> > > > I will send a pull request to Mike once v3.13-rc1 has hit the shelves.
> > > > Mike, please let me know if you would prefer something earlier than
> > > > that.
> > > 
> > > I thought the clocksource patches had to go through Daniel's tree. If you
> > > can take them directly that's easier, so I'm fine with that. Does this
> > > imply your Acked-by (for patches 01 to 03) ?
> > 
> > Sorry, my mistake. The do go through Daniel. As a convenience
> > I have been picking up Renesas clocksource patches and passing
> > them on to Daniel. I'm happy to keep doing this. And I'm happy to
> > go the next step and add some entries to MAINTAINERS if that is
> > useful to others.
> > 
> > As I mentioned above I have queued these up (though not yet pushed them
> > as I got bogged down yesterday afternoon). But if you would
> > prefer Daniel to take them directly then please use the following:
> > 
> > Patches 01 - 03:
> > 
> > Acked-by: Simon Horman <horms+renesas@verge.net.au>
> 
> I'm certainly fine with you picking the patches up, that would be helpful. 
> Could I ask you to pick v2 up instead though ? :-)

Sure. I have dropped v1 and will pick up v2 when I see them.
