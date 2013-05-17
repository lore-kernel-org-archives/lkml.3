Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab3EQWyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:54:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51037 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab3EQWyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 18:54:52 -0400
Message-ID: <5196B539.4040708@wwwdotorg.org>
Date: Fri, 17 May 2013 16:54:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Use common of_clk_init() function
References: <1365066351-2395-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1365066351-2395-1-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 03:05 AM, Prashant Gaikwad wrote:
> Use common of_clk_init() function for clocks initialization.

Prashant, can you please resend this to Mike for inclusion in 3.11; now
that we have moved the Tegra clock driver out of arch/arm/mach-tegra, we
should send all clock driver changes through Mike if possible. Thanks.

Just one question though:

> diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c

> -#include <linux/clk/tegra.h>
> +#include <linux/clk-provider.h>

Is clk-provider.h the right header? This code isn't a clock provider?
