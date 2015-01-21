Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbbAUAwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:52:16 -0500
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:56952 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614AbbAUAwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:52:15 -0500
Date: Tue, 20 Jan 2015 18:52:13 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Kim Phillips <kim.phillips@freescale.com>
cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/slub: fix typo
In-Reply-To: <20150120140142.cd2e32d83d66459562bd1717@freescale.com>
Message-ID: <alpine.DEB.2.11.1501201851300.10932@gentwo.org>
References: <20150120140142.cd2e32d83d66459562bd1717@freescale.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Christoph Lameter <cl@linux.com>

On Tue, 20 Jan 2015, Kim Phillips wrote:

>
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> ---
>  mm/slub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index fe376fe..a64cc1b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2512,7 +2512,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_node_trace);
>  #endif
>
>  /*
> - * Slow patch handling. This may still be called frequently since objects
> + * Slow path handling. This may still be called frequently since objects
>   * have a longer lifetime than the cpu slabs in most processing loads.
>   *
>   * So we still attempt to reduce cache line usage. Just take the slab
>
