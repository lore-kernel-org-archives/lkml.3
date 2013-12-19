Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3LSQGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:06:43 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:35812 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab3LSQGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:06:41 -0500
MIME-Version: 1.0
In-Reply-To: <1384018214-28064-1-git-send-email-mickael.maison@gmail.com>
References: <1384018214-28064-1-git-send-email-mickael.maison@gmail.com>
From: Mickael Maison <mickael.maison@gmail.com>
Date: Thu, 19 Dec 2013 17:06:20 +0100
Message-ID: <CA+OCqnbstyRxTswbgLAt450X5Mu+zk7tbWsy=frNYaDyM1F3kw@mail.gmail.com>
Subject: Re: [PATCH] CRYPTO: async_tx: Fixed a couple of typos
To: dan.j.williams@intel.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Are you interested in patches fixing typos ? I've found a bunch more
under /crypto but as I haven't received any responses on this one, I'm
not sure I should send new patches in.
This was my first patch so if I'm doing anything wrong, please tell me !

Mickael

On Sat, Nov 9, 2013 at 6:30 PM, Mickael Maison <mickael.maison@gmail.com> wrote:
> Fixed 2 typos in async_xor.c
> ---
>  crypto/async_tx/async_xor.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
> index 8ade0a0..bcaa1e9 100644
> --- a/crypto/async_tx/async_xor.c
> +++ b/crypto/async_tx/async_xor.c
> @@ -48,7 +48,7 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
>         int xor_src_cnt = 0;
>         dma_addr_t dma_dest;
>
> -       /* map the dest bidrectional in case it is re-used as a source */
> +       /* map the dest bidirectional in case it is re-used as a source */
>         dma_dest = dma_map_page(dma->dev, dest, offset, len, DMA_BIDIRECTIONAL);
>         for (i = 0; i < src_cnt; i++) {
>                 /* only map the dest once */
> @@ -175,7 +175,7 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
>   * xor_blocks always uses the dest as a source so the
>   * ASYNC_TX_XOR_ZERO_DST flag must be set to not include dest data in
>   * the calculation.  The assumption with dma eninges is that they only
> - * use the destination buffer as a source when it is explicity specified
> + * use the destination buffer as a source when it is explicitly specified
>   * in the source list.
>   *
>   * src_list note: if the dest is also a source it must be at index zero.
> --
> 1.7.10.4
>
