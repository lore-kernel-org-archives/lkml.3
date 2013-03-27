Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab3C0QTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:19:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab3C0QTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:19:08 -0400
Date: Wed, 27 Mar 2013 17:19:05 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Message-ID: <20130327161905.GN16579@dhcp22.suse.cz>
References: <1364373399-17397-1-git-send-email-mhocko@suse.cz>
 <20130327161527.GA7395@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130327161527.GA7395@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 27-03-13 09:15:27, Tejun Heo wrote:
> On Wed, Mar 27, 2013 at 09:36:39AM +0100, Michal Hocko wrote:
> > +/*
> > + * Called with memcg_cache_mutex held
> > + */
> >  static struct kmem_cache *kmem_cache_dup(struct mem_cgroup *memcg,
> >  					 struct kmem_cache *s)
> 
> Maybe the name could signify it's part of memcg?

kmem_ prefix is used for all CONFIG_MEMCG_KMEM functions. I understand
it clashes with sl?b naming but this is out of scope of this patch IMO.

-- 
Michal Hocko
SUSE Labs
