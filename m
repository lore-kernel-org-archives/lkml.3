Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab3IWNIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:08:24 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:46128 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab3IWNIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:08:22 -0400
Date: Mon, 23 Sep 2013 09:08:16 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v6 0/5] memcg, cgroup: kill css id
Message-ID: <20130923130816.GH30946@htj.dyndns.org>
References: <524001F8.6070205@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524001F8.6070205@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 23, 2013 at 04:55:20PM +0800, Li Zefan wrote:
> The whole patchset has been acked and reviewed by Michal and Tejun.
> Could you merge it into mm tree?

Ah... I really hoped that this had been merged during -rc1 window.
Andrew, would it be okay to carry this series through cgroup tree?  It
doesn't really have much to do with mm proper and it's a PITA to have
to keep updating css_id code from cgroup side when it's scheduled to
go away.  If carried in -mm, it's likely to cause conflicts with
ongoing cgroup changes too.

Thanks.

-- 
tejun
