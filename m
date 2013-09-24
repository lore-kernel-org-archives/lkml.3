Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab3IXBqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 21:46:18 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:45713 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3IXBqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 21:46:16 -0400
Date: Mon, 23 Sep 2013 21:46:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v6 0/5] memcg, cgroup: kill css id
Message-ID: <20130924014612.GC3482@htj.dyndns.org>
References: <524001F8.6070205@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524001F8.6070205@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 04:55:20PM +0800, Li Zefan wrote:
> Hi Andrew,
> 
> The whole patchset has been acked and reviewed by Michal and Tejun.
> Could you merge it into mm tree?
> 
> ===========
> 
> This patchset converts memcg to use cgroup->id, and then we remove cgroup
> css_id.

Applied to cgroup/for-3.13.

Thanks.

-- 
tejun
