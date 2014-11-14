Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161712AbaKNRoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:44:04 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:34055 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161182AbaKNRoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:44:01 -0500
MIME-Version: 1.0
In-Reply-To: <1415949562-14957-1-git-send-email-jeffrey.lin@rad-ic.com>
References: <1415949562-14957-1-git-send-email-jeffrey.lin@rad-ic.com>
Date: Fri, 14 Nov 2014 09:43:59 -0800
X-Google-Sender-Auth: jKW0W1wYQE-PGI8iwa6I10fWsNQ
Message-ID: <CANLzEkt+CWDWJ8F47uQxum2DzV5hOSa5PHa0WcdwG2KBoHN4RQ@mail.gmail.com>
Subject: Re: [PATCH] driver: input :touchscreen : add Raydium I2C touch driver
From: Benson Leung <bleung@chromium.org>
To: "jeffrey.lin" <yajohn@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Olof Johansson <olof@lixom.net>,
        Douglas Anderson <dianders@chromium.org>, benzh@chromium.org,
        davidriley@chromium.org, Joe Konno <joe.konno@intel.com>,
        jeffrey.lin@rad-ic.com, roger.yang@rad-ic.com, KP.li@rad-ic.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeffrey,


On Thu, Nov 13, 2014 at 11:19 PM, jeffrey.lin <yajohn@gmail.com> wrote:
> this patch is porting Raydium I2C touch driver. Developer can enable
>  Raydium touch driver by modifying define "CONFIG_TOUCHSCREEN_RM31100"
>  in config/base.config
>
> Change-Id: Idae54cc4bca17f321a1d0895a8b59680bf9af859

This looks like it came from the chromiumos kernel. When you send a
patch to the linux-input list, make sure to strip out this stuff in
the commit message.

>
> Signed-off-by: jeffrey.lin@rad-ic.com
>
> chromeos: config: add Raydium touch default config
>
> Add to default table and set as not to use
>
> Signed-off-by: jeffrey.lin@rad-ic.com
> ---
>  chromeos/config/base.config         |    1 +

This file doesn't exist in upstream linux (only exists in
chromeos-kernels) so don't include this in the patch.

Basically, make sure whatever you send to the list actually applies to
mainline linux or linux-next.

>  drivers/input/touchscreen/RM31100.c | 1037 +++++++++++++++++++++++++++++++++++
>  include/linux/input/RM31100.h       |   60 ++
>  3 files changed, 1098 insertions(+)
>  create mode 100644 drivers/input/touchscreen/RM31100.c
>  create mode 100644 include/linux/input/RM31100.h
>
> diff --git a/chromeos/config/base.config b/chromeos/config/base.config
> index 59fa689..45b1023 100644
> --- a/chromeos/config/base.config
> +++ b/chromeos/config/base.config
> @@ -1727,6 +1727,7 @@ CONFIG_TOUCHSCREEN_ATMEL_MXT=y
>  # CONFIG_TOUCHSCREEN_TSC2007 is not set
>  # CONFIG_TOUCHSCREEN_TSC_SERIO is not set
>  CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
> +# CONFIG_TOUCHSCREEN_RM_TS is not set
>  # CONFIG_TOUCHSCREEN_WACOM_I2C is not set
>  # CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
>  # CONFIG_TPS6105X is not set


Thanks

-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
