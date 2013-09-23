Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab3IWNMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:12:21 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:63131 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab3IWNMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:12:20 -0400
Date: Mon, 23 Sep 2013 09:12:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v6 0/5] memcg, cgroup: kill css id
Message-ID: <20130923131215.GI30946@htj.dyndns.org>
References: <524001F8.6070205@huawei.com>
 <20130923130816.GH30946@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923130816.GH30946@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 09:08:16AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Mon, Sep 23, 2013 at 04:55:20PM +0800, Li Zefan wrote:
> > The whole patchset has been acked and reviewed by Michal and Tejun.
> > Could you merge it into mm tree?
> 
> Ah... I really hoped that this had been merged during -rc1 window.
> Andrew, would it be okay to carry this series through cgroup tree?  It
> doesn't really have much to do with mm proper and it's a PITA to have
> to keep updating css_id code from cgroup side when it's scheduled to
> go away.  If carried in -mm, it's likely to cause conflicts with
> ongoing cgroup changes too.

Also, wasn't this already in -mm during the last devel cycle?  ISTR
conflicts with it in -mm with other cgroup core changes.  Is there any
specific reason why this wasn't merged during the merge windw?

Thanks.

-- 
tejun
