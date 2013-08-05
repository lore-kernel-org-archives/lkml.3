Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab3HEMt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 08:49:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab3HEMt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 08:49:58 -0400
Date: Mon, 5 Aug 2013 08:49:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 09/23] cgroup: add subsys backlink pointer to cftype
Message-ID: <20130805124951.GB2274@redhat.com>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
 <1375393801-4817-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375393801-4817-10-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 05:49:47PM -0400, Tejun Heo wrote:
> cgroup is transitioning to using css (cgroup_subsys_state) instead of
> cgroup as the primary subsystem handle.  The cgroupfs file interface
> will be converted to use css's which requires finding out the
> subsystem from cftype so that the matching css can be determined from
> the cgroup.
> 
> This patch adds cftype->ss which points to the subsystem the file
> belongs to.  The field is initialized while a cftype is being
> registered.  This makes it unnecessary to explicitly specify the
> subsystem for other cftype handling functions.  @ss argument dropped
> from various cftype handling functions.
> 
> This patch shouldn't introduce any behavior differences.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-cgroup.c     |  2 +-

blk-cgroup bits are simple here. Ack for these.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek
