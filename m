Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbaGUNWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:22:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243AbaGUNWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:22:18 -0400
Date: Mon, 21 Jul 2014 15:22:13 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Glauber Costa <glommer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC PATCH] memcg: export knobs for the defaul cgroup hierarchy
Message-ID: <20140721132213.GE8393@dhcp22.suse.cz>
References: <1405521578-19988-1-git-send-email-mhocko@suse.cz>
 <20140716155814.GZ29639@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716155814.GZ29639@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 16-07-14 11:58:14, Johannes Weiner wrote:
> On Wed, Jul 16, 2014 at 04:39:38PM +0200, Michal Hocko wrote:
[...]
> > +#ifdef CONFIG_MEMCG_KMEM
> > +	{
> > +		.name = "kmem.limit_in_bytes",
> > +		.private = MEMFILE_PRIVATE(_KMEM, RES_LIMIT),
> > +		.write = mem_cgroup_write,
> > +		.read_u64 = mem_cgroup_read_u64,
> > +	},
> 
> Does it really make sense to have a separate limit for kmem only?

It seems that needs furhter discussion so I will drop it in next version
of the patch and we can enable it or move to a single knob for U+K
later.
-- 
Michal Hocko
SUSE Labs
