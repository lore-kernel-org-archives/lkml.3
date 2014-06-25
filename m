Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbaFYKtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:49:36 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:56893 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbaFYKte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:49:34 -0400
MIME-Version: 1.0
In-Reply-To: <1403692697-7381-2-git-send-email-ch.naveen@samsung.com>
References: <1403692697-7381-1-git-send-email-ch.naveen@samsung.com>
	<1403692697-7381-2-git-send-email-ch.naveen@samsung.com>
Date: Wed, 25 Jun 2014 16:19:32 +0530
Message-ID: <CAK5sBcEVHYQutEm9Lh3eGX8_6zKLV-m3XfYKtnfPs8CBExpHqg@mail.gmail.com>
Subject: Re: [PATCH 2/2] i2c: exynos5: fix minor styling nits
From: Sachin Kamat <spk.linux@gmail.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-i2c@vger.kernel.org, Naveen Krishna <naveenkrishna.ch@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        sjg@chromium.org, open list <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>, cpgs@samsung.com, broonie@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On Wed, Jun 25, 2014 at 4:08 PM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> This patch removes an extra line and fixes a styling nit
> in exynos5_i2c_message_start()
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
>  drivers/i2c/busses/i2c-exynos5.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
> index 0d1a7bc..4c2e6f3 100644
> --- a/drivers/i2c/busses/i2c-exynos5.c
> +++ b/drivers/i2c/busses/i2c-exynos5.c
> @@ -525,7 +525,7 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
>         if (i2c->msg->flags & I2C_M_RD) {
>                 i2c_ctl |= HSI2C_RXCHON;
>
> -               i2c_auto_conf = HSI2C_READ_WRITE;
> +               i2c_auto_conf |= HSI2C_READ_WRITE;

This change looks more than just a styling nit. Please update the commit message
accordingly.

-- 
Regards,
Sachin.
