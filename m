Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab3ENTWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 15:22:10 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:54021 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab3ENTWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 15:22:09 -0400
Date: Tue, 14 May 2013 15:22:05 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: "Cho, Yu-Chen" <acho@suse.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        jay.hung@mediatek.com
Subject: Re: [PATCH] Staging: add USB MTK bluetooth driver
Message-ID: <20130514192205.GA4728@kroah.com>
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
> --- /dev/null
> +++ b/drivers/staging/btmtk_usb/TODO
> @@ -0,0 +1,9 @@
> +TODO:
> +	- checkpatch.pl clean
> +	- determine if the driver should not be using a duplicate
> +	   version of the usb-bluetooth interface code, but should
> +	   be merged into the drivers/bluetooth/ directory and
> +	   infrastructure instead.
> +	- review by the bluetooth developer community
> +
> +Please send any patches for this driver to Yu-Chen, Cho <acho@suse.com> and
> diff --git a/drivers/staging/btmtk_usb/btmtk_usb.c b/drivers/staging/btmtk_usb/btmtk_usb.c

I think you forgot to write the last line of this TODO file :)

Care to send a follow-on patch to fix this up?

thanks,

greg k-h
