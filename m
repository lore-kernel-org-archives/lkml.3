Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725AbaD1P1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:27:09 -0400
Received: from yotta.elopez.com.ar ([31.220.24.173]:34482 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932430AbaD1P1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:27:04 -0400
Message-ID: <535E72D6.6060206@elopez.com.ar>
Date: Mon, 28 Apr 2014 12:25:10 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH 5/7] clk: sunxi: add PRCM (Power/Reset/Clock Management)
 clks support
References: <1398697130-8338-1-git-send-email-boris.brezillon@free-electrons.com> <1398697130-8338-6-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1398697130-8338-6-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

El 28/04/14 11:58, Boris BREZILLON escribió:
> The PRCM (Power/Reset/Clock Management) unit provides several clock
> devices:
> - AR100 clk: used to clock the Power Management co-processor
> - AHB0 clk: used to clock the AHB0 bus
> - APB0 clk and gates: used to clk
>
> Add support for these clks in a separate driver so that they can be probed
> as platform devices instead of registered during early init.
> We need this to be able to probe PRCM MFD subdevices.
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
(..)
> +
> +MODULE_AUTHOR("Boris BREZILLON <boris.brezillon@free-electrons.com");

There's a missing >

> +MODULE_DESCRIPTION("Allwinner Reset Controller Driver");

Copy/paste leftover?

> +MODULE_LICENSE("GPL v2");

I just skimmed through this now, I'll have a more detailed look later. 
Thanks for working on sun6i support :)

Cheers,

Emilio
