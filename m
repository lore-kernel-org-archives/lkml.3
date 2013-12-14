Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3LNIVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 03:21:06 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41544 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075Ab3LNIVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 03:21:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjcIADcUrFJ5LHyk/2dsb2JhbABZgwq0H4VPgR0XdIIlAQEFOhwzCAMYCSUPBSUDIQESiAPKKRcWjwqENgEDmBWSFYM+KA
Date: Sat, 14 Dec 2013 19:20:59 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: XFS / writeback invoking soft lockup.
Message-ID: <20131214082059.GS31386@dastard>
References: <20131213071407.GA6527@redhat.com>
 <20131213104853.GS10988@dastard>
 <20131213111639.GD23546@infradead.org>
 <20131213162228.GA29908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213162228.GA29908@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 11:22:28AM -0500, Dave Jones wrote:
> On Fri, Dec 13, 2013 at 03:16:39AM -0800, Christoph Hellwig wrote:
>  > On Fri, Dec 13, 2013 at 09:48:53PM +1100, Dave Chinner wrote:
>  > > All I can say is that there doesn't look to be any obvious signs
>  > > that this is a XFS or writeback problem fom the stack trace, and
>  > > without more information or a reproducable test case I'm not going
>  > > to be able to understand the cause.
>  > > 
>  > > Is the problem reproducable, or is it just a one-off?
>  > 
>  > If it's reproducable it would be good to enable the xfs_writepage
>  > tracepoint and get a trace-cmd log of it.
> 
> I hit it pretty reliably last night.  I'll make a note to look into it 
> on monday with that enabled.

You might want to grab the writeback tracepoints as well. Note that
you'll probably have to filter by device so you don't get noise from
all the other block devices, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
