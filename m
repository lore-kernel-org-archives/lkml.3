Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3BVDoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 22:44:18 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:57700 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab3BVDoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 22:44:17 -0500
Message-ID: <5126E987.7020809@gmail.com>
Date: Fri, 22 Feb 2013 11:44:07 +0800
From: Ric Mason <ric.masonn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/7] ksm: responses to NUMA review
References: <alpine.LNX.2.00.1302210013120.17843@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1302210013120.17843@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 04:17 PM, Hugh Dickins wrote:
> Here's a second KSM series, based on mmotm 2013-02-19-17-20: partly in
> response to Mel's review feedback, partly fixes to issues that I found
> myself in doing more review and testing.  None of the issues fixed are
> truly show-stoppers, though I would prefer them fixed sooner than later.

Do you have any ideas ksm support page cache and tmpfs?

>
> 1 ksm: add some comments
> 2 ksm: treat unstable nid like in stable tree
> 3 ksm: shrink 32-bit rmap_item back to 32 bytes
> 4 mm,ksm: FOLL_MIGRATION do migration_entry_wait
> 5 mm,ksm: swapoff might need to copy
> 6 mm: cleanup "swapcache" in do_swap_page
> 7 ksm: allocate roots when needed
>
>   Documentation/vm/ksm.txt |   16 +++-
>   include/linux/mm.h       |    1
>   mm/ksm.c                 |  137 +++++++++++++++++++++++--------------
>   mm/memory.c              |   38 +++++++---
>   mm/swapfile.c            |   15 +++-
>   5 files changed, 140 insertions(+), 67 deletions(-)
>
> Thanks,
> Hugh
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

