Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab3DZUUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 16:20:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43051 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757751Ab3DZUUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 16:20:51 -0400
Message-ID: <517AE16A.8090602@zytor.com>
Date: Fri, 26 Apr 2013 13:19:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Kyungsik Lee <kyungsik.lee@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org, hyojun.im@lge.com,
        chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, Borislav Petkov <bp@alien8.de>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>
Subject: Re: [PATCH -next] x86, doc: Add LZ4 magic number for the new compression
References: <1366952933-31331-1-git-send-email-kyungsik.lee@lge.com>
In-Reply-To: <1366952933-31331-1-git-send-email-kyungsik.lee@lge.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 10:08 PM, Kyungsik Lee wrote:
> Documentation/x86/boot.txt is updated to list the LZ4 magic number.
> This LZ4 magic number is used for the new compression format.
> 
> Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Florian Fainelli <florian@openwrt.org>
> Cc: Yann Collet <yann.collet.73@gmail.com>
> ---
>  Documentation/x86/boot.txt | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
> index 3840b6f..fc66d42 100644
> --- a/Documentation/x86/boot.txt
> +++ b/Documentation/x86/boot.txt
> @@ -657,9 +657,10 @@ Protocol:	2.08+
>    uncompressed data should be determined using the standard magic
>    numbers.  The currently supported compression formats are gzip
>    (magic numbers 1F 8B or 1F 9E), bzip2 (magic number 42 5A), LZMA
> -  (magic number 5D 00), and XZ (magic number FD 37).  The uncompressed
> -  payload is currently always ELF (magic number 7F 45 4C 46).
> -  
> +  (magic number 5D 00), XZ (magic number FD 37), and LZ4 (magic number
> +  02 21).  The uncompressed payload is currently always ELF (magic
> +  number 7F 45 4C 46).
> +
>  Field name:	payload_length
>  Type:		read
>  Offset/size:	0x24c/4
> 

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

