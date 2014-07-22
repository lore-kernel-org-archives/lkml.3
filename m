Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaGVLuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:50:18 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:47522 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaGVLuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:50:16 -0400
MIME-Version: 1.0
In-Reply-To: <1406027485-15657-3-git-send-email-lee.jones@linaro.org>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
	<1406027485-15657-3-git-send-email-lee.jones@linaro.org>
Date: Tue, 22 Jul 2014 17:20:15 +0530
Message-ID: <CAMf-jSn5zZ1FBt+atzB9frZZ6yu_OTTfmJF2e7CEgQDbdzytBg@mail.gmail.com>
Subject: Re: [PATCH 02/19] mfd: max8925-i2c: Fix 'blank line after
 declarations' warning
From: pramod gurav <pramod.gurav.etc@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 4:41 PM, Lee Jones <lee.jones@linaro.org> wrote:
> This is part of an effort to clean-up the MFD subsystem.
>
> WARNING: Missing a blank line after declarations
> +       int ret;
> +       ret = i2c_add_driver(&max8925_driver);
>
> total: 0 errors, 1 warnings, 275 lines checked
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/max8925-i2c.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/mfd/max8925-i2c.c b/drivers/mfd/max8925-i2c.c
> index a83eed5..ecbe78e 100644
> --- a/drivers/mfd/max8925-i2c.c
> +++ b/drivers/mfd/max8925-i2c.c
> @@ -257,9 +257,11 @@ static struct i2c_driver max8925_driver = {
>  static int __init max8925_i2c_init(void)
>  {
>         int ret;
> +
>         ret = i2c_add_driver(&max8925_driver);
>         if (ret != 0)
>                 pr_err("Failed to register MAX8925 I2C driver: %d\n", ret);
> +
There are more such changes required in this file. If they could go
with this, will be good.
>         return ret;
>  }
>  subsys_initcall(max8925_i2c_init);
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks and Regards
Pramod
