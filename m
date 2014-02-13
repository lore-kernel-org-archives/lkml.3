Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaBMEYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 23:24:39 -0500
Received: from m12-15.163.com ([220.181.12.15]:43649 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbaBMEYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 23:24:37 -0500
Date: Thu, 13 Feb 2014 12:23:44 +0800
From: "liujunliang_ljl" <liujunliang_ljl@163.com>
To: "Thierry Reding" <thierry.reding@gmail.com>
Cc: "davem" <davem@davemloft.net>, "horms" <horms@verge.net.au>,
        "joe" <joe@perches.com>, "romieu" <romieu@fr.zoreil.com>,
        "gregkh" <gregkh@linuxfoundation.org>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-usb" <linux-usb@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "sunhecheng" <sunhecheng@vip.126.com>
References: <1392010419-5217-1-git-send-email-liujunliang_ljl@163.com>
Subject: Re: Re: [PATCH] USB2NET : SR9800 : One chip USB2.0 USB2NET SR9800 DeviceDriver Support
Message-ID: <201402131223440786692@163.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
X-CM-TRANSID: D8CowEBZW23MSPxSvQ7uAg--.492S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCF1rKFW5Cr1kWw1rXr4kXrb_yoW5Xr4fpw
	42yrW3Cr47tr13t34fJw18ZFy5AFs7tr98Kry3uasYvFW5ury5tw1j9Fy0gr17JrZ5Ca4j
	vFsI9a47Wa15WwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j4oGdUUUUU=
X-Originating-IP: [113.110.151.25]
X-CM-SenderInfo: xolxy3pqolt0hjboyzi6rwjhhfrp/xtbB0w4xX1EAI4TYIAAAs9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1D4OhmO024812

Dear Thierry :

			For this driver, we can set it as 'n', and There is no rule of thumb as to which should default to y.

			Thanks for your advice.

			Thanks again.
		


2014-02-13 



liujunliang_ljl 


                                                                               
∑¢º˛»À£∫ Thierry Reding 
∑¢ÀÕ ±º‰£∫ 2014-02-12  18:12:52 
 ’º˛»À£∫ liujunliang_ljl 
≥≠ÀÕ£∫ davem; horms; joe; romieu; gregkh; netdev; linux-usb; linux-kernel; sunhecheng 
÷˜Ã‚£∫ Re: [PATCH] USB2NET : SR9800 : One chip USB2.0 USB2NET SR9800 DeviceDriver Support 
 
On Mon, Feb 10, 2014 at 01:33:39PM +0800, liujunliang_ljl@163.com wrote:
> From: Liu Junliang <liujunliang_ljl@163.com>
> 
> 
> Signed-off-by: Liu Junliang <liujunliang_ljl@163.com>
> ---
>  drivers/net/usb/Kconfig  |   16 +
>  drivers/net/usb/Makefile |    1 +
>  drivers/net/usb/sr9800.c |  873 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/net/usb/sr9800.h |  202 +++++++++++
>  4 files changed, 1092 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/net/usb/sr9800.c
>  create mode 100644 drivers/net/usb/sr9800.h
> 
> diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
> index 47b0f73..2551bf6 100644
> --- a/drivers/net/usb/Kconfig
> +++ b/drivers/net/usb/Kconfig
> @@ -291,6 +291,22 @@ config USB_NET_SR9700
>     This option adds support for CoreChip-sz SR9700 based USB 1.1
>     10/100 Ethernet adapters.
>  
> +config USB_NET_SR9800
> + tristate "CoreChip-sz SR9800 based USB 2.0 10/100 ethernet devices"
> + depends on USB_USBNET
> + select CRC32
> + default y
Why is this selected by default? I can see that some of the other USB
network drivers are also selected by default, but not all of them. Is
there some rule of thumb as to which should default to y and which
shouldn't?
Thierry
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
iQIcBAEBAgAGBQJS+0kdAAoJEN0jrNd/PrOhXvwQAJIW4vgv0NkyQVo5jSvzeLY4
9PFCrtd6N1n+O7P99x38JCCD9lWtfdin1EZfj+UicCanup2WzpyBWHeBhdSN4oZA
/+C+TgEIuX0+Be11IXeUOGMP9a3k/12HY3oHuz7BA2JjcK6PnfMxaEC7iGGJSjgz
q4Goa5kSqjvNgbP8h5bQPTNtMnRdsSytI7PMJbl4t1ho0V7H3pSo9zD7rxaPhmtE
v/18VQawGcY83Hr0B0Q18XAnNXaQMLZTvdhVfDUxB5VKT4Xhcri0m4adbAzMI9kR
K9CEChkDn68y13drJVILKqUjW+4LMQHAsQV07yl98Sqk7LYOedL9mQOnIL0crjWa
OAmLHwLv0ED25W1Hv3UdeSpBdIkO9cD0PCa7vHQnv7lpTlkaDyYelKLQ2D+GXrCw
1L/341ak9QEGiCU1TiOHDblnsN+OtCt0Pt+hijLHFl4TQKw3QIUoZLa4bQuDPM8M
juTSV63HRjiDlNGvtjBezlR9GFu5w3SJuNSNsFkZ7ADJwjz9On9JaDwH/Ad7AqmZ
ylE+zzbIpOWjyNToMH2dattpeVZkIfGkS02y6PcIx51EGMw5B8l6qKLB9YpkJpwR
7rhMYjpLKIn/6rRGlwmZKYnWYl7p/FdI0yOnVbtMYx406ivUNc+kgvmx5l1mXhT7
b8gKKYYA0pMEMXjgnkK1
=3y7X
-----END PGP SIGNATURE-----
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
