Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934267Ab3E1Nqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:46:34 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:45038 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759083Ab3E1Nqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:46:32 -0400
Date: Tue, 28 May 2013 14:43:37 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8, part3 03/14] mm/ARM64: kill poison_init_mem()
Message-ID: <20130528134336.GA15546@arm.com>
References: <1369575522-26405-1-git-send-email-jiang.liu@huawei.com>
 <1369575522-26405-4-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369575522-26405-4-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 02:38:31PM +0100, Jiang Liu wrote:
> Use free_reserved_area() to poison initmem memory pages and kill
> poison_init_mem() on ARM64.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
