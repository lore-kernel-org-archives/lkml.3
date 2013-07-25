Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3GYEQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 00:16:18 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:11777 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886Ab3GYEPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 00:15:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An4IAOel8FF5LPxH/2dsb2JhbABagwaDKLYBhTqBFhd0giQBAQU6HDMIAxgJGgsPBSUDIQESiA+6IRaPboQAA5deiiOHK4FbgUsq
Date: Thu, 25 Jul 2013 14:15:38 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file:
 fs/xfs/xfs_dir2_sf.c, line: 358
Message-ID: <20130725041538.GH13468@dastard>
References: <20130712023930.GA6473@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712023930.GA6473@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 10:39:30PM -0400, Dave Jones wrote:
> Just saw this during boot after an unclean shutdown. It hung afterwards.
> 
> [   97.162665] XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file: fs/xfs/xfs_dir2_sf.c, line: 358
> [   97.164646] ------------[ cut here ]------------

I just reproduced this by chance. I know exactly what I was doing
when it went bang, so I might be able to reduce it from scattergun
blast testing to be able to reproduce it on demand.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
