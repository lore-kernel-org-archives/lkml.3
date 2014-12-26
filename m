Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaLZO3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:29:52 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42118 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaLZO3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:29:50 -0500
Date: Fri, 26 Dec 2014 06:29:46 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix multiple coding style issues
Message-ID: <20141226142946.GA28213@newt.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1419597539-21254-1-git-send-email-kuleshovmail@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419597539-21254-1-git-send-email-kuleshovmail@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander,

On Fri, Dec 26, 2014 at 06:38:59PM +0600, Alexander Kuleshov wrote:

Your description needs to be more specific than just "coding style
fixes".  What type of problems did you fix?  How did you find them?

(more inline...)

> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
> ---
>  arch/x86/boot/header.S | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
> index 16ef025..75f016b 100644
> --- a/arch/x86/boot/header.S
> +++ b/arch/x86/boot/header.S
> @@ -211,7 +211,8 @@ section_table:
>  	.long	0				# PointerToLineNumbers
>  	.word	0				# NumberOfRelocations
>  	.word	0				# NumberOfLineNumbers
> -	.long	0x60500020			# Characteristics (section flags)
> +	.long	0x60500020			# Characteristics
> +						# (section flags)
>  
>  	#
>  	# The EFI application loader requires a relocation section
> @@ -229,7 +230,8 @@ section_table:
>  	.long	0				# PointerToLineNumbers
>  	.word	0				# NumberOfRelocations
>  	.word	0				# NumberOfLineNumbers
> -	.long	0x42100040			# Characteristics (section flags)
> +	.long	0x42100040			# Characteristics
> +						# (section flags)
>  
>  	#
>  	# The offset & size fields are filled in by build.c.
> @@ -247,7 +249,8 @@ section_table:
>  	.long	0				# PointerToLineNumbers
>  	.word	0				# NumberOfRelocations
>  	.word	0				# NumberOfLineNumbers
> -	.long	0x60500020			# Characteristics (section flags)
> +	.long	0x60500020			# Characteristics
> +						# (section flags)
>  
>  	#
>  	# The offset & size fields are filled in by build.c.
> @@ -266,7 +269,8 @@ section_table:
>  	.long	0				# PointerToLineNumbers
>  	.word	0				# NumberOfRelocations
>  	.word	0				# NumberOfLineNumbers
> -	.long	0xc8000080			# Characteristics (section flags)
> +	.long	0xc8000080			# Characteristics
> +						# (section flags)
>  
>  #endif /* CONFIG_EFI_STUB */
>  
> @@ -426,7 +430,8 @@ cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
>                                                  #added with boot protocol
>                                                  #version 2.06
>  
> -hardware_subarch:	.long 0			# subarchitecture, added with 2.07
> +hardware_subarch:	.long 0			# subarchitecture,
> +						# added with 2.07
>  						# default to 0 for normal x86 PC
>  
>  hardware_subarch_data:	.quad 0
> -- 
> 2.2.1.202.g98acd41
> 

It looks like your fixes are for lines being over 80 characters.  While
it is preferrable that lines be less than 80 characters it is still
acceptable if they are longer.

If you are looking for things to fix I suggest looking in the
drivers/staging directory.  There are lots of things that need to be
fixed in there.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
- Jeremiah Mahler
