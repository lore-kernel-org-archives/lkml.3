Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbbABPJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:09:25 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:57180 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbbABPJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:09:24 -0500
MIME-Version: 1.0
In-Reply-To: <1420011629-77676-1-git-send-email-xiakaixu@huawei.com>
References: <1420011629-77676-1-git-send-email-xiakaixu@huawei.com>
Date: Fri, 2 Jan 2015 08:09:23 -0700
Message-ID: <CANLsYkxhd=shvkDBzJEzDk4a-AzcjBemp8VatHi33n8d7JB2Lg@mail.gmail.com>
Subject: Re: [PATCH] coresight: fix typo in comment in of_coresight.c
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Kaixu Xia <xiakaixu@huawei.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Kaixu Xia <kaixu.xia@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 December 2014 at 00:40, Kaixu Xia <xiakaixu@huawei.com> wrote:
> Debugfs isn't used for coresight configuration, so the corresponding
> comments should be changed.
>
> Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
> ---
>  drivers/coresight/of_coresight.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/coresight/of_coresight.c b/drivers/coresight/of_coresight.c
> index 5030c07..8bd524e 100644
> --- a/drivers/coresight/of_coresight.c
> +++ b/drivers/coresight/of_coresight.c
> @@ -126,7 +126,7 @@ struct coresight_platform_data *of_get_coresight_platform_data(
>         if (!pdata)
>                 return ERR_PTR(-ENOMEM);
>
> -       /* Use device name as debugfs handle */
> +       /* Use device name as sysfs handle */
>         pdata->name = dev_name(dev);
>
>         /* Get the number of input and output port for this component */
> --
> 1.8.5.5
>

Applied - thanks.
