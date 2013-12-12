Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab3LLX4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:56:10 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:16467 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751606Ab3LLX4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:56:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0HAF5MqlJ5LHyk/2dsb2JhbABZgwqDPLBahU+BHRd0giUBAQU6HCMQCAMYCSUPBSUDIROIA8MbFxaOfgeENQSYFIpMh0mDPSg
Date: Fri, 13 Dec 2013 10:56:01 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [HANG 3.13-rc3] blk-mq/virtio: mkfs.ext4 hangs in
 blk_mq_wait_for_tags
Message-ID: <20131212235601.GM10988@dastard>
References: <20131209223905.GU31386@dastard>
 <52A646D7.9090700@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A646D7.9090700@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 03:40:23PM -0700, Jens Axboe wrote:
> On 12/09/2013 03:39 PM, Dave Chinner wrote:
> > Hi Jens,
> > 
> > Another day, another blkmq/virtio problem. Running mkfs.ext4 on a
> > sparse 100TB VM file image, it hangs hard while writing superblock
> > information:
...
> 
> I'll take a look at this.

Any update, Jens?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
