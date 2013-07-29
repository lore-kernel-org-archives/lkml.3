Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab3G2S0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:26:40 -0400
Received: from mail-gh0-f178.google.com ([209.85.160.178]:49787 "EHLO
	mail-gh0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab3G2S0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:26:39 -0400
Date: Mon, 29 Jul 2013 14:26:32 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH v3 2/8] cgroup: document how cgroup IDs are assigned
Message-ID: <20130729182632.GC26076@mtj.dyndns.org>
References: <51F614B2.6010503@huawei.com>
 <51F614D4.6000703@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F614D4.6000703@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 03:08:04PM +0800, Li Zefan wrote:
> As cgroup id has been used in netprio cgroup and will be used in memcg,
> it's important to make it clear how a cgroup id is allocated.
> 
> For example, in netprio cgroup, the id is used as index of anarray.
> 
> Signed-off-by: Li Zefan <lizefan@huwei.com>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

We can merge this into the first patch?

Thanks.

-- 
tejun
