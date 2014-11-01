Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbaKAFM5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 01:12:57 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:58933 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaKAFM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 01:12:56 -0400
Date: Sat, 1 Nov 2014 10:42:47 +0530
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
Subject: Re: [PATCH v2 5/6] staging: ft1000: else should follow close brace
 '}'
Message-ID: <20141101051247.GF3642@sudip-PC>
References: <1414810047-6975-1-git-send-email-weixiang.chen@gmail.com>
 <1414810047-6975-6-git-send-email-weixiang.chen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414810047-6975-6-git-send-email-weixiang.chen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 10:47:26AM +0800, Chen Weixiang wrote:
> Remove code style error from ft1000/ft1000-pcmcia/ft1000_hw.c:
> ERROR: else should follow close brace '}'
> 
from checkpatch:

total: 1 errors, 2 warnings, 44 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

      patch has style problems, please review.

thanks
sudip

> Signed-off-by: Chen Weixiang <weixiang.chen@gmail.com>
> ---
>  drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
> index db194bc..48c1ef2 100644
> --- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
> +++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
> @@ -595,8 +595,7 @@ static void ft1000_hbchk(u_long data)
>  		if (tempword != ho) {
>  			if (info->AsicID == ELECTRABUZZ_ID) {
>  				tempword = ft1000_read_dpram(dev, FT1000_HI_HO);
> -			}
> -			else {
> +			} else {
>  				tempword = ntohs(ft1000_read_dpram_mag_16(dev, FT1000_MAG_HI_HO, FT1000_MAG_HI_HO_INDX));
>  			}
>  		}
> @@ -715,15 +714,13 @@ static void ft1000_hbchk(u_long data)
>  		if (tempword != hi) {
>  			if (info->AsicID == ELECTRABUZZ_ID) {
>  				ft1000_write_dpram(dev, FT1000_HI_HO, hi);
> -			}
> -			else {
> +			} else {
>  				ft1000_write_dpram_mag_16(dev, FT1000_MAG_HI_HO, hi_mag, FT1000_MAG_HI_HO_INDX);
>  			}
>  
>  			if (info->AsicID == ELECTRABUZZ_ID) {
>  				tempword = ft1000_read_dpram(dev, FT1000_HI_HO);
> -			}
> -			else {
> +			} else {
>  				tempword = ntohs(ft1000_read_dpram_mag_16(dev, FT1000_MAG_HI_HO, FT1000_MAG_HI_HO_INDX));
>  			}
>  
> @@ -994,8 +991,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
>  
>      if (info->AsicID == ELECTRABUZZ_ID) {
>          tempword = FT1000_DPRAM_RX_BASE+2;
> -    }
> -    else {
> +    } else {
>          tempword = FT1000_DPRAM_MAG_RX_BASE;
>      }
>      if (ft1000_receive_cmd(dev, &cmdbuffer[0], MAX_CMD_SQSIZE, &tempword)) {
> @@ -1075,8 +1071,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
>  					info->ConTm = 0;
>  				}
>  			}
> -            }
> -            else {
> +            } else {
>                  DEBUG(1, "Media is down\n");
>                  if (info->mediastate == 1) {
>                      info->mediastate = 0;
> -- 
> 2.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
