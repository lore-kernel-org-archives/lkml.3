Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab3CYIUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 04:20:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756153Ab3CYIUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 04:20:50 -0400
Date: Mon, 25 Mar 2013 09:20:44 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Message-ID: <20130325082044.GM2154@dhcp22.suse.cz>
References: <514C1388.6090909@huawei.com>
 <514C14BF.3050009@parallels.com>
 <20130322093141.GE31457@dhcp22.suse.cz>
 <514C2754.4080701@parallels.com>
 <20130322094832.GG31457@dhcp22.suse.cz>
 <514C2C72.5090402@parallels.com>
 <20130322100609.GI31457@dhcp22.suse.cz>
 <514C3193.9010609@parallels.com>
 <20130322105616.GK31457@dhcp22.suse.cz>
 <514EAC9B.1010706@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514EAC9B.1010706@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 24-03-13 15:34:51, Li Zefan wrote:
> >> I read the code as lockdep_assert(memcg_cache_mutex), and then later on
> >> mutex_lock(&memcg_mutex). But reading again, that was a just an
> >> rcu_read_lock(). Good thing it is Friday
> >>
> >> You guys can add my Acked-by, and thanks again
> > 
> > Li, are you ok to take the page via your tree?
> > 
> 
> I don't have a git tree in kernel.org. It's Tejun that picks up
> cgroup patches.

Oh, I thought both of you push to that tree. Anyway, I will rework the
patch and send it again.
-- 
Michal Hocko
SUSE Labs
