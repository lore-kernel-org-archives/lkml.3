Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144AbaGMRxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 13:53:39 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58290 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766AbaGMRxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 13:53:30 -0400
X-Sasl-enc: DtnEzFu9xkdC5eUG94TQCYAkXyeRYfNrhPfUn7UEd3Fc 1405273785
Date: Sun, 13 Jul 2014 14:49:39 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: microcai@fedoraproject.org
Cc: linux-usb@vger.kernel.org, jkosina@suse.cz, linux-kernel@vger.kernel.org,
        microcai <microcaicai@gmail.com>
Subject: Re: [PATCH] add quirks for 0x04d9:0xa096 hid keyborad device
Message-ID: <20140713174939.GC23425@khazad-dum.debian.net>
References: <1405238642-19507-1-git-send-email-microcai@fedoraproject.org>
 <1405238642-19507-2-git-send-email-microcai@fedoraproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405238642-19507-2-git-send-email-microcai@fedoraproject.org>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2014, microcai@fedoraproject.org wrote:
> From: microcai <microcaicai@gmail.com>

Real name, please.

Also, you need to add a signed-off-by line, refer to:
Documentation/SubmittingPatches
in the kernel source.

> by adding this quirks, the usb keyborad is usable right after plugin

It is spelled keyboard.  Please also fix this on the patch itself:

> +++ b/drivers/hid/hid-ids.h
> @@ -477,6 +477,7 @@
>  #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A070	0xa070
>  #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A072	0xa072
>  #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081	0xa081
> +#define USB_DEVICE_ID_HOLTEK_ALT_KEYBORAD_A096	0xa096

KEYBOARD

>  #define USB_DEVICE_ID_DISC_STAKKA	0xd000
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
> index 8e4ddb3..6a9bdfe 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -120,6 +120,7 @@ static const struct hid_blacklist {
>  	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_HD, HID_QUIRK_NO_INIT_REPORTS },
>  	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_QUAD_HD, HID_QUIRK_NO_INIT_REPORTS },
>  	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_TP_V103, HID_QUIRK_NO_INIT_REPORTS },
> +	{ USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBORAD_A096, HID_QUIRK_NO_INIT_REPORTS },

Also here, KEYBOARD

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
