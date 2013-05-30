Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967691Ab3E3HCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:02:48 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:37573 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967563Ab3E3HCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:02:39 -0400
Date: Thu, 30 May 2013 16:02:33 +0900
From: Tejun Heo <tj@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        "David S. Miller" <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH, v2 11/13] mm: kill free_all_bootmem_node()
Message-ID: <20130530070226.GC22604@mtj.dyndns.org>
References: <1369838692-26860-1-git-send-email-jiang.liu@huawei.com>
 <1369838692-26860-12-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369838692-26860-12-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 10:44:50PM +0800, Jiang Liu wrote:
> Now nobody makes use of free_all_bootmem_node(), kill it.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
