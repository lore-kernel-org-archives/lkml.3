Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbbAMVbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:31:38 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:55840 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbbAMVbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:31:37 -0500
MIME-Version: 1.0
In-Reply-To: <1421051546-60429-1-git-send-email-xiakaixu@huawei.com>
References: <1421051546-60429-1-git-send-email-xiakaixu@huawei.com>
Date: Tue, 13 Jan 2015 14:31:36 -0700
Message-ID: <CANLsYkyxf1fBg5FiYgBx=iP09XTVPR_xZ-_d7GAjdydSzvy+1g@mail.gmail.com>
Subject: Re: [PATCH] coresight: fix the replicator subtype value
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Kaixu Xia <xiakaixu@huawei.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kaixu Xia <kaixu.xia@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 January 2015 at 01:32, Kaixu Xia <xiakaixu@huawei.com> wrote:
> According to the classification, the type of replicator
> is link, so the subtype should also be link_subtype.
>
> Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
> ---
>  drivers/coresight/coresight-replicator.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/coresight/coresight-replicator.c b/drivers/coresight/coresight-replicator.c
> index a2dfcf9..cdf0553 100644
> --- a/drivers/coresight/coresight-replicator.c
> +++ b/drivers/coresight/coresight-replicator.c
> @@ -87,7 +87,7 @@ static int replicator_probe(struct platform_device *pdev)
>                 return -ENOMEM;
>
>         desc->type = CORESIGHT_DEV_TYPE_LINK;
> -       desc->subtype.sink_subtype = CORESIGHT_DEV_SUBTYPE_LINK_SPLIT;
> +       desc->subtype.link_subtype = CORESIGHT_DEV_SUBTYPE_LINK_SPLIT;
>         desc->ops = &replicator_cs_ops;
>         desc->pdata = pdev->dev.platform_data;
>         desc->dev = &pdev->dev;

Applied  - thanks.

> --
> 1.8.5.5
>
