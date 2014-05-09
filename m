Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbaEITvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:51:06 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:60228 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098AbaEITvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:51:03 -0400
Date: Fri, 9 May 2014 15:50:59 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        axboe@kernel.dk, hannes@cmpxchg.org, mhocko@suse.cz,
        arozansk@redhat.com
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement cftype->write()
Message-ID: <20140509195059.GE4486@htj.dyndns.org>
References: <1399380266-3324-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399380266-3324-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 08:44:21AM -0400, Tejun Heo wrote:
> This patchset is on top of
> 
>   cgroup/for-3.16 12d3089c192c ("kernel/cpuset.c: convert printk to pr_foo()")
> + [1] [PATCHSET cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates
> 
> and available on the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-post-unified-updates

Refreshed without content change on top of

  b9a63d0116e8 ("Merge branch 'for-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu into for-3.16")
+ [1] [PATCHSET v2 cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates

and available on the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-post-unified-updates-v2

-- 
tejun

[1] http://lkml.kernel.org/g/1399663975-315-1-git-send-email-tj@kernel.org
