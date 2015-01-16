Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbbAPUMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 15:12:38 -0500
Received: from mail-oi0-f47.google.com ([209.85.218.47]:42299 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbbAPUMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 15:12:37 -0500
MIME-Version: 1.0
In-Reply-To: <1421308459-71865-1-git-send-email-xiakaixu@huawei.com>
References: <1421308459-71865-1-git-send-email-xiakaixu@huawei.com>
Date: Fri, 16 Jan 2015 13:12:36 -0700
Message-ID: <CANLsYky1RZN8-kX==G159DSbSan=ZUOevs5taKABSrHaiPjLxA@mail.gmail.com>
Subject: Re: [PATCH] coresight: remove the extra spaces
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Kaixu Xia <xiakaixu@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kaixu Xia <kaixu.xia@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 January 2015 at 00:54, Kaixu Xia <xiakaixu@huawei.com> wrote:
> There are some extra spaces, so just remove them from these lines.
>
> Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
> ---
>  drivers/coresight/coresight-etb10.c | 2 +-
>  drivers/coresight/coresight.c       | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/coresight/coresight-etb10.c b/drivers/coresight/coresight-etb10.c
> index c922d4a..d0529b5 100644
> --- a/drivers/coresight/coresight-etb10.c
> +++ b/drivers/coresight/coresight-etb10.c
> @@ -454,7 +454,7 @@ static int etb_probe(struct amba_device *adev, const struct amba_id *id)
>         if (ret)
>                 return ret;
>
> -       drvdata->buffer_depth =  etb_get_buffer_depth(drvdata);
> +       drvdata->buffer_depth = etb_get_buffer_depth(drvdata);
>         clk_disable_unprepare(drvdata->clk);
>
>         if (drvdata->buffer_depth < 0)
> diff --git a/drivers/coresight/coresight.c b/drivers/coresight/coresight.c
> index 11968b7..0de0c39 100644
> --- a/drivers/coresight/coresight.c
> +++ b/drivers/coresight/coresight.c
> @@ -498,7 +498,7 @@ static int coresight_orphan_match(struct device *dev, void *data)
>          * Circle throuch all the connection of that component.  If we find
>          * an orphan connection whose name matches @csdev, link it.
>          */
> -       for (i = 0; i < i_csdev->nr_outport; i++)       {
> +       for (i = 0; i < i_csdev->nr_outport; i++) {
>                 conn = &i_csdev->conns[i];
>
>                 /* We have found at least one orphan connection */
> --
> 1.8.5.5
>

Applied - thanks.
