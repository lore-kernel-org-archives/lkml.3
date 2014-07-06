Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaGFEJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 00:09:49 -0400
Received: from yotta.elopez.com.ar ([31.220.24.173]:54279 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaGFEJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 00:09:48 -0400
Message-ID: <53B8C144.7010208@elopez.com.ar>
Date: Sun, 06 Jul 2014 00:23:48 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: linux-sunxi@googlegroups.com, Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, Arnd Bergmann <arnd@arndb.de>,
        andriy.shevchenko@intel.com, dmaengine@vger.kernel.org
Subject: Re: [linux-sunxi] [PATCH v10 2/2] dmaengine: sun6i: Add driver for
 the Allwinner A31 DMA controller
References: <1404134454-25513-1-git-send-email-maxime.ripard@free-electrons.com> <1404134454-25513-3-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1404134454-25513-3-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

El 30/06/14 10:20, Maxime Ripard escribió:
> The Allwinner A31 has a 16 channels DMA controller that it shares with the
> newer A23. Although sharing some similarities with the DMA controller of the
> older Allwinner SoCs, it's significantly different, I don't expect it to be
> possible to share the driver for these two.
>
> The A31 Controller is able to memory-to-memory or memory-to-device transfers on
> the 16 channels in parallel.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
(...)
> +
> +static struct of_device_id sun6i_dma_match[] = {
> +	{ .compatible = "allwinner,sun6i-a31-dma" }
> +};

The empty sentinel is missing here

Cheers,

Emilio
