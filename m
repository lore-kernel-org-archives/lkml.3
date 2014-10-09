Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbaJIBab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 21:30:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50952 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaJIBaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 21:30:24 -0400
Message-ID: <5435E52D.1030806@codeaurora.org>
Date: Wed, 08 Oct 2014 18:30:21 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Alex Elder <elder@linaro.org>, Matt Porter <mporter@linaro.org>,
        Tim Kryger <tim.kryger@linaro.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Jaehoon Chung <jh80.chung@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 6/8] clk: Change clk_ops->determine_rate to return
 a clk_hw as the best parent
References: <1412695334-2608-1-git-send-email-tomeu.vizoso@collabora.com> <1412695334-2608-7-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1412695334-2608-7-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 08:21 AM, Tomeu Vizoso wrote:
> This is in preparation for clock providers to not have to deal with struct clk.
>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>   drivers/clk/at91/clk-programmable.c |  4 ++--
>   drivers/clk/bcm/clk-kona.c          |  4 ++--
>   drivers/clk/clk-composite.c         |  9 +++++----
>   drivers/clk/clk.c                   | 11 +++++++----
>   drivers/clk/hisilicon/clk-hi3620.c  |  2 +-
>   drivers/clk/qcom/clk-rcg.c          | 20 ++++++++++++--------
>   drivers/clk/qcom/clk-rcg2.c         | 28 +++++++++++++++++-----------
>   drivers/clk/sunxi/clk-factors.c     |  4 ++--
>   drivers/clk/sunxi/clk-sun6i-ar100.c |  4 ++--
>   include/linux/clk-provider.h        |  4 ++--
>   10 files changed, 52 insertions(+), 38 deletions(-)

What is this based on? I see one in arch/mips/alchemy/common/clock.c as 
well.

Can you also update Documentation/clk.txt please?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

