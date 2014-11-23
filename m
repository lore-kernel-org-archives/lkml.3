Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaKWR2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 12:28:48 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:51994 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaKWR2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 12:28:47 -0500
Date: Sun, 23 Nov 2014 22:58:34 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Lekshmi <andnlnbn18@gmail.com>
Cc: gregkh@linuxfoundation.org, matt@ninezulu.com, raghav3276@gmail.com,
        josh@joshtriplett.org, tapaswenipathak@gmail.com,
        vitaly.osipov@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers:staging:wlan-ng: Fixed line over 80 characters
 warning
Message-ID: <20141123172834.GA8422@sudip-PC>
References: <1416736614-3873-1-git-send-email-andnlnbn18@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416736614-3873-1-git-send-email-andnlnbn18@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 03:26:54PM +0530, Lekshmi wrote:
> The following chaeckpatch warning was fixed:
> WARNING: line over 80 characters
> 
> Signed-off-by: Lekshmi <andnlnbn18@gmail.com>
> ---
>  drivers/staging/wlan-ng/prism2fw.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
> index e907380..5c3fd2d 100644
> --- a/drivers/staging/wlan-ng/prism2fw.c
> +++ b/drivers/staging/wlan-ng/prism2fw.c
> @@ -238,7 +238,8 @@ static int prism2_fwtry(struct usb_device *udev, wlandevice_t *wlandev)
>  *	0	- success
>  *	~0	- failure
>  ----------------------------------------------------------------*/
> -static int prism2_fwapply(const struct ihex_binrec *rfptr, wlandevice_t *wlandev)
> +static int prism2_fwapply(const struct ihex_binrec *rfptr,
> +			  wlandevice_t *wlandev)
>  {
>  	signed int result = 0;
>  	struct p80211msg_dot11req_mibget getmsg;
> @@ -707,7 +708,8 @@ static int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
>  			continue;
>  		}
>  
> -		/* Validate plug address against chunk data and identify chunk */
> +		/* Validate plug address against chunk data
> +		 * and identify chunk */
this is not the style for multiline comment. please check the CodingStyle in Documentation.

thanks
sudip

>  		for (c = 0; c < nfchunks; c++) {
>  			cstart = fchunk[c].addr;
>  			cend = fchunk[c].addr + fchunk[c].len;
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
