Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab3BKAGW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 19:06:22 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:34728 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab3BKAGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 19:06:19 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 4/6] of_spi: Document cs_gpios and cs_gpio in kernel-doc
To: Andreas Larsson <andreas@gaisler.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        software@gaisler.com
In-Reply-To: <1359471223-4794-5-git-send-email-andreas@gaisler.com>
References: <1359471223-4794-1-git-send-email-andreas@gaisler.com> <1359471223-4794-5-git-send-email-andreas@gaisler.com>
Date: Mon, 11 Feb 2013 00:06:15 +0000
Message-Id: <20130211000615.2BD4A3E0C13@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2013 15:53:41 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
> This adds missing kernel-doc entries for cs_gpios in struct spi_master and
> cs_gpio in struct spi_device.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Applied, thanks. I did tweak the language a bit.

g.

> ---
>  include/linux/spi/spi.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
> index f629189..88a669c 100644
> --- a/include/linux/spi/spi.h
> +++ b/include/linux/spi/spi.h
> @@ -57,6 +57,7 @@ extern struct bus_type spi_bus_type;
>   * @modalias: Name of the driver to use with this device, or an alias
>   *	for that name.  This appears in the sysfs "modalias" attribute
>   *	for driver coldplugging, and in uevents used for hotplugging
> + * @cs_gpio: Negative or gpio for chip select.
>   *
>   * A @spi_device is used to interchange data between an SPI slave
>   * (usually a discrete chip) and CPU memory.
> @@ -258,6 +259,7 @@ static inline void spi_unregister_driver(struct spi_driver *sdrv)
>   * @unprepare_transfer_hardware: there are currently no more messages on the
>   *	queue so the subsystem notifies the driver that it may relax the
>   *	hardware by issuing this call
> + * @cs_gpios: possible array of negative values or gpios for chip selects
>   *
>   * Each SPI master controller can communicate with one or more @spi_device
>   * children.  These make a small bus, sharing MOSI, MISO and SCK signals
> -- 
> 1.7.0.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
