Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbaIQRvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:51:42 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:39238 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbaIQRvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:51:40 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Subject: Re: [PATCH 17/18] usbip: Increment version number to 1.2.1
Date: Wed, 17 Sep 2014 19:51:34 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, valentina.manea.m@gmail.com,
        shuah.kh@samsung.com, gregkh@linuxfoundation.org,
        Dominik Paulus <dominik.paulus@fau.de>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email> <1410910735-27929-18-git-send-email-maximilian@eschenbacher.email>
In-Reply-To: <1410910735-27929-18-git-send-email-maximilian@eschenbacher.email>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201409171951.34150.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2014 01:38, Maximilian Eschenbacher wrote:
> From: Dominik Paulus <dominik.paulus@fau.de>
> 
> Also increment the kernel module version number to match the
> userspace version, as compatibility with old userspace utilities
> is now at least partially broken.
> 
> Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
> Signed-off-by: Fjodor Schelichow <fjodor.schelichow@hotmail.com>
> Signed-off-by: Johannes Stadlinger <johannes.stadlinger@fau.de>
> Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
> Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
> ---
>  drivers/usb/usbip/usbip_common.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/usbip/usbip_common.h b/drivers/usb/usbip/usbip_common.h
> index 6831d99..a5f416e 100644
> --- a/drivers/usb/usbip/usbip_common.h
> +++ b/drivers/usb/usbip/usbip_common.h
> @@ -32,7 +32,7 @@
>  #include <uapi/linux/usbip.h>
>  #include <linux/kfifo.h>
>  
> -#define USBIP_VERSION "1.0.0"
> +#define USBIP_VERSION "1.2.1"

You can use UTS_RELEASE instead - it would handle the task of identifying
the version of running code as good, or better, than a subsystem-specific
version id.
For one, as this patch attests, subsystem-specific ids tend to become stale...
