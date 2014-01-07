Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaAGMy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:54:29 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1183 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaAGMyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:54:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 07 Jan 2014 04:54:28 -0800
Date: Tue, 7 Jan 2014 14:54:04 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Wolfram Sang <wsa@the-dreams.de>,
        "Prashant Gaikwad" <pgaikwad@nvidia.com>
Subject: Re: [PATCH v2 1/6] ARM: tegra: export apb dma readl/writel
Message-ID: <20140107125404.GD26588@tbergstrom-lnx.Nvidia.com>
References: <1387891931-9854-1-git-send-email-pdeschrijver@nvidia.com>
 <1387891931-9854-2-git-send-email-pdeschrijver@nvidia.com>
 <52CB0CFE.4070901@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52CB0CFE.4070901@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 09:07:26PM +0100, Stephen Warren wrote:
> On 12/24/2013 06:32 AM, Peter De Schrijver wrote:
> > Export APB DMA readl and writel. These are needed because we can't access
> > the fuses directly on Tegra20 without potentially causing a system hang.
> 
> This does a lot more than just export the functions; it also changes the
> prototypes. I'm not sure why the prototype change was required/useful.
> This needs to be mentioned in the commit description/subject, and the
> reasoning explained too.
> 
> > diff --git a/include/linux/tegra-soc.h b/include/linux/tegra-soc.h
> 
> > +#if defined(CONFIG_TEGRA20_APB_DMA)
> > +void tegra_apb_io_init(void);
> 
> This seems to be an internal function; why is this one publicly
> prototyped and/or stubbed?
> 

Ah. this might be a leftover from a previous iteration... Need to check.
