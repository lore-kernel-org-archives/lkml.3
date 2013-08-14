Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab3HNAMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 20:12:33 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46480 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101Ab3HNAMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 20:12:31 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-d8-520acb6e252a
Date: Wed, 14 Aug 2013 09:12:37 +0900
From: Minchan Kim <minchan@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, k.kozlowski@samsung.com,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, guz.fnst@cn.fujitsu.com,
        Benjamin LaHaise <bcrl@kvack.org>, Dave Hansen <dave.hansen@intel.com>,
        lliubbo@gmail.com, aquini@redhat.com, Rik van Riel <riel@redhat.com>
Subject: Re: [RFC 0/3] Pin page control subsystem
Message-ID: <20130814001236.GC2271@bbox>
References: <1376377502-28207-1-git-send-email-minchan@kernel.org>
 <00000140787b6191-ae3f2eb1-515e-48a1-8e64-502772af4700-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140787b6191-ae3f2eb1-515e-48a1-8e64-502772af4700-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Christoph,

On Tue, Aug 13, 2013 at 04:21:30PM +0000, Christoph Lameter wrote:
> On Tue, 13 Aug 2013, Minchan Kim wrote:
> 
> > VM sometime want to migrate and/or reclaim pages for CMA, memory-hotplug,
> > THP and so on but at the moment, it could handle only userspace pages
> > so if above example subsystem have pinned a some page in a range VM want
> > to migrate, migration is failed so above exmaple couldn't work well.
> 
> Dont we have the mmu_notifiers that could help in that case? You could get
> a callback which could prepare the pages for migration?

Now I'm not familiar with mmu_notifier so please could you elaborate it
a bit for me to dive into that? 

Thanks!

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
