Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbaKAFOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 01:14:00 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54613 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaKAFN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 01:13:58 -0400
Date: Sat, 1 Nov 2014 10:43:49 +0530
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
Subject: Re: [PATCH v2 6/6] staging: ft1000: space required after that ','
Message-ID: <20141101051349.GG3642@sudip-PC>
References: <1414810047-6975-1-git-send-email-weixiang.chen@gmail.com>
 <1414810047-6975-7-git-send-email-weixiang.chen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414810047-6975-7-git-send-email-weixiang.chen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 10:47:27AM +0800, Chen Weixiang wrote:
> Remove following code style error from ft1000/ft1000-usb/ft1000_debug.c:
> ERROR: space required after that ',' (ctx:VxV)
> 
from checkpatch:
total: 11 errors, 15 warnings, 46 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

      patch has style problems, please review.

thanks
sudip

> Signed-off-by: Chen Weixiang <weixiang.chen@gmail.com>
> ---
>  drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
> index 7bc05fe..5e290e9 100644
> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
> @@ -301,7 +301,7 @@ static int ft1000_open(struct inode *inode, struct file *file)
>  {
>  	struct ft1000_info *info;
>  	struct ft1000_usb *dev = (struct ft1000_usb *)inode->i_private;
> -    int i,num;
> +    int i, num;
>  
>      DEBUG("%s called\n", __func__);
>      num = (MINOR(inode->i_rdev) & 0xf);
> @@ -419,12 +419,16 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
>      struct timeval tv;
>  	struct IOCTL_GET_VER get_ver_data;
>  	struct IOCTL_GET_DSP_STAT get_stat_data;
> -    u8 ConnectionMsg[] = {0x00,0x44,0x10,0x20,0x80,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x93,0x64,
> -                          0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x0a,
> -                          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
> -                          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x12,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
> -                          0x00,0x00,0x02,0x37,0x00,0x00,0x00,0x08,0x00,0x00,0x00,0x01,0x00,0x01,0x7f,0x00,
> -                          0x00,0x01,0x00,0x00};
> +    u8 ConnectionMsg[] = {0x00, 0x44, 0x10, 0x20, 0x80, 0x00, 0x00, 0x00, 0x00,
> +                          0x00, 0x03, 0x00, 0x00, 0x00, 0x93, 0x64, 0x00, 0x00,
> +                          0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +                          0x05, 0x00, 0x00, 0x00, 0x0a, 0x00, 0x00, 0x00, 0x00,
> +                          0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00,
> +                          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +                          0x00, 0x12, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +                          0x00, 0x00, 0x00, 0x02, 0x37, 0x00, 0x00, 0x00, 0x08,
> +                          0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x7f, 0x00, 0x00,
> +                          0x01, 0x00, 0x00};
>  
>      unsigned short ledStat = 0;
>      unsigned short conStat = 0;
> @@ -475,7 +479,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
>              break;
>          }
>  
> -        DEBUG("FT1000:ft1000_ioctl:driver version = 0x%x\n",(unsigned int)get_ver_data.drv_ver);
> +        DEBUG("FT1000:ft1000_ioctl:driver version = 0x%x\n", (unsigned int)get_ver_data.drv_ver);
>  
>          break;
>      case IOCTL_CONNECT:
> @@ -652,7 +656,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
>                              }
>                              pmsg++;
>  				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
> -                           result = card_send_command(ft1000dev,(unsigned short *)dpram_data,total_len+2);
> +                           result = card_send_command(ft1000dev, (unsigned short *)dpram_data, total_len+2);
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
