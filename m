Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab3GOOCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:02:38 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:34054 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab3GOOCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:02:37 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 2/9] mm, hugetlb: trivial commenting fix
In-Reply-To: <1373881967-16153-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com> <1373881967-16153-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 15 Jul 2013 19:32:24 +0530
Message-ID: <877ggrkjkf.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071513-9574-0000-0000-000008B7AA0B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> The name of the mutex written in comment is wrong.
> Fix it.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
 
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index d87f70b..d21a33a 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -135,9 +135,9 @@ static inline struct hugepage_subpool *subpool_vma(struct vm_area_struct *vma)
>   *                    across the pages in a mapping.
>   *
>   * The region data structures are protected by a combination of the mmap_sem
> - * and the hugetlb_instantion_mutex.  To access or modify a region the caller
> + * and the hugetlb_instantiation_mutex.  To access or modify a region the caller
>   * must either hold the mmap_sem for write, or the mmap_sem for read and
> - * the hugetlb_instantiation mutex:
> + * the hugetlb_instantiation_mutex:
>   *
>   *	down_write(&mm->mmap_sem);
>   * or
> -- 
> 1.7.9.5

