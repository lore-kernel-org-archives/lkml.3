Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbaEIT6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:58:33 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:56329 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533AbaEIT6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:58:31 -0400
Date: Fri, 9 May 2014 15:58:27 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: remove cgroup_tree_mutex
Message-ID: <20140509195827.GG4486@htj.dyndns.org>
References: <1399407574-21472-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399407574-21472-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 04:19:26PM -0400, Tejun Heo wrote:
> This patchset is on top of
> 
>   cgroup/for-3.16 12d3089c192c ("kernel/cpuset.c: convert printk to pr_foo()")
> + [1] [PATCHSET cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates
> + [2] [PATCHSET cgroup/for-3.16] cgroup: implement cftype->write()
> 
> and is available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-kill-tree_mutex

Refreshed without content change on top of

 b9a63d0116e8 ("Merge branch 'for-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu into for-3.16")
 + [1] [PATCHSET v2 cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates
 + [2] (REFRESHED) [PATCHSET cgroup/for-3.16] cgroup: implement cftype->write()

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-kill-tree_mutex-v2

Thanks.

-- 
tejun

[1] http://lkml.kernel.org/g/1399663975-315-1-git-send-email-tj@kernel.org
[2] http://lkml.kernel.org/g/20140509195059.GE4486@htj.dyndns.org
