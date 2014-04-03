Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162484AbaDCHqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:46:21 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29594 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162347AbaDCHqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:46:18 -0400
Date: Thu, 3 Apr 2014 10:46:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, silentquote@gmail.com
Subject: Re: [PATCH 2/9] driver: staging: wlan-ng: Removed unnecessary
 typedefs from hfa384x_usb.c
Message-ID: <20140403074608.GZ6991@mwanda>
References: <1396509119-2894-1-git-send-email-shehabaldin.sherif@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396509119-2894-1-git-send-email-shehabaldin.sherif@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 09:11:59AM +0200, Sherif Shehab Aldin wrote:
> Removed unnecessary typedefs from hfa384x_usb.c
> 
> Signed-off-by: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
> ---
>  drivers/staging/wlan-ng/hfa384x_usb.c |   38 ++++++++++++++++-----------------
>  1 file changed, 18 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
> index 4c828c2..2a44c79 100644
> --- a/drivers/staging/wlan-ng/hfa384x_usb.c
> +++ b/drivers/staging/wlan-ng/hfa384x_usb.c
> @@ -643,8 +643,8 @@ usbctlx_get_status(const hfa384x_usb_cmdresp_t *cmdresp,
>  	result->resp2 = le16_to_cpu(cmdresp->resp2);
>  
>  	pr_debug("cmdresult:status=0x%04x resp0=0x%04x resp1=0x%04x resp2=0x%04x\n",
> -			result->status, result->resp0,
> -			result->resp1, result->resp2);
> +		 result->status, result->resp0,
> +		 result->resp1, result->resp2);
>  

This change has nothing to do with typedefs.  I am confused.

regards,
dan carpenter

