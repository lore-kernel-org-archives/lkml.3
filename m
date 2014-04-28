Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035AbaD1VkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:40:05 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:52531 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbaD1VkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:40:03 -0400
Date: Mon, 28 Apr 2014 22:40:00 +0100
From: Brian Healy <healybrian@gmail.com>
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Kernel 3.15-rc2 : Peak DVB-T USB tuner device ids for
 rtl28xxu driver
Message-ID: <20140428214000.GA9187@gmail.com>
References: <CAGG=RuYdtfjJf5wKG92KdyKuG6AiBHp2_OSH8Wemi3yQOsouMQ@mail.gmail.com>
 <CA+55aFzhydSCJqMLoUX59cLpiwbnoXtL524O5VtQ4-CVj8HxyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <CA+55aFzhydSCJqMLoUX59cLpiwbnoXtL524O5VtQ4-CVj8HxyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 27, 2014 at 03:19:12PM -0700, Linus Torvalds wrote:

Hi Linus,

apologies, i've changed email clients in order to preserve the
formatting this time around. The patch is now included inline as an
attachment. I ran the script but noticed you've already cc'd the
appropriate people. 

Brian.


Resubmitting modified patch. It's purpose is to add the appropriate
device/usb ids for the "Peak DVT-B usb dongle" to the rtl28xxu.c driver.

Signed-off-by: Brian Healy <healybrian <at> gmail.com>


> Brian, please use
> 
>  ./scripts/get_maintainer -f drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> 
> to get the proper people to send this to, so that it doesn't get lost
> in the flood in lkml.
> 
> The indentation of that new entry also seems to be suspect, in that it
> doesn't match the ones around it.
> 
> Quoting full email for context for people added.
> 
>              Linus
> 

--opJtzjQTFsWo+cga
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="rtl28xxu.patch"

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 61d196e..b6e20cc 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1499,6 +1499,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
 		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
+        { DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd395,
+                &rtl2832u_props, "Peak DVB-T USB", NULL) },
 
 	/* RTL2832P devices: */
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,

--opJtzjQTFsWo+cga--
