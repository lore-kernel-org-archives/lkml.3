Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab3LBUKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:10:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757052Ab3LBUKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:10:07 -0500
Date: Mon, 02 Dec 2013 15:09:55 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>
Message-ID: <1386014995-36kc4vmm-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1385624926-28883-8-git-send-email-iamjoonsoo.kim@lge.com>
References: <1385624926-28883-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1385624926-28883-8-git-send-email-iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 7/9] mm/rmap: use rmap_walk() in try_to_munlock()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 04:48:44PM +0900, Joonsoo Kim wrote:
> Now, we have an infrastructure in rmap_walk() to handle difference
> from variants of rmap traversing functions.
> 
> So, just use it in try_to_munlock().
> 
> In this patch, I change following things.
> 
> 1. remove some variants of rmap traversing functions.
> 	cf> try_to_unmap_ksm, try_to_unmap_anon, try_to_unmap_file
> 2. mechanical change to use rmap_walk() in try_to_munlock().
> 3. copy and paste comments.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
