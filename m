Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab3FADKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 23:10:41 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:45461 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239Ab3FADIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 23:08:39 -0400
MIME-Version: 1.0
In-Reply-To: <1370050492-6046-2-git-send-email-jwerner@chromium.org>
References: <1370050492-6046-1-git-send-email-jwerner@chromium.org>
	<1370050492-6046-2-git-send-email-jwerner@chromium.org>
Date: Sat, 1 Jun 2013 12:08:38 +0900
Message-ID: <CADoNuNc9xKEHB5syTh4kVkL=e+_Ud_WpcFj6V4mqCgTbixMRfg@mail.gmail.com>
Subject: Re: [PATCH 1/3] usb: misc: usb3503: Fix up whitespace
From: Dongjin Kim <tobetter@gmail.com>
To: Julius Werner <jwerner@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Simon Glass <sjg@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongjin Kim <tobetter@gmail.com>

On Sat, Jun 1, 2013 at 10:34 AM, Julius Werner <jwerner@chromium.org> wrote:
> Remove an erroneous tab that should be a space.
>
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  drivers/usb/misc/usb3503.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
> index d3a1cce..73aeb87 100644
> --- a/drivers/usb/misc/usb3503.c
> +++ b/drivers/usb/misc/usb3503.c
> @@ -208,7 +208,7 @@ static int usb3503_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
>                 hub->gpio_connect = of_get_named_gpio(np, "intn-gpios", 0);
>                 if (hub->gpio_connect == -EPROBE_DEFER)
>                         return -EPROBE_DEFER;
> -               hub->gpio_reset = of_get_named_gpio(np, "reset-gpios", 0);
> +               hub->gpio_reset = of_get_named_gpio(np, "reset-gpios", 0);
>                 if (hub->gpio_reset == -EPROBE_DEFER)
>                         return -EPROBE_DEFER;
>                 of_property_read_u32(np, "initial-mode", &mode);
> --
> 1.7.12.4
>
