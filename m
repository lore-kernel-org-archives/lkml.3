Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaJFVZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:25:44 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:53589 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaJFVZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:25:42 -0400
Date: Mon, 6 Oct 2014 22:25:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Johannes Pointner <johannes.pointner@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mfd: tps65217: add compatible string for
 subdevices
Message-ID: <20141006212536.GH18035@lee--X1>
References: <3292130.zy6yLkolne@lenovobook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3292130.zy6yLkolne@lenovobook>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014, Johannes Pointner wrote:

> Adds of_compatible strings to mfd_cells for sub devices of the tps65217.
> 
> Signed-off-by: Johannes Pointner <johannes.pointner@br-automation.com>
> ---
>  drivers/mfd/tps65217.c | 2 ++
>  1 file changed, 2 insertions(+)

Applied for v3.19.

> diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
> index 3cc4c70..77708f9 100644
> --- a/drivers/mfd/tps65217.c
> +++ b/drivers/mfd/tps65217.c
> @@ -33,9 +33,11 @@
>  static const struct mfd_cell tps65217s[] = {
>  	{
>  		.name = "tps65217-pmic",
> +		.of_compatible = "ti,tps65217-pmic",
>  	},
>  	{
>  		.name = "tps65217-bl",
> +		.of_compatible = "ti,tps65217-bl",
>  	},
>  };
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
