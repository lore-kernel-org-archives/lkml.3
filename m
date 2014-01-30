Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaA3BVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 20:21:39 -0500
Received: from yotta.elopez.com.ar ([31.220.24.173]:59807 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaA3BVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 20:21:38 -0500
Message-ID: <52E9A8F0.8030901@elopez.com.ar>
Date: Wed, 29 Jan 2014 22:20:48 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: linux-sunxi@googlegroups.com, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com
Subject: Re: [linux-sunxi] [PATCH v2 3/5] spi: sunxi: Add Allwinner A31 SPI
 controller driver
References: <1390993850-9054-1-git-send-email-maxime.ripard@free-electrons.com> <1390993850-9054-4-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1390993850-9054-4-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

El 29/01/14 08:10, Maxime Ripard escribió:
> The Allwinner A31 has a new SPI controller IP compared to the older Allwinner
> SoCs.
>
> It supports DMA, but the driver only does PIO for now, and DMA will be
> supported eventually.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
(snip)
> +	struct sun6i_spi *sspi = spi_master_get_devdata(master);
> +	int ret;
> +
> +	ret = clk_prepare_enable(sspi->hclk);
> +	if (ret) {
> +		dev_err(dev, "Couldn't enable clock 'ahb spi'\n");
> +		goto out;
> +	}
> +
> +	ret = clk_prepare_enable(sspi->mclk);
> +	if (ret) {
> +		dev_err(dev, "Couldn't enable clock 'ahb spi'\n");

A different message would be nice :)

Cheers,

Emilio
