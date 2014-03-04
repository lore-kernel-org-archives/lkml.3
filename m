Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbaCDTSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:18:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaCDTSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:18:31 -0500
Date: Tue, 4 Mar 2014 11:20:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: devel@driverdev.osuosl.org, shuah.kh@samsung.com,
        linux-usb@vger.kernel.org, ly80toro@cip.cs.fau.de,
        tobias.polzer@fau.de, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, dominik.paulus@fau.de,
        ihadzic@research.bell-labs.com
Subject: Re: [PATCH] staging: usbip: userspace: increase version to 2.0
Message-ID: <20140304192014.GA28665@kroah.com>
References: <1393960599-21379-1-git-send-email-valentina.manea.m@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393960599-21379-1-git-send-email-valentina.manea.m@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 09:16:39PM +0200, Valentina Manea wrote:
> Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
> ---
>  drivers/staging/usbip/userspace/configure.ac | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
> index 25bf160..607d05c 100644
> --- a/drivers/staging/usbip/userspace/configure.ac
> +++ b/drivers/staging/usbip/userspace/configure.ac
> @@ -1,7 +1,7 @@
>  dnl Process this file with autoconf to produce a configure script.
>  
>  AC_PREREQ(2.59)
> -AC_INIT([usbip-utils], [1.1.1], [linux-usb@vger.kernel.org])
> +AC_INIT([usbip-utils], [2.0], [linux-usb@vger.kernel.org])

Why?

What does this mean?  What warrents the version change?  Why have a
version at all?

thanks,

greg k-h
