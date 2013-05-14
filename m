Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab3ENT1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 15:27:38 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:52381 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab3ENT1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 15:27:37 -0400
Date: Tue, 14 May 2013 15:27:48 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: "Cho, Yu-Chen" <acho@suse.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        jay.hung@mediatek.com
Subject: Re: [PATCH] Staging: add USB MTK bluetooth driver
Message-ID: <20130514192748.GA16887@kroah.com>
References: <1367490436-8438-1-git-send-email-acho@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367490436-8438-1-git-send-email-acho@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 06:27:16PM +0800, Cho, Yu-Chen wrote:
> diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> index fa41b04..e33cfe0 100644
> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@ -62,3 +62,4 @@ obj-$(CONFIG_SB105X)		+= sb105x/
>  obj-$(CONFIG_GOLDFISH)		+= goldfish/
>  obj-$(CONFIG_USB_DWC2)		+= dwc2/
>  obj-$(CONFIG_LUSTRE_FS)		+= lustre/
> +obj-$(CONFIG_USB_BTMTK)		+= btmkt_usb/

You didn't actually test this patch, it breaks the build:

scripts/Makefile.build:44:
/home/gregkh/linux/work/staging/drivers/staging/btmkt_usb/Makefile: No such file or directory
make[3]: *** No rule to make target
`/home/gregkh/linux/work/staging/drivers/staging/btmkt_usb/Makefile'.  Stop.

Please refresh this against 3.10-rc1 and test that it builds properly
and then resend it.

thanks,

greg k-h
