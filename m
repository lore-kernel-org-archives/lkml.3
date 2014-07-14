Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaGNN1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:27:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbaGNN0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:26:55 -0400
Date: Mon, 14 Jul 2014 06:26:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Joerg C. Meyer" <joerg@meyer.homedns.org>
Cc: dingtianhong@huawei.com, chenweilong@huawei.com, sachin.kamat@linaro.org,
        davem@davemloft.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8821ae: fix coding style issue in cam.c
Message-ID: <20140714132633.GA8144@kroah.com>
References: <1405330953-20279-1-git-send-email-joerg@meyer.homedns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405330953-20279-1-git-send-email-joerg@meyer.homedns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 11:42:33AM +0200, Joerg C. Meyer wrote:
> This is a patch to the cam.c file that fix a coding style error (do not use C99 // comments)
> Signed-off-by: Joerg C. Meyer <joerg@meyer.homedns.org>

Minor nit, you need a blank line between these two lines...

> ---
>  drivers/staging/rtl8821ae/cam.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/rtl8821ae/cam.c b/drivers/staging/rtl8821ae/cam.c
> index 3bc6b3d..9c0cd1e 100644
> --- a/drivers/staging/rtl8821ae/cam.c
> +++ b/drivers/staging/rtl8821ae/cam.c
> @@ -152,7 +152,7 @@ u8 rtl_cam_add_one_entry(struct ieee80211_hw *hw, u8 *mac_addr,
>  	return 1;
>  
>  }
> -//EXPORT_SYMBOL(rtl_cam_add_one_entry);
> +/* EXPORT_SYMBOL(rtl_cam_add_one_entry); */

Your patch is correct, but how about just deleting these lines instead?
They aren't needed, so please remove them.

Can you do that and resend?

thanks,

greg k-h
