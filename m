Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaGaTAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 15:00:47 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:45882 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaGaTAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:00:45 -0400
Date: Thu, 31 Jul 2014 15:00:41 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH percpu/for-3.17 1/2] percpu: implement percpu_pool
Message-ID: <20140731190041.GA1967@htj.dyndns.org>
References: <20140718200804.GG13012@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718200804.GG13012@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 04:08:04PM -0400, Tejun Heo wrote:
> Hello,
> 
> So, I have another case where percpu allocation needs to be performed
> from an atomic context (also on the IO path), so I wrote up a simple
> percpu alloc cache which is filled asynchronously and replaced
> blk-throttle's custom implementation with it.
> 
> I still think it's quite unlikely that we implement atomic allocation
> directly in the percpu allocator; however, even if that happens
> eventually, having percpu_pool instead of multiple custom mechanisms
> scattered around the kernel should make it a lot easier to transition
> to that.
> 
> Thanks.
> ------ 8< ------
> From eaaca4e64d3cce54d2b7ac5e4d5fb207290cc48f Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Fri, 18 Jul 2014 16:07:14 -0400
> Subject: [PATCH 1/2] percpu: implement percpu_pool

Applied the first patch to percpu/for-3.17.  Jens, how should I route
the second patch?

Thanks.

-- 
tejun
