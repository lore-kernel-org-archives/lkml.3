Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936726Ab3DICu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 22:50:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60485 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934585Ab3DICu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 22:50:27 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <516381DD.8050706@jp.fujitsu.com>
Date: Tue, 09 Apr 2013 11:50:05 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 03/12] Revert "memcg: avoid dangling reference count in
 creation failure."
References: <5162648B.9070802@huawei.com> <516264BF.2020009@huawei.com>
In-Reply-To: <516264BF.2020009@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/08 15:33), Li Zefan wrote:
> From: Michal Hocko <mhocko@suse.cz>
> 
> This reverts commit e4715f01be697a3730c78f8ffffb595591d6a88c
> 
> mem_cgroup_put is hierarchy aware so mem_cgroup_put(memcg) already drops
> an additional reference from all parents so the additional
> mem_cgrroup_put(parent) potentially causes use-after-free.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



