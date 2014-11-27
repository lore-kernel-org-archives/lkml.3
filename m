Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbaK0Mdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:33:46 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:39010 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782AbaK0Mdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:33:42 -0500
Date: Thu, 27 Nov 2014 12:33:34 +0000
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, broonie@kernel.org, kernel@stlinux.com,
        linux-spi@vger.kernel.org
Subject: Re: [STLinux Kernel] [PATCH 1/4] spi: Add new driver for
 STMicroelectronics' SPI Controller
Message-ID: <20141127123334.GA20048@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1417088636-11994-1-git-send-email-lee.jones@linaro.org>
 <1417088636-11994-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417088636-11994-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

<snip>

> +static int spi_st_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct device *dev = &pdev->dev;
> +	struct spi_master *master;
> +	struct resource *res;
> +	struct spi_st *spi_st;
> +	int num_cs, cs_gpio, i, ret = 0;
> +	u32 var;
> +	
> +	printk("LEE: %s: %s()[%d]: Probing\n", __FILE__, __func__, __LINE__);

You've left a debug print in here.

regards,

Peter.
