Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab3LEESM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 23:18:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3LEESL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 23:18:11 -0500
Date: Wed, 4 Dec 2013 20:19:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next] mei: add 9 series PCH mei device ids
Message-ID: <20131205041913.GA4975@kroah.com>
References: <1386068489-19511-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386068489-19511-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 01:01:29PM +0200, Tomas Winkler wrote:
> And Lynx Point H Refresh and Wildcat Point LP
> device ids.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/hw-me-regs.h | 4 ++++
>  drivers/misc/mei/pci-me.c     | 4 +++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
> index 6c0fde5..f83bc80 100644
> --- a/drivers/misc/mei/hw-me-regs.h
> +++ b/drivers/misc/mei/hw-me-regs.h
> @@ -110,8 +110,12 @@
>  #define MEI_DEV_ID_PPT_3      0x1DBA  /* Panther Point */
>  
>  #define MEI_DEV_ID_LPT        0x8C3A  /* Lynx Point */
> +#define MEI_DEV_ID_LPT_H      0x8C3A  /* Lynx Point H */

Why duplicate this #define?

And, now that you changed it, why keep the "old" one around, it's no
longer used anywhere else?

thanks,

greg k-h
