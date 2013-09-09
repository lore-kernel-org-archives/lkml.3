Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab3IIQDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:03:36 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:51577 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab3IIQDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:03:34 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] irq/of: Fix comment typo for irq_of_parse_and_map
To: Yijing Wang <wangyijing@huawei.com>, Rob Herring <rob.herring@calxeda.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
In-Reply-To: <1377913450-30108-1-git-send-email-wangyijing@huawei.com>
References: <1377913450-30108-1-git-send-email-wangyijing@huawei.com>
Date: Mon, 09 Sep 2013 17:03:35 +0100
Message-Id: <20130909160335.2E26A3E0F23@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Aug 2013 09:44:10 +0800, Yijing Wang <wangyijing@huawei.com> wrote:
> Fix trivial comment typo for irq_of_parse_and_map().
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

Applied, thanks.

g.

> ---
>  drivers/of/irq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index 1264923..1752988 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -28,7 +28,7 @@
>  
>  /**
>   * irq_of_parse_and_map - Parse and map an interrupt into linux virq space
> - * @device: Device node of the device whose interrupt is to be mapped
> + * @dev: Device node of the device whose interrupt is to be mapped
>   * @index: Index of the interrupt to map
>   *
>   * This function is a wrapper that chains of_irq_map_one() and
> -- 
> 1.7.1
> 
> 

