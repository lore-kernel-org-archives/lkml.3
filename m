Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3EKUFn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 16:05:43 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:59090 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3EKUFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 16:05:41 -0400
Message-ID: <518EA49F.50206@cogentembedded.com>
Date: Sun, 12 May 2013 00:05:51 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6, part3 15/16] mm: report available pages as "MemTotal"
 for each NUMA node
References: <1368293689-16410-1-git-send-email-jiang.liu@huawei.com> <1368293689-16410-16-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1368293689-16410-16-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/11/2013 09:34 PM, Jiang Liu wrote:

    I've noticed a small typo in the changelog.

> As reported by https://bugzilla.kernel.org/show_bug.cgi?id=53501,
> "MemTotal" from /proc/meminfo means memory pages managed by the buddy
> system (managed_pages), but "MemTotal" from /sys/.../node/nodex/meminfo
> means phsical pages present (present_pages) within the NUMA node.

     s/phsical/physical/

> There's a difference between managed_pages and present_pages due to
> bootmem allocator and reserved pages.
>
> And Documentation/filesystems/proc.txt says
>      MemTotal: Total usable ram (i.e. physical ram minus a few reserved
>                bits and the kernel binary code)
>
> So change /sys/.../node/nodex/meminfo to report available pages within
> the node as "MemTotal".
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Reported-by: sworddragon2@aol.com
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org

WBR, Sergei

