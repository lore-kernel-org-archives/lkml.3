Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949Ab3JOMwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 08:52:33 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40247 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757696Ab3JOMwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 08:52:32 -0400
MIME-Version: 1.0
In-Reply-To: <1381808931-3323-1-git-send-email-sachin.kamat@linaro.org>
References: <1381808931-3323-1-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 15 Oct 2013 13:52:30 +0100
Message-ID: <CANmRt2gDyEvaYZEfBfCD2eFXFb=GDeJcL-OFSA1xpJDk7r6c9Q@mail.gmail.com>
Subject: Re: [PATCH Resend 1/6] mfd: max8925: Remove redundant of_match_ptr
From: Lee Jones <ljkenny.mailinglists@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still something odd going on with my mails, but I have applied all
patches in this series, manually!

On Tue, Oct 15, 2013 at 4:48 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> The data structure of_match_ptr() protects is always compiled in.
> Hence of_match_ptr() is not needed.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/max8925-i2c.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mfd/max8925-i2c.c b/drivers/mfd/max8925-i2c.c
> index de7fb80..176aa26 100644
> --- a/drivers/mfd/max8925-i2c.c
> +++ b/drivers/mfd/max8925-i2c.c
> @@ -238,7 +238,7 @@ static struct i2c_driver max8925_driver = {
>                 .name   = "max8925",
>                 .owner  = THIS_MODULE,
>                 .pm     = &max8925_pm_ops,
> -               .of_match_table = of_match_ptr(max8925_dt_ids),
> +               .of_match_table = max8925_dt_ids,
>         },
>         .probe          = max8925_probe,
>         .remove         = max8925_remove,
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
