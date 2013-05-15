Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046Ab3EOSKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 14:10:55 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:56822 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab3EOSKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 14:10:53 -0400
MIME-Version: 1.0
In-Reply-To: <1368637812-7329-1-git-send-email-sanweidaying@gmail.com>
References: <1368637812-7329-1-git-send-email-sanweidaying@gmail.com>
Date: Wed, 15 May 2013 21:10:51 +0300
X-Google-Sender-Auth: D3bzAd1W8hxviHwUCedpQbBWsuM
Message-ID: <CAOJsxLFEP1VvNib2ORWE+CSszCo9YGEiS0d946Fgs_22yfeEOQ@mail.gmail.com>
Subject: Re: [PATCH] mm, slab: corrected the comment 'kmem_cache_alloc' to 'slab_alloc_node'
From: Pekka Enberg <penberg@kernel.org>
To: Zhouping Liu <sanweidaying@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Zhouping Liu <zliu@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 8:10 PM, Zhouping Liu <sanweidaying@gmail.com> wrote:
> From: Zhouping Liu <zliu@redhat.com>
>
> commit 48356303ff(mm, slab: Rename __cache_alloc() -> slab_alloc())
> forgot to update the comment 'kmem_cache_alloc' to 'slab_alloc_node'.
>
> Signed-off-by: Zhouping Liu <zliu@redhat.com>
> ---
>  mm/slab.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/slab.c b/mm/slab.c
> index 8ccd296..8efb5f7 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3339,7 +3339,7 @@ done:
>  }
>
>  /**
> - * kmem_cache_alloc_node - Allocate an object on the specified node
> + * slab_alloc_node - Allocate an object on the specified node
>   * @cachep: The cache to allocate from.
>   * @flags: See kmalloc().
>   * @nodeid: node number of the target node.

The point of the comment is to document kernel API and whereas
slab_alloc_node() is internal to the slab allocator. Can you please
just move it on top of kmem_cache_alloc_node() definition in the same
file?

                        Pekka
