Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaJSN1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 09:27:11 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:35088 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaJSN1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 09:27:07 -0400
Date: Sun, 19 Oct 2014 15:27:00 +0200
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: Chen Weixiang <weixiangchen@gmail.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen Weixiang <weixiang.chen@gmail.com>,
        Greg Donald <gdonald@gmail.com>, Chen Gang <gang.chen.5i5j@gmail.com>,
        Artem Fetishev <wwctrsrx@gmail.com>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] staging: ft1000: space required after that ','
Message-ID: <20141019132700.GA3632@t400>
References: <1413723590-19690-1-git-send-email-weixiang.chen@gmail.com>
 <1413723590-19690-4-git-send-email-weixiang.chen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413723590-19690-4-git-send-email-weixiang.chen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19, Chen Weixiang wrote:
> Remove code style error from ft1000/ft1000-usb/ft1000_debug.c:
> ERROR: space required after that ',' (ctx:VxV)
> 
> Signed-off-by: Chen Weixiang <weixiang.chen@gmail.com>
> ---
>  drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
> index 47dc0c0..183128c 100644
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
> @@ -419,12 +419,12 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
>      struct timeval tv;
>  	struct IOCTL_GET_VER get_ver_data;
>  	struct IOCTL_GET_DSP_STAT get_stat_data;
> -    u8 ConnectionMsg[] = {0x00,0x44,0x10,0x20,0x80,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x93,0x64,
> -                          0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x0a,
> -                          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
> -                          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x12,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
> -                          0x00,0x00,0x02,0x37,0x00,0x00,0x00,0x08,0x00,0x00,0x00,0x01,0x00,0x01,0x7f,0x00,
> -                          0x00,0x01,0x00,0x00};
> +    u8 ConnectionMsg[] = {0x00, 0x44, 0x10, 0x20, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x93, 0x64,
> +                          0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x0a,
> +                          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +                          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +                          0x00, 0x00, 0x02, 0x37, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x7f, 0x00,
> +                          0x00, 0x01, 0x00, 0x00};

Nice, however it still violates the 80 characters a line rule. Please
redo this patch.

You can use the checkpatch to validate each patch befor sending and
generally you should aim towards sending patches with 0 checkpatch
warnings/errors. There is also the --strict option to the checkpatch
which is also worth uisng as some kernel subsystems use it as a default.

Thanks,
Konrad
  
>      unsigned short ledStat = 0;
>      unsigned short conStat = 0;
> @@ -475,7 +475,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
>              break;
>          }
>  
> -        DEBUG("FT1000:ft1000_ioctl:driver version = 0x%x\n",(unsigned int)get_ver_data.drv_ver);
> +        DEBUG("FT1000:ft1000_ioctl:driver version = 0x%x\n", (unsigned int)get_ver_data.drv_ver);
>  
>          break;
>      case IOCTL_CONNECT:
> @@ -652,7 +652,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
>                              }
>                              pmsg++;
>  				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
> -                           result = card_send_command(ft1000dev,(unsigned short*)dpram_data,total_len+2);
> +                           result = card_send_command(ft1000dev, (unsigned short*)dpram_data, total_len+2);
>  
>  
>                              ft1000dev->app_info[app_index].nTxMsg++;
> -- 
> 2.1.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
