Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaFENxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:53:35 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:35939 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaFENxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:53:33 -0400
Date: Thu, 5 Jun 2014 09:53:29 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] cgroup: disallow disabled controllers on the default
 hierarchy
Message-ID: <20140605135329.GB21607@htj.dyndns.org>
References: <5390356E.70305@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5390356E.70305@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 05:16:30PM +0800, Li Zefan wrote:
> After booting with cgroup_disable=memory, I still saw memcg files
> in the default hierarchy, and I can write to them, though it won't
> take effect.
> 
>   # dmesg
>   ...
>   Disabling memory control group subsystem
>   ...
>   # mount -t cgroup -o __DEVEL__sane_behavior xxx /cgroup
>   # ls /cgroup
>   ...
>   memory.failcnt                   memory.move_charge_at_immigrate
>   memory.force_empty               memory.numa_stat
>   memory.limit_in_bytes            memory.oom_control
>   ...
>   # cat /cgroup/memory.usage_in_bytes
>   0
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.16 w/ minor comment update.

Thanks.

-- 
tejun
