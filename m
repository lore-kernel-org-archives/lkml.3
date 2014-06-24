Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaFXWoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:44:38 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:51550 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaFXWog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:44:36 -0400
Date: Tue, 24 Jun 2014 15:44:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wang Sheng-Hui <shhuiw@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Andi Kleen <ak@linux.intel.com>,
        Vladimir Cernov <gg.kaspersky@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH] mm: update the description for madvise_remove
In-Reply-To: <53A9116B.9030004@gmail.com>
Message-ID: <alpine.DEB.2.02.1406241542040.29176@chino.kir.corp.google.com>
References: <53A9116B.9030004@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Wang Sheng-Hui wrote:

> 
> Currently, we have more filesystems supporting fallocate, e.g
> ext4/btrfs. Remove the outdated comment for madvise_remove.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  mm/madvise.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index a402f8f..0938b30 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -292,9 +292,6 @@ static long madvise_dontneed(struct vm_area_struct *vma,
>  /*
>   * Application wants to free up the pages and associated backing store.
>   * This is effectively punching a hole into the middle of a file.
> - *
> - * NOTE: Currently, only shmfs/tmpfs is supported for this operation.
> - * Other filesystems return -ENOSYS.
>   */
>  static long madvise_remove(struct vm_area_struct *vma,
>                                 struct vm_area_struct **prev,

[For those without context: this patch has been merged into the -mm tree.]

This reference also exists in the man-page for madvise(2), are you 
planning on removing it as well?
