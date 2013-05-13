Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab3EMJTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:19:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab3EMJTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:19:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1368293689-16410-15-git-send-email-jiang.liu@huawei.com>
References: <1368293689-16410-15-git-send-email-jiang.liu@huawei.com> <1368293689-16410-1-git-send-email-jiang.liu@huawei.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Mark Salter <msalter@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6, part3 14/16] mm: concentrate modification of totalram_pages into the mm core
Date: Mon, 13 May 2013 10:19:11 +0100
Message-ID: <15411.1368436751@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiang Liu <liuj97@gmail.com> wrote:

> Concentrate code to modify totalram_pages into the mm core, so the arch
> memory initialized code doesn't need to take care of it. With these
> changes applied, only following functions from mm core modify global
> variable totalram_pages:
> free_bootmem_late(), free_all_bootmem(), free_all_bootmem_node(),
> adjust_managed_page_count().
> 
> With this patch applied, it will be much more easier for us to keep
> totalram_pages and zone->managed_pages in consistence.

I like it.

Acked-by: David Howells <dhowells@redhat.com>
