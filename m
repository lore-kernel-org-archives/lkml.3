Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbaCECOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:14:47 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60576 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbaCECOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:14:45 -0500
Date: Wed, 5 Mar 2014 10:14:40 +0800
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, pawell.moll@arm.com
Subject: Re: [PATCH 1/1] mfd: vexpress: Staticize vexpress_config_bridges
Message-ID: <20140305021440.GM10579@lee--X1>
References: <1393926107-9290-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393926107-9290-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> vexpress_config_bridges is local to this file.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/vexpress-config.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/vexpress-config.c b/drivers/mfd/vexpress-config.c
> index 84ce6b9daa3d..0876de04ed4d 100644
> --- a/drivers/mfd/vexpress-config.c
> +++ b/drivers/mfd/vexpress-config.c
> @@ -27,7 +27,7 @@
>  
>  #define VEXPRESS_CONFIG_MAX_BRIDGES 2
>  
> -struct vexpress_config_bridge {
> +static struct vexpress_config_bridge {
>  	struct device_node *node;
>  	struct vexpress_config_bridge_info *info;
>  	struct list_head transactions;

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
