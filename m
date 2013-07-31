Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533Ab3GaLsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:48:40 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:49747 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab3GaLsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:48:38 -0400
Date: Wed, 31 Jul 2013 07:48:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH v4 0/8] memcg, cgroup: kill css_id
Message-ID: <20130731114834.GO2810@htj.dyndns.org>
References: <51F86D69.2030907@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F86D69.2030907@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 09:50:33AM +0800, Li Zefan wrote:
> This patchset converts memcg to use cgroup->id, and then we can remove
> cgroup css_id.
> 
> As we've removed memcg's own refcnt, converting memcg to use cgroup->id
> is very straight-forward.
> 
> The patchset is based on Tejun's cgroup tree.

Applied 1-3 to cgroup/for-3.12.

Thanks.

-- 
tejun
