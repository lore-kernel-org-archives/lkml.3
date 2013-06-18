Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3FRKTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:19:47 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54570 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab3FRKTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:19:46 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18uZ3waXdSfI6cO1d8uHRMg
Date: Tue, 18 Jun 2013 03:19:37 -0700
From: Tony Lindgren <tony@atomide.com>
To: Adrien =?utf-8?B?VmVyZ8Op?= <adrienverge@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        AnilKumar Ch <anilkumar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] ARM: omap2plus_defconfig: enable USB_PHY and
 NOP_USB_XCEIV
Message-ID: <20130618101936.GL5523@atomide.com>
References: <CANsc=4W8cW3jQs8yN_j8DZyEo7GkMejNc4Vw65A4iW+GuasBaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANsc=4W8cW3jQs8yN_j8DZyEo7GkMejNc4Vw65A4iW+GuasBaw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrien Vergé <adrienverge@gmail.com> [130528 11:34]:
> On OMAP2+ platforms, USB support needs physical layer signalling and
> the NOP USB Transceiver driver since v3.10. This patch enables USB_PHY
> and NOP_USB_XCEIV in omap2plus_defconfig. These two are harmless to
> the kernel stability, and useful since they are required for USB and
> Ethernet (over USB) support.
> 
> We do not enable USB_EHCI_HCD here because all features aren't fully
> supported yet.
> 
> This patch applies to Linux 3.10-rc3.
> 
> Cc: Roger Quadros <rogerq@ti.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Adrien Vergé <adrienverge@gmail.com>

Thanks applying into omap-for-v3.11/board.

Regards,

Tony

> ---
>  arch/arm/configs/omap2plus_defconfig |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/configs/omap2plus_defconfig
> b/arch/arm/configs/omap2plus_defconfig
> index abbe319..2ac0ffb 100644
> --- a/arch/arm/configs/omap2plus_defconfig
> +++ b/arch/arm/configs/omap2plus_defconfig
> @@ -210,6 +210,8 @@ CONFIG_USB_WDM=y
>  CONFIG_USB_STORAGE=y
>  CONFIG_USB_LIBUSUAL=y
>  CONFIG_USB_TEST=y
> +CONFIG_USB_PHY=y
> +CONFIG_NOP_USB_XCEIV=y
>  CONFIG_USB_GADGET=y
>  CONFIG_USB_GADGET_DEBUG=y
>  CONFIG_USB_GADGET_DEBUG_FILES=y
> -- 
> 1.7.10.4
