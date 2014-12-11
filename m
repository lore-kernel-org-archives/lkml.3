Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbaLKLTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 06:19:07 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36666 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbaLKLTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 06:19:03 -0500
MIME-Version: 1.0
In-Reply-To: <1418295816-179583-1-git-send-email-long.wanglong@huawei.com>
References: <1418295816-179583-1-git-send-email-long.wanglong@huawei.com>
Date: Thu, 11 Dec 2014 19:19:02 +0800
Message-ID: <CAD6h2NSnU5aLEC2w12FVesvBHoKHg2DNY3Eav-kq7htivu=Z=w@mail.gmail.com>
Subject: Re: [PATCH] irq: irq-hip04: initialize hip04_cpu_map to 0xffff
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Wang Long <long.wanglong@huawei.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        peifeiyue@huawei.com, Xinwei Hu <huxinwei@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 December 2014 at 19:03, Wang Long <long.wanglong@huawei.com> wrote:
> HiP04 GIC extends to support 16 cores, so we should
> initialize the hip04_cpu_map to 0xffff.
>
> Signed-off-by: Wang Long <long.wanglong@huawei.com>
> ---
>  drivers/irqchip/irq-hip04.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/irqchip/irq-hip04.c b/drivers/irqchip/irq-hip04.c
> index 9c8f8335..8eee46b 100644
> --- a/drivers/irqchip/irq-hip04.c
> +++ b/drivers/irqchip/irq-hip04.c
> @@ -382,7 +382,7 @@ hip04_of_init(struct device_node *node, struct device_node *parent)
>          * It will be refined as each CPU probes its ID.
>          */
>         for (i = 0; i < NR_HIP04_CPU_IF; i++)
> -               hip04_cpu_map[i] = 0xff;
> +               hip04_cpu_map[i] = 0xffff;
>
>         /*
>          * Find out how many interrupts are supported.
> --
> 1.8.3.4
>

Acked-by: Haojian Zhuang <haojian.zhuang@linaro.org>

Best Regards
Haojian
