Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab3LGIGs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 03:06:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45305 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab3LGIGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 03:06:47 -0500
Date: Sat, 7 Dec 2013 11:06:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gary Rookard <garyrookard@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        lisa@xenapiadmin.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] Staging: bcm: DDRInit: replaced C99 comments.
Message-ID: <20131207080644.GL28413@mwanda>
References: <1386391955-11713-1-git-send-email-garyrookard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386391955-11713-1-git-send-email-garyrookard@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 11:52:35PM -0500, Gary Rookard wrote:
> This is the fifth patch of a series.
> 
> Signed-off-by: Gary Alan Rookard <garyrookard@gmail.com>
> ---
> On branch staging-next
>  drivers/staging/bcm/DDRInit.c | 270 +++++++++++++++++++++---------------------
>  1 file changed, 135 insertions(+), 135 deletions(-)
> 
> diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
> index cb4dd53..1a08b17 100644
> --- a/drivers/staging/bcm/DDRInit.c
> +++ b/drivers/staging/bcm/DDRInit.c
> @@ -5,15 +5,15 @@
>  #define DDR_DUMP_INTERNAL_DEVICE_MEMORY 0xBFC02B00
>  #define MIPS_CLOCK_REG 	0x0f000820
>  
> -    //DDR INIT-133Mhz
> -#define T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 12  //index for 0x0F007000
> -static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {//      # DPLL Clock Setting
> +    /* DDR INIT-133Mhz */
> +#define T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 12  /* index for 0x0F00700 */0
                                                                        ^^^

This also breaks the build...  :(  Really, this is not ok.

regards,
dan carpenter

