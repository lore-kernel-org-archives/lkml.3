Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935568Ab3DJVtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:49:11 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:46363 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759399Ab3DJVtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:49:09 -0400
Date: Wed, 10 Apr 2013 14:49:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH v5 2/3] fix hugetlb memory check in
 vma_dump_size()
In-Reply-To: <1365610669-16625-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.DEB.2.02.1304101448390.1526@chino.kir.corp.google.com>
References: <1365610669-16625-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1365610669-16625-3-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Apr 2013, Naoya Horiguchi wrote:

> Documentation/filesystems/proc.txt says about coredump_filter bitmask,
> 
>   Note bit 0-4 doesn't effect any hugetlb memory. hugetlb memory are only
>   effected by bit 5-6.
> 
> However current code can go into the subsequent flag checks of bit 0-4
> for vma(VM_HUGETLB). So this patch inserts 'return' and makes it work
> as written in the document.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: stable@vger.kernel.org

Acked-by: David Rientjes <rientjes@google.com>

Stable for 2.6.34+.
