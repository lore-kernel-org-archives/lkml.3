Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab3EQDgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:36:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47276 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab3EQDgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:36:15 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <5195A574.3080106@jp.fujitsu.com>
Date: Fri, 17 May 2013 12:35:16 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] memcg: update TODO list in Documentation
References: <5195A41D.7050507@huawei.com>
In-Reply-To: <5195A41D.7050507@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/05/17 12:29), Li Zefan wrote:
> hugetlb cgroup has already been implemented.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>   Documentation/cgroups/memory.txt | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index ddf4f93..327acec 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -834,10 +834,9 @@ Test:
>   
>   12. TODO
>   
> -1. Add support for accounting huge pages (as a separate controller)
> -2. Make per-cgroup scanner reclaim not-shared pages first
> -3. Teach controller to account for shared-pages
> -4. Start reclamation in the background when the limit is
> +1. Make per-cgroup scanner reclaim not-shared pages first
> +2. Teach controller to account for shared-pages
> +3. Start reclamation in the background when the limit is
>      not yet hit but the usage is getting closer
>   
>   Summary
> 


