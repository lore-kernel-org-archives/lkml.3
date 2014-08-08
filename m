Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbaHHIPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 04:15:13 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:55822 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbaHHIPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 04:15:08 -0400
X-Greylist: delayed 167439 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Aug 2014 04:15:08 EDT
MIME-Version: 1.0
In-Reply-To: <1407339461-24483-1-git-send-email-tiwai@suse.de>
References: <1407339461-24483-1-git-send-email-tiwai@suse.de>
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Fri, 8 Aug 2014 10:14:52 +0200
Message-ID: <CAL8zT=iNYKeVEvhSMD5UP0mth1d3hQm9GQb5mxWTwLEv2e2LiQ@mail.gmail.com>
Subject: Re: [PATCH] misc: lattice-ecp3-config: Add missing MODULE_FIRMWARE()
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-06 17:37 GMT+02:00 Takashi Iwai <tiwai@suse.de>:
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/misc/lattice-ecp3-config.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/misc/lattice-ecp3-config.c b/drivers/misc/lattice-ecp3-config.c
> index 7ffdb589841e..643c9eda69dd 100644
> --- a/drivers/misc/lattice-ecp3-config.c
> +++ b/drivers/misc/lattice-ecp3-config.c
> @@ -242,3 +242,4 @@ module_spi_driver(lattice_ecp3_driver);
>  MODULE_AUTHOR("Stefan Roese <sr@denx.de>");
>  MODULE_DESCRIPTION("Lattice ECP3 FPGA configuration via SPI");
>  MODULE_LICENSE("GPL");
> +MODULE_FIRMWARE(FIRMWARE_NAME);
> --
> 2.0.3
>

It works on my i.MX6 platform.

Tested-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>

Thanks,
JM
