Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab3FFIQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:16:16 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6225 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab3FFIQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:16:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 06 Jun 2013 01:15:45 -0700
Date: Thu, 6 Jun 2013 11:15:42 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] clk: tegra: override bits for Tegra114 PLLM
Message-ID: <20130606081542.GS3847@tbergstrom-lnx.Nvidia.com>
References: <1370441329-8619-1-git-send-email-pdeschrijver@nvidia.com>
 <1370441329-8619-3-git-send-email-pdeschrijver@nvidia.com>
 <51AF5FCE.6090501@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <51AF5FCE.6090501@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 05:57:02PM +0200, Stephen Warren wrote:
> On 06/05/2013 08:08 AM, Peter De Schrijver wrote:
> 
> Commit description?
> 
> > diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
> 
> > +#ifdef CONFIG_PM_SLEEP
> > +static struct cpu_clk_suspend_context {
> > +	u32 clk_csite_src;
> > +} tegra114_cpu_clk_sctx;
> > +#endif
> 
> That generates:
> 
> drivers/clk/tegra/clk-tegra114.c:263:3: warning: ‘tegra114_cpu_clk_sctx’
> defined but not used [-Wunused-variable]

Ah. This should not be part of this patch indeed...

Cheers,

Peter.
