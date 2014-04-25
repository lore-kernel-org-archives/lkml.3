Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaDYNml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:42:41 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:59174 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaDYNmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:42:39 -0400
Message-ID: <535A664B.3000805@linux.com>
Date: Fri, 25 Apr 2014 15:42:35 +0200
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Nicolas Del Piano <ndel314@gmail.com>, gregkh@linuxfoundation.org
CC: aaro.koskinen@iki.fi, devendra.aaru@gmail.com, raluca.oncioiu91@gmail.com,
        david.daney@cavium.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: octeon-usb: fixed a macro coding style issue
References: <1398433233-2749-1-git-send-email-ndel314@gmail.com>
In-Reply-To: <1398433233-2749-1-git-send-email-ndel314@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/25/2014 03:40 PM, Nicolas Del Piano wrote:
> Fixed a coding style error, macros with comples values should be enclosed in parenthesis.
> 
> Signed-off-by: Nicolas Del Piano <ndel314@gmail.com>
> ---
>  drivers/staging/octeon-usb/octeon-hcd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
> index 8b8ce72..475ecc4 100644
> --- a/drivers/staging/octeon-usb/octeon-hcd.c
> +++ b/drivers/staging/octeon-usb/octeon-hcd.c
> @@ -246,7 +246,7 @@ enum cvmx_usb_pipe_flags {
>  };
> 
>  /* Normal prefetch that use the pref instruction. */
> -#define CVMX_PREFETCH(address, offset) asm volatile ("pref %[type], %[off](%[rbase])" : : [rbase] "d" (address), [off] "I" (offset), [type] "n" (0))
> +#define (CVMX_PREFETCH(address, offset) asm volatile ("pref %[type], %[off](%[rbase])" : : [rbase] "d" (address), [off] "I" (offset), [type] "n" (0)))

Not that way around! :-)

The parantheses should be around the code block not the
name block.

-- 
Regards,
Levente Kurusa
PGP: 4EF5D641
