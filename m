Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab3ARVAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:00:54 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46327 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3ARVAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:00:53 -0500
Date: Fri, 18 Jan 2013 13:00:49 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>
Cc: linux-kernel@i4.informatik.uni-erlangen.de, devel@driverdev.osuosl.org,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Sebastian Wankerl <sisewank@cip.cs.fau.de>
Subject: Re: [PATCH 2/3] wlan-ng/prism2mgmt.c: formated too long lines
Message-ID: <20130118210049.GA12463@kroah.com>
References: <20130117205834.GA659@kroah.com>
 <1358464052-14002-1-git-send-email-qi50dube@cip.cs.fau.de>
 <1358464052-14002-3-git-send-email-qi50dube@cip.cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358464052-14002-3-git-send-email-qi50dube@cip.cs.fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 12:07:31AM +0100, Sebastian Ehrenfels wrote:
> From: Sebastian Wankerl <sisewank@cip.cs.fau.de>
> 
> Signed-off-by: Sebastian Wankerl <sisewank@cip.cs.fau.de> 
> Signed-off-by: Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>
> 
> ---
>  drivers/staging/wlan-ng/prism2mgmt.c |   20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
> index 62b94b0..4b3db73 100644
> --- a/drivers/staging/wlan-ng/prism2mgmt.c
> +++ b/drivers/staging/wlan-ng/prism2mgmt.c
> @@ -1144,9 +1144,9 @@ int prism2mgmt_wlansniff(wlandevice_t *wlandev, void *msgp)
>  			/* Enable the port */
>  			result = hfa384x_drvr_enable(hw, 0);
>  			if (result) {
> -				pr_debug
> -				("failed to enable port to presniff setting, result=%d\n",
> -				     result);
> +				pr_debug(
> +					"failed to enable port to presniff setting,"
> +					"result=%d\n", result);

No, please put the string on the same line as the pr_debug() call, and
don't break it across multiple lines.  This should look like:
				pr_debug("failed to enable port to presniff setting,result=%d\n",
					 result);

Can you please fix this up and resend it?

thanks,

greg k-h
