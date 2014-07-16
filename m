Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbaGPAT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:19:58 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60701 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759334AbaGPATx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 20:19:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140716000054.GA1192@mars.lan>
References: <20140716000054.GA1192@mars.lan>
Date: Tue, 15 Jul 2014 17:19:52 -0700
X-Google-Sender-Auth: R1qBQusVwwmOK_wpb_tIWNJWhf8
Message-ID: <CANLzEks7waVxoo+CNdcb_q8YX3PJJSsb2YZLVk97Tfvm9zKx=g@mail.gmail.com>
Subject: Re: [PATCH] Add support for the acer c720p touchscreen.
From: Benson Leung <bleung@chromium.org>
To: Michael Mullin <masmullin@gmail.com>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dparker@chromium.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

Thank you for adding this and verifying it works on your system.

On Tue, Jul 15, 2014 at 5:00 PM, Michael Mullin <masmullin@gmail.com> wrote:
> Add support for the acer c720p touchscreen.
> Tested manually by using the touchscreen on the acer c720p-2664
>
> Based on the following patch by Dave Parker <dparker@chromium.org>:
> https://chromium-review.googlesource.com/#/c/167136/
>
> Signed-off-by: Michael Mullin <masmullin@gmail.com>

Reviewed-by: Benson Leung <bleung@chromium.org>

> ---
>  drivers/platform/chrome/chromeos_laptop.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
> index a53fe76..15b1b16 100644
> --- a/drivers/platform/chrome/chromeos_laptop.c
> +++ b/drivers/platform/chrome/chromeos_laptop.c
> @@ -419,6 +419,8 @@ static struct chromeos_laptop acer_ac700 = {
>
>  static struct chromeos_laptop acer_c720 = {
>         .i2c_peripherals = {
> +               /* Touchscreen. */
> +               { .add = setup_atmel_1664s_ts, I2C_ADAPTER_DESIGNWARE_1 },
>                 /* Touchpad. */
>                 { .add = setup_cyapa_tp, I2C_ADAPTER_DESIGNWARE_0 },
>                 /* Light Sensor. */
> --
> 2.0.1
>



-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
