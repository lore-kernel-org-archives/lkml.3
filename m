Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaFGN4Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 09:56:16 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:47193 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbaFGN4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 09:56:15 -0400
Message-ID: <539319fd.22abb60a.05d2.70c7@mx.google.com>
Date: Sat, 07 Jun 2014 08:56:08 -0500
Subject: Re: [PATCH 1/1] mm/zswap.c: add __init to zswap_entry_cache_destroy
From: Seth Jennings <sjennings@variantweb.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s57DuPwY006346


On Jun 7, 2014 6:08 AM, Fabian Frederick <fabf@skynet.be> wrote:
>
> zswap_entry_cache_destroy is only called by __init init_zswap 
>
> This patch also fixes function name 
> zswap_entry_cache_ s/destory/destroy

Thanks for theÂ  improvement â˜º

Acked-by <sjennings@variantweb.net>

>
> Cc: Seth Jennings <sjennings@variantweb.net> 
> Cc: linux-mm@kvack.org 
> Cc: Andrew Morton <akpm@linux-foundation.org> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be> 
> --- 
> mm/zswap.c | 4 ++-- 
> 1 file changed, 2 insertions(+), 2 deletions(-) 
>
> diff --git a/mm/zswap.c b/mm/zswap.c 
> index aeaef0f..ab7fa0f 100644 
> --- a/mm/zswap.c 
> +++ b/mm/zswap.c 
> @@ -207,7 +207,7 @@ static int zswap_entry_cache_create(void) 
> return zswap_entry_cache == NULL; 
> } 
>
> -static void zswap_entry_cache_destory(void) 
> +static void __init zswap_entry_cache_destroy(void) 
> { 
> kmem_cache_destroy(zswap_entry_cache); 
> } 
> @@ -926,7 +926,7 @@ static int __init init_zswap(void) 
> pcpufail: 
> zswap_comp_exit(); 
> compfail: 
> - zswap_entry_cache_destory(); 
> + zswap_entry_cache_destroy(); 
> cachefail: 
> zbud_destroy_pool(zswap_pool); 
> error: 
> -- 
> 1.9.1 
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
