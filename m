Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935184Ab3DIGtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 02:49:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935060Ab3DIGtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 02:49:05 -0400
Date: Tue, 9 Apr 2013 08:49:04 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 5/8] memcg: convert to use cgroup->id
Message-ID: <20130409064904.GD29860@dhcp22.suse.cz>
References: <51627DA9.7020507@huawei.com>
 <51627E33.4090107@huawei.com>
 <20130408145702.GM17178@dhcp22.suse.cz>
 <516384BC.7040302@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516384BC.7040302@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-04-13 11:02:20, Li Zefan wrote:
> On 2013/4/8 22:57, Michal Hocko wrote:
> > On Mon 08-04-13 16:22:11, Li Zefan wrote:
> >> This is a preparation to kill css_id.
> >>
> >> Signed-off-by: Li Zefan <lizefan@huawei.com>
> > 
> > This patch depends on the following patch, doesn't it? There is no
> > guarantee that id fits into short right now. Not such a big deal but
> > would be nicer to have that guarantee for bisectability.
> > 
> 
> Not necessary, because css_id still prevents us from creating too
> many cgroups.

Right you are.

Thanks
-- 
Michal Hocko
SUSE Labs
