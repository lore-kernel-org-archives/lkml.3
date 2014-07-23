Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbaGWOJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:09:55 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61353 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbaGWOJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:09:54 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53CFC231.8090701@roeck-us.net>
Date: Wed, 23 Jul 2014 07:09:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, monstr@monstr.eu
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: Add comment for defines
References: <1406089658-4671-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1406089658-4671-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 09:27 PM, Nicholas Krause wrote:
> This adds a comment for and removes a fix me by labeling these
> defines as memory cache definitions.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>   arch/microblaze/include/asm/pvr.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/microblaze/include/asm/pvr.h b/arch/microblaze/include/asm/pvr.h
> index 4bbdb4c..441f3a0 100644
> --- a/arch/microblaze/include/asm/pvr.h
> +++ b/arch/microblaze/include/asm/pvr.h
> @@ -186,7 +186,7 @@ struct pvr_s {
>   #define PVR_DCACHE_USE_FSL(_pvr)	(_pvr.pvr[5] & PVR5_DCACHE_USE_FSL_MASK)
>   #define PVR_DCACHE_ALLOW_WR(_pvr) \
>   			(_pvr.pvr[5] & PVR5_DCACHE_ALLOW_WR_MASK)
> -/* FIXME two shifts on one line needs any comment */
> +/* memory caches */

"two shifts on one line needs any comment"

You are not providing the comment asked for. The FIXME requests a comment explaining
why the double shift is needed, not just a random comment like the one you provided
that doesn't explain anything.

Guenter

>   #define PVR_DCACHE_LINE_LEN(_pvr) \
>   		(1 << ((_pvr.pvr[5] & PVR5_DCACHE_LINE_LEN_MASK) >> 21))
>   #define PVR_DCACHE_BYTE_SIZE(_pvr) \
>

