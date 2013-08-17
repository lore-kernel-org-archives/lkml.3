Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab3HQBYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 21:24:03 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49499 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab3HQBYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 21:24:00 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-70-520ed0ae3082
Date: Sat, 17 Aug 2013 10:24:22 +0900
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Richard Laager <rlaager@wiktel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chanho Min <chanho.min@lge.com>,
        Richard Yao <ryao@gentoo.org>, linux-kernel@vger.kernel.org,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com
Subject: Re: [PATCH] Correct the LZ4 license
Message-ID: <20130817012422.GA7038@hulk>
References: <520D8C4C.7000704@gentoo.org>
 <1376689529-15080-1-git-send-email-rlaager@wiktel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376689529-15080-1-git-send-email-rlaager@wiktel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 04:45:29PM -0500, Richard Laager wrote:
> The LZ4 code is listed as using the "BSD 2-Clause License".
> 
> Signed-off-by: Richard Laager <rlaager@wiktel.com>
> ---
>  lib/lz4/lz4_compress.c   |    4 ++--
>  lib/lz4/lz4_decompress.c |    6 +++---
>  lib/lz4/lz4hc_compress.c |    4 ++--
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/lz4/lz4_compress.c b/lib/lz4/lz4_compress.c
> index fd94058..28321d8 100644
> --- a/lib/lz4/lz4_compress.c
> +++ b/lib/lz4/lz4_compress.c
> @@ -437,7 +437,7 @@ int lz4_compress(const unsigned char *src, size_t src_len,
>  exit:
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(lz4_compress);
> +EXPORT_SYMBOL(lz4_compress);
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_DESCRIPTION("LZ4 compressor");
> diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
> index d3414ea..411be80 100644
> --- a/lib/lz4/lz4_decompress.c
> +++ b/lib/lz4/lz4_decompress.c
> @@ -299,7 +299,7 @@ exit_0:
>  	return ret;
>  }
>  #ifndef STATIC
> -EXPORT_SYMBOL_GPL(lz4_decompress);
> +EXPORT_SYMBOL(lz4_decompress);
>  #endif
>  
>  int lz4_decompress_unknownoutputsize(const char *src, size_t src_len,
> @@ -319,8 +319,8 @@ exit_0:
>  	return ret;
>  }
>  #ifndef STATIC
> -EXPORT_SYMBOL_GPL(lz4_decompress_unknownoutputsize);
> +EXPORT_SYMBOL(lz4_decompress_unknownoutputsize);
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_DESCRIPTION("LZ4 Decompressor");
>  #endif
> diff --git a/lib/lz4/lz4hc_compress.c b/lib/lz4/lz4hc_compress.c
> index eb1a74f..f344f76 100644
> --- a/lib/lz4/lz4hc_compress.c
> +++ b/lib/lz4/lz4hc_compress.c
> @@ -533,7 +533,7 @@ int lz4hc_compress(const unsigned char *src, size_t src_len,
>  exit:
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(lz4hc_compress);
> +EXPORT_SYMBOL(lz4hc_compress);
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_DESCRIPTION("LZ4HC compressor");

Acked-by: Kyungsik Lee <kyungsik.lee@lge.com>

Thanks,
Kyungsik
