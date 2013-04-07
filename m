Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639Ab3DGTvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 15:51:19 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:40148 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933400Ab3DGTvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 15:51:18 -0400
Date: Sun, 7 Apr 2013 21:51:12 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC][PATCH 0/7] memcg: make memcg's life cycle the same as
 cgroup
Message-ID: <20130407195112.GA12678@dhcp22.suse.cz>
References: <515BF233.6070308@huawei.com>
 <516131D7.8030004@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516131D7.8030004@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 07-04-13 16:44:07, Li Zefan wrote:
> Hi,
> 
> I'm rebasing this patchset against latest linux-next, and it conflicts with
> "[PATCH v2] memcg: debugging facility to access dangling memcgs." slightly.
> 
> That is a debugging patch and will never be pushed into mainline, so should I
> still base this patchset on that debugging patch?

Could you split CONFIG_MEMCG_DEBUG_ASYNC_DESTROY changes into a separate
patch so that Andrew could put it on top of the mentioned patch?

> Also that patch needs update (and can be simplified) after this patchset:
> - move memcg_dangling_add() to mem_cgroup_css_offline()
> - remove memcg->memcg_name, and use cgroup_path() in mem_cgroup_dangling_read()?

Every improvement is welcome.

Thanks
-- 
Michal Hocko
SUSE Labs
