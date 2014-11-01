Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbaKAFKm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 01:10:42 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33464 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbaKAFKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 01:10:41 -0400
Date: Sat, 1 Nov 2014 10:40:31 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Chen Weixiang <weixiangchen@gmail.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen Weixiang <weixiang.chen@gmail.com>,
        Aybuke Ozdemir <aybuke.147@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Nicolas Thery <nthery@gmail.com>, Greg Donald <gdonald@gmail.com>,
        Daniel Dodge <danieldodgese@gmail.com>,
        Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] staging: ft1000: "(foo*)" should be "(foo *)"
Message-ID: <20141101051031.GE3642@sudip-PC>
References: <1414810047-6975-1-git-send-email-weixiang.chen@gmail.com>
 <1414810047-6975-4-git-send-email-weixiang.chen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414810047-6975-4-git-send-email-weixiang.chen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 10:47:24AM +0800, Chen Weixiang wrote:
> Remove following code style error from ft1000/ft1000-usb/ft1000_debug.c:
> ERROR: "(foo*)" should be "(foo *)"
> 
again checkpatch gives total: 4 errors, 3 warnings, 16 lines checked.
this includes whitespace errors.

thanks
sudip

> Signed-off-by: Chen Weixiang <weixiang.chen@gmail.com>
> ---
>  drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
> index 02bfb3e..7bc05fe 100644
> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
> @@ -447,7 +447,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
>      switch (cmd) {
>      case IOCTL_REGISTER_CMD:
>              DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_REGISTER called\n");
> -            result = get_user(tempword, (__u16 __user*)argp);
> +            result = get_user(tempword, (__u16 __user *)argp);
>              if (result) {
>                  DEBUG("result = %d failed to get_user\n", result);
>                  break;
> @@ -652,7 +652,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
>                              }
>                              pmsg++;
>  				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
> -                           result = card_send_command(ft1000dev,(unsigned short*)dpram_data,total_len+2);
> +                           result = card_send_command(ft1000dev,(unsigned short *)dpram_data,total_len+2);
>  
>  
>                              ft1000dev->app_info[app_index].nTxMsg++;
> -- 
> 2.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
