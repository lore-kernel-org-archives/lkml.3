Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab3H2Ulm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:41:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab3H2Ull (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:41:41 -0400
Date: Thu, 29 Aug 2013 22:41:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: roccat: Added support for KonePureOptical
In-Reply-To: <1377786628.2404.1.camel@neuromancer.tessier-ashpool>
Message-ID: <alpine.LNX.2.00.1308292241150.23267@pobox.suse.cz>
References: <1377786628.2404.1.camel@neuromancer.tessier-ashpool>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Aug 2013, Stefan Achatz wrote:

> KonePureOptical is a KonePure with different sensor.
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> ---
>  drivers/hid/hid-ids.h             |    1 +
>  drivers/hid/hid-roccat-konepure.c |    3 ++-
>  2 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index ffe4c7a..ef18cd9 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -716,6 +716,7 @@
>  #define USB_DEVICE_ID_ROCCAT_KONE	0x2ced
>  #define USB_DEVICE_ID_ROCCAT_KONEPLUS	0x2d51
>  #define USB_DEVICE_ID_ROCCAT_KONEPURE	0x2dbe
> +#define USB_DEVICE_ID_ROCCAT_KONEPURE_OPTICAL	0x2db4
>  #define USB_DEVICE_ID_ROCCAT_KONEXTD	0x2e22
>  #define USB_DEVICE_ID_ROCCAT_KOVAPLUS	0x2d50
>  #define USB_DEVICE_ID_ROCCAT_LUA	0x2c2e
> diff --git a/drivers/hid/hid-roccat-konepure.c b/drivers/hid/hid-roccat-konepure.c
> index c79d0b0..5850959 100644
> --- a/drivers/hid/hid-roccat-konepure.c
> +++ b/drivers/hid/hid-roccat-konepure.c
> @@ -262,6 +262,7 @@ static int konepure_raw_event(struct hid_device *hdev,
>  
>  static const struct hid_device_id konepure_devices[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPURE) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPURE_OPTICAL) },
>  	{ }
>  };

I believe you are missing hid_have_special_driver[] entry.

>  
> @@ -300,5 +301,5 @@ module_init(konepure_init);
>  module_exit(konepure_exit);
>  
>  MODULE_AUTHOR("Stefan Achatz");
> -MODULE_DESCRIPTION("USB Roccat KonePure driver");
> +MODULE_DESCRIPTION("USB Roccat KonePure/Optical driver");
>  MODULE_LICENSE("GPL v2");
> -- 
> 1.7.3.4
> 
> 
> 

-- 
Jiri Kosina
SUSE Labs
