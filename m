Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbaISLpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:45:32 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8836 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098AbaISLp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:45:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 19 Sep 2014 04:45:41 -0700
Date: Fri, 19 Sep 2014 14:45:25 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH] clk: tegra: Make clock initialization more robust
Message-ID: <20140919114525.GP26779@tbergstrom-lnx.Nvidia.com>
References: <1410946457-24669-1-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410946457-24669-1-git-send-email-tomeu.vizoso@collabora.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 11:34:17AM +0200, Tomeu Vizoso wrote:
> Don't abort clock initialization if we cannot match an entry in
> tegra_clk_init_table to a valid entry in the clk array.
> 
> Also log a corresponding error message.
> 
> This was discovered when testing a patch that removed the EMC clock from
> tegra124_clks but left a mention in tegra_clk_init_table.
> 
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>  drivers/clk/tegra/clk.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)

Looks fine to me. Merged into tegra-clk-next.
