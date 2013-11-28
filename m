Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038Ab3K1OJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:09:15 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19638 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3K1OJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:09:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 28 Nov 2013 06:02:50 -0800
Date: Thu, 28 Nov 2013 16:09:10 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: add TEGRA_DIVIDER_ROUND_UP for periph clks
Message-ID: <20131128140910.GV26617@tbergstrom-lnx.Nvidia.com>
References: <1385484495-9835-1-git-send-email-pdeschrijver@nvidia.com>
 <5294FF83.7040905@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5294FF83.7040905@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 09:07:31PM +0100, Stephen Warren wrote:
> On 11/26/2013 09:48 AM, Peter De Schrijver wrote:
> > Perform upwards rounding when calculating dividers for periph clks on Tegra30
> > and Tegra114.
> 
> Tested-by: Stephen Warren <swarren@nvidia.com>
> 
> I tested audio and SPI on Dalmore and Beaver, using the following branch
> which has this commit integrated:
> git://nv-tegra.nvidia.com/user/pdeschrijver/linux tegra-clk-rework-1

Merged into clk-tegra-next
