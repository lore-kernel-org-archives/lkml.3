Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965046Ab3DHOhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:37:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34407 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964984Ab3DHOhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:37:07 -0400
Date: Mon, 8 Apr 2013 16:37:04 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 0/8] memcg, cgroup: kill css_id
Message-ID: <20130408143704.GJ17178@dhcp22.suse.cz>
References: <51627DA9.7020507@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51627DA9.7020507@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 08-04-13 16:19:53, Li Zefan wrote:
[...]
>  include/linux/cgroup.h |  44 ++-------
>  kernel/cgroup.c        | 302 +++++++++-----------------------------------------------------
>  mm/memcontrol.c        |  53 ++++++-----
>  3 files changed, 77 insertions(+), 322 deletions(-)

Nice and thanks a lot Li!

-- 
Michal Hocko
SUSE Labs
