Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab3IXBbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 21:31:05 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64523 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab3IXBbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 21:31:03 -0400
Date: Mon, 23 Sep 2013 21:30:58 -0400
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v6 0/5] memcg, cgroup: kill css id
Message-ID: <20130924013058.GB3482@htj.dyndns.org>
References: <524001F8.6070205@huawei.com>
 <20130923130816.GH30946@htj.dyndns.org>
 <20130923131215.GI30946@htj.dyndns.org>
 <5240DD83.1070509@huawei.com>
 <20130923175247.ea5156de.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923175247.ea5156de.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Mon, Sep 23, 2013 at 05:52:47PM -0700, Andrew Morton wrote:
> > I would love to see this patchset go through cgroup tree. The changes to
> > memcg is quite small,
> 
> It seems logical to put this in the cgroup tree as that's where most of
> the impact occurs.

Cool, applying the changes to cgroup/for-3.13.

> > and as -mm tree is based on -next it won't cause
> > future conflicts.
> 
> That's no longer the case - I'm staging -mm patches ahead of linux-next
> now.  Except in cases where that's impractical, such as the 3.12 memcg
> changes which were pretty heavily impacted by cgroups tree changes.

Please note that cgroup is likely to continue to go through a lot of
changes for the foreseeable future and memcg is likely to be affected
heavily.

Thanks.

-- 
tejun
