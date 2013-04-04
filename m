Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761644Ab3DDPWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 11:22:22 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53504 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761409Ab3DDPWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 11:22:20 -0400
Date: Thu, 4 Apr 2013 08:22:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC][PATCH 5/7] cgroup: make sure parent won't be destroyed
 before its children
Message-ID: <20130404152213.GL9425@htj.dyndns.org>
References: <515BF233.6070308@huawei.com>
 <515BF2A4.1070703@huawei.com>
 <20130404113750.GH29911@dhcp22.suse.cz>
 <20130404133706.GA9425@htj.dyndns.org>
 <20130404152028.GK29911@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130404152028.GK29911@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 05:20:28PM +0200, Michal Hocko wrote:
> > But what harm does an additional reference do?
> 
> No harm at all. I just wanted to be sure that this is not yet another
> "for memcg" hack. So if this is useful for other controllers then I have
> no objections of course.

I think it makes sense in general, so let's do it in cgroup core.  I
suppose it'd be easier for this to be routed together with other memcg
changes?

Thanks.

-- 
tejun
