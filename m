Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab3GYHkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 03:40:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab3GYHkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 03:40:35 -0400
Date: Thu, 25 Jul 2013 09:40:32 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 0/8] memcg, cgroup: kill css_id
Message-ID: <20130725074032.GB12818@dhcp22.suse.cz>
References: <51EFA554.6080801@huawei.com>
 <20130724143214.GL2540@dhcp22.suse.cz>
 <20130724161407.GD20377@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130724161407.GD20377@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-07-13 12:14:07, Tejun Heo wrote:
> On Wed, Jul 24, 2013 at 04:32:14PM +0200, Michal Hocko wrote:
> > On Wed 24-07-13 17:58:44, Li Zefan wrote:
> > > This patchset converts memcg to use cgroup->id, and then we can remove
> > > cgroup css_id.
> > > 
> > > As we've removed memcg's own refcnt, converting memcg to use cgroup->id
> > > is very straight-forward.
> > > 
> > > The patchset is based on Tejun's cgroup tree.
> > 
> > Does it depend on any particular patches? I am asking because I would
> > need to cherry pick those and apply them into my -mm git tree before
> > these.
> 
> I'll set up a branch with the prep cgroup patches bsaed on top of
> v3.10 which you can pull into your tree (let's please not cherry-pick)
> and the memcg part and actual css_id removal can be carried through
> -mm.

Great. Thanks a lot Tejun!

> 
> Thanks.
> 
> -- 
> tejun

-- 
Michal Hocko
SUSE Labs
