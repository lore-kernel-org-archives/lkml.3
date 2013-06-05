Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab3FEP5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:57:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37906 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab3FEP5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:57:05 -0400
Message-ID: <51AF5FCE.6090501@wwwdotorg.org>
Date: Wed, 05 Jun 2013 09:57:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] clk: tegra: override bits for Tegra114 PLLM
References: <1370441329-8619-1-git-send-email-pdeschrijver@nvidia.com> <1370441329-8619-3-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1370441329-8619-3-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 08:08 AM, Peter De Schrijver wrote:

Commit description?

> diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c

> +#ifdef CONFIG_PM_SLEEP
> +static struct cpu_clk_suspend_context {
> +	u32 clk_csite_src;
> +} tegra114_cpu_clk_sctx;
> +#endif

That generates:

drivers/clk/tegra/clk-tegra114.c:263:3: warning: ‘tegra114_cpu_clk_sctx’
defined but not used [-Wunused-variable]
