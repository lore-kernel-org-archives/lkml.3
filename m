Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3GYHlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 03:41:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab3GYHlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 03:41:47 -0400
Date: Thu, 25 Jul 2013 09:41:46 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 0/8] memcg, cgroup: kill css_id
Message-ID: <20130725074146.GC12818@dhcp22.suse.cz>
References: <51EFA554.6080801@huawei.com>
 <20130724143214.GL2540@dhcp22.suse.cz>
 <51F07863.2070705@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F07863.2070705@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 25-07-13 08:59:15, Li Zefan wrote:
> On 2013/7/24 22:32, Michal Hocko wrote:
> > On Wed 24-07-13 17:58:44, Li Zefan wrote:
> >> This patchset converts memcg to use cgroup->id, and then we can remove
> >> cgroup css_id.
> >>
> >> As we've removed memcg's own refcnt, converting memcg to use cgroup->id
> >> is very straight-forward.
> >>
> >> The patchset is based on Tejun's cgroup tree.
> > 
> > Does it depend on any particular patches? I am asking because I would
> > need to cherry pick those and apply them into my -mm git tree before
> > these.
> > 
> 
> Nope, but you should see a few but small conflicts if you apply them to
> your git tree.
 
Ohh, then there is no problem at all and Tejun, doesn't have to prepare
any special branch.

Thanks!
-- 
Michal Hocko
SUSE Labs
