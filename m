Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273Ab3AQIoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 03:44:20 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:43889 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3AQIoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 03:44:18 -0500
X-Greylist: delayed 1405 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2013 03:44:18 EST
MIME-Version: 1.0
In-Reply-To: <1358391258-1771-18-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
	<1358391258-1771-18-git-send-email-keescook@chromium.org>
Date: Thu, 17 Jan 2013 09:20:52 +0100
Message-ID: <CAOZOX0XYfgMU54MqXqTnq71dP5cA5teJ=qMezrOSXFD1priYtg@mail.gmail.com>
Subject: Re: [PATCH 17/86] drivers/net/wireless/rt2x00: remove depends on CONFIG_EXPERIMENTAL
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 3:53 AM, Kees Cook <keescook@chromium.org> wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
>
> CC: Ivo van Doorn <IvDoorn@gmail.com>
> CC: Gertjan van Wingerde <gwingerde@gmail.com>
> CC: Helmut Schaa <helmut.schaa@googlemail.com>
> CC: "John W. Linville" <linville@tuxdriver.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/Kconfig |    5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index c7548da..44d6ead 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -82,7 +82,6 @@ config RT2800PCI_RT33XX
>
>  config RT2800PCI_RT35XX
>         bool "rt2800pci - Include support for rt35xx devices (EXPERIMENTAL)"
> -       depends on EXPERIMENTAL
>         default y
>         ---help---
>           This adds support for rt35xx wireless chipset family to the
> @@ -92,7 +91,6 @@ config RT2800PCI_RT35XX
>
>  config RT2800PCI_RT53XX
>         bool "rt2800pci - Include support for rt53xx devices (EXPERIMENTAL)"
> -       depends on EXPERIMENTAL
>         default y
>         ---help---
>           This adds support for rt53xx wireless chipset family to the
> @@ -101,7 +99,6 @@ config RT2800PCI_RT53XX
>
>  config RT2800PCI_RT3290
>         bool "rt2800pci - Include support for rt3290 devices (EXPERIMENTAL)"
> -       depends on EXPERIMENTAL
>         default y
>         ---help---
>           This adds support for rt3290 wireless chipset family to the
> @@ -159,7 +156,6 @@ config RT2800USB_RT33XX
>
>  config RT2800USB_RT35XX
>         bool "rt2800usb - Include support for rt35xx devices (EXPERIMENTAL)"
> -       depends on EXPERIMENTAL
>         default y
>         ---help---
>           This adds support for rt35xx wireless chipset family to the
> @@ -168,7 +164,6 @@ config RT2800USB_RT35XX
>
>  config RT2800USB_RT53XX
>         bool "rt2800usb - Include support for rt53xx devices (EXPERIMENTAL)"
> -       depends on EXPERIMENTAL
>         ---help---
>           This adds support for rt53xx wireless chipset family to the
>           rt2800usb driver.
> --
> 1.7.9.5
>
