Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab3EREVv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 00:21:51 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:39548 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab3EREVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 00:21:42 -0400
Date: Fri, 17 May 2013 00:46:13 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] memcg: update TODO list in Documentation
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>
References: <5195A41D.7050507@huawei.com>
In-Reply-To: <5195A41D.7050507@huawei.com> (from lizefan@huawei.com on Thu
	May 16 22:29:33 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1368769573.18069.254@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 10:29:33 PM, Li Zefan wrote:
> hugetlb cgroup has already been implemented.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>  Documentation/cgroups/memory.txt | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/cgroups/memory.txt  
> b/Documentation/cgroups/memory.txt
> index ddf4f93..327acec 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -834,10 +834,9 @@ Test:
> 
>  12. TODO
> 
> -1. Add support for accounting huge pages (as a separate controller)
> -2. Make per-cgroup scanner reclaim not-shared pages first
> -3. Teach controller to account for shared-pages
> -4. Start reclamation in the background when the limit is
> +1. Make per-cgroup scanner reclaim not-shared pages first
> +2. Teach controller to account for shared-pages
> +3. Start reclamation in the background when the limit is
>     not yet hit but the usage is getting closer
> 
>  Summary

Acked-by: Rob Landley <rob@landley.net>

If the memcg guys don't grab this, please send to trivial@kernel.org.

Rob