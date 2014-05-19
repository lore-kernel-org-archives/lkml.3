Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaESUdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:33:46 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:57459 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaESUdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:33:43 -0400
Date: Mon, 19 May 2014 16:33:39 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH cgroup/for-3.16] cgroup: clean up MAINTAINERS entries
Message-ID: <20140519203339.GE27506@mtj.dyndns.org>
References: <20140513194958.GD28815@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513194958.GD28815@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 03:49:58PM -0400, Tejun Heo wrote:
> There are currently three cgroup related entries in MAINTAINERS.  Make
> the following updates.
> 
> * Make the names - both cgroup and cpuset - singular.  We're mixing
>   singular and plural all over the place for no good reason.
> 
> * Drop containers@lists.linux-foundation.org from CGROUP.  That list
>   doesn't have much to do with cgroup per-se.
> 
> * Add Documentation field to CGROUP.
> 
> * Drop mm/*cgroup* from CGROUP.  memcg has separate maintainers.
> 
> * Prefix the controller-specific ones with "CONTROL CGROUP -" and
>   collect cgroup related entries under the core one.
> 
> * Add (MEMCG) abbreviation to MEMCG entry.
> 
> * Drop Balbir Singh and KAMEZAWA Hiroyuki from memcg maintainers.  It
>   has been quite a while since both actually worked on memcg.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Applied to cgroup/for-3.16.

Thanks.

-- 
tejun
