Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3EVH6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:58:39 -0400
Received: from relay.parallels.com ([195.214.232.42]:40856 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3EVH6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:58:37 -0400
Date: Wed, 22 May 2013 11:56:38 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Li Zefan <lizefan@huawei.com>
CC: Michal Hocko <mhocko@suse.cz>, Andrey Vagin <avagin@openvz.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: don't initialize kmem-cache destroying work for
 root caches
Message-ID: <20130522075638.GB16934@paralelels.com>
References: <1368535118-27369-1-git-send-email-avagin@openvz.org>
 <20130514160859.GC5055@dhcp22.suse.cz>
 <20130522074055.GA16207@paralelels.com>
 <519C78C0.3050204@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <519C78C0.3050204@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.24.21.118]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 03:50:24PM +0800, Li Zefan wrote:
> On 2013/5/22 15:40, Andrew Vagin wrote:
> > On Tue, May 14, 2013 at 06:08:59PM +0200, Michal Hocko wrote:
> >>
> >> Forgot to add
> >> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> >> +
> >> Cc: stable # 3.9
> >>
> >> Thanks
> > 
> > Who usually picks up such patches?
> 
> The famous AKPM.
>

Thanks.

get_maintainer.pl doesn't show Andrew in the list of recipients.

$ perl scripts/get_maintainer.pl 0001-memcg-don-t-initialize-kmem-cache-destroying-work-fo.patch
Johannes Weiner <hannes@cmpxchg.org> (maintainer:MEMORY RESOURCE C...)
Michal Hocko <mhocko@suse.cz> (maintainer:MEMORY RESOURCE C...)
Balbir Singh <bsingharora@gmail.com> (maintainer:MEMORY RESOURCE C...)
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> (maintainer:MEMORY RESOURCE C...)
cgroups@vger.kernel.org (open list:MEMORY RESOURCE C...)
linux-mm@kvack.org (open list:MEMORY RESOURCE C...)
linux-kernel@vger.kernel.org (open list) 
