Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbbAFUfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:35:22 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33787 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbAFUfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:35:20 -0500
MIME-Version: 1.0
In-Reply-To: <1420459538-20936-1-git-send-email-xiakaixu@huawei.com>
References: <1420459538-20936-1-git-send-email-xiakaixu@huawei.com>
Date: Tue, 6 Jan 2015 13:35:20 -0700
Message-ID: <CANLsYkwHfLG-ZrAPYwfjm_sc34ZF6+i8c2WYP2BNQEq7QFCVBQ@mail.gmail.com>
Subject: Re: [PATCH] coresight: fix comment in of_coresight.c
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Kaixu Xia <xiakaixu@huawei.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Kaixu Xia <kaixu.xia@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 January 2015 at 05:05, Kaixu Xia <xiakaixu@huawei.com> wrote:
> Outports is a member of the struct pdata and should be
> a better choice.
>
> Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
> ---
>  drivers/coresight/of_coresight.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/coresight/of_coresight.c b/drivers/coresight/of_coresight.c
> index 8bd524e..89ebbe2 100644
> --- a/drivers/coresight/of_coresight.c
> +++ b/drivers/coresight/of_coresight.c
> @@ -93,7 +93,7 @@ static int of_coresight_alloc_memory(struct device *dev,
>         if (!pdata->outports)
>                 return -ENOMEM;
>
> -       /* Children connected to this component via @outport */
> +       /* Children connected to this component via @outports */
>          pdata->child_names = devm_kzalloc(dev, pdata->nr_outport *
>                                           sizeof(*pdata->child_names),
>                                           GFP_KERNEL);
> --
> 1.8.5.5
>

Applied - thanks.
