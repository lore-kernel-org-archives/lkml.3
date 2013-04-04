Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762511Ab3DDPa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 11:30:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762457Ab3DDPaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 11:30:55 -0400
Date: Thu, 4 Apr 2013 17:30:51 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC][PATCH 5/7] cgroup: make sure parent won't be destroyed
 before its children
Message-ID: <20130404153051.GL29911@dhcp22.suse.cz>
References: <515BF233.6070308@huawei.com>
 <515BF2A4.1070703@huawei.com>
 <20130404113750.GH29911@dhcp22.suse.cz>
 <20130404133706.GA9425@htj.dyndns.org>
 <20130404152028.GK29911@dhcp22.suse.cz>
 <20130404152213.GL9425@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130404152213.GL9425@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-04-13 08:22:13, Tejun Heo wrote:
> On Thu, Apr 04, 2013 at 05:20:28PM +0200, Michal Hocko wrote:
> > > But what harm does an additional reference do?
> > 
> > No harm at all. I just wanted to be sure that this is not yet another
> > "for memcg" hack. So if this is useful for other controllers then I have
> > no objections of course.
> 
> I think it makes sense in general, so let's do it in cgroup core.

Ok

> I suppose it'd be easier for this to be routed together with other
> memcg changes?

Probably yes.

> Thanks.
> 
> -- 
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
