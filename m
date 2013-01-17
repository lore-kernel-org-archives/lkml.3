Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014Ab3AQGQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 01:16:45 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43728 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab3AQGQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 01:16:44 -0500
Message-ID: <1358403338.6252.16.camel@cumari.coelho.fi>
Subject: Re: [PATCH 55/86] drivers/net/wireless/ti/wl1251: remove depends on
 CONFIG_EXPERIMENTAL
From: Luciano Coelho <coelho@ti.com>
To: Kees Cook <keescook@chromium.org>
CC: <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 17 Jan 2013 08:15:38 +0200
In-Reply-To: <1358391258-1771-56-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
	 <1358391258-1771-56-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

On Wed, 2013-01-16 at 18:53 -0800, Kees Cook wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> 
> Cc: Luciano Coelho <coelho@ti.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/wireless/ti/wl1251/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ti/wl1251/Kconfig b/drivers/net/wireless/ti/wl1251/Kconfig
> index 1fb6584..8fec4ed 100644
> --- a/drivers/net/wireless/ti/wl1251/Kconfig
> +++ b/drivers/net/wireless/ti/wl1251/Kconfig
> @@ -1,6 +1,6 @@
>  menuconfig WL1251
>  	tristate "TI wl1251 driver support"
> -	depends on MAC80211 && EXPERIMENTAL && GENERIC_HARDIRQS
> +	depends on MAC80211 && GENERIC_HARDIRQS
>  	select FW_LOADER
>  	select CRC7
>  	---help---

This is already in my tree and will be sent up to wireless-next this
week.

--
Cheers,
Luca.

