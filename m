Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3AYXGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 18:06:09 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:44345 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab3AYXGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 18:06:07 -0500
Message-ID: <51030FDC.40504@gmail.com>
Date: Fri, 25 Jan 2013 15:06:04 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@list.infradead.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 07/19] scripts/sortextable: silence script output
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359123276-15833-8-git-send-email-arnd@arndb.de>
In-Reply-To: <1359123276-15833-8-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 06:14 AM, Arnd Bergmann wrote:
> The exception table sorter outputs one line every time
> it gets called, e.g. 'sort done marker at 66dc00', which
> is slightly annoying when doing 'make -s' which is otherwise
> completely silent. Since that output is not helpful to
> most people building the kernel, turn it off by default.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: David Daney <david.daney@cavium.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>

Leaving that enabled was an oversight.  Thanks for fixing it...

Acked-by: David Daney <david.daney@cavium.com>


> ---
>   scripts/sortextable.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/sortextable.h b/scripts/sortextable.h
> index e4fd45b..f5eb43d 100644
> --- a/scripts/sortextable.h
> +++ b/scripts/sortextable.h
> @@ -182,7 +182,7 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, table_sort_t custom_sort)
>   		_r(&sort_needed_sym->st_value) -
>   		_r(&sort_needed_sec->sh_addr);
>
> -#if 1
> +#if 0
>   	printf("sort done marker at %lx\n",
>   	       (unsigned long)((char *)sort_done_location - (char *)ehdr));
>   #endif
>

