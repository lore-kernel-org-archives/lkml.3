Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3BPV2K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 16:28:10 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:42820 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3BPV2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 16:28:08 -0500
Date: Sat, 16 Feb 2013 13:24:20 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: arnd@arndb.de, axboe@kernel.dk, davem@davemloft.net, dtor@mail.ru,
        dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, tiwai@suse.de, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH 14/15] drivers/power,goldfisch battery: add missing
 GENERIC_HARDIRQS dependency
Message-ID: <20130216212420.GA1741@lizard.sbx05280.losalca.wayport.net>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
 <1360167843-3587-15-git-send-email-heiko.carstens@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1360167843-3587-15-git-send-email-heiko.carstens@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 05:24:02PM +0100, Heiko Carstens wrote:
> Fix this link error on s390:
> 
> ERROR: "devm_request_threaded_irq" [drivers/power/goldfish_battery.ko] undefined!
> 
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---

Applied, thanks!

>  drivers/power/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 1e47197..9e00c38 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -348,6 +348,7 @@ config AB8500_BM
>  
>  config BATTERY_GOLDFISH
>  	tristate "Goldfish battery driver"
> +	depends on GENERIC_HARDIRQS
>  	help
>  	  Say Y to enable support for the battery and AC power in the
>  	  Goldfish emulator.
> -- 
> 1.7.10.4
> 
> 
