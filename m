Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaIPGQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 02:16:39 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40693 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaIPGQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 02:16:37 -0400
Date: Tue, 16 Sep 2014 15:16:30 +0900
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@gmail.com>,
        Pavel Emelianov <xemul@parallels.com>,
        Greg Thelen <gthelen@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH RFC] memcg: revert kmem.tcp accounting
Message-ID: <20140916061630.GE805@mtj.dyndns.org>
References: <1410535618-9601-1-git-send-email-vdavydov@parallels.com>
 <20140912171809.GA24469@dhcp22.suse.cz>
 <20140912175516.GB6298@mtj.dyndns.org>
 <20140912144326.a8d5153d7c91d220ea89924a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140912144326.a8d5153d7c91d220ea89924a@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Fri, Sep 12, 2014 at 02:43:26PM -0700, Andrew Morton wrote:
> 17 files changed, 51 insertions(+), 761 deletions(-)
> 
> Sob.
> 
> Is there a convenient way of disabling the whole thing and adding a
> please-tell-us printk?  If nobody tells us for a year or two then zap.

Given that we're in the process of implementing the v2 interface, I
don't think it'd be wise to perturb v1 interface at this point.  We're
gonna have to carry around v1 code for quite some time anyway and I
don't think carrying the tcp code would make whole lot of difference
given that the code is likely to stay static from now on.

Thanks.

-- 
tejun
