Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab3AQJEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:04:00 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15806 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab3AQJD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:03:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 17 Jan 2013 01:03:02 -0800
Message-ID: <50F7BE61.2030700@nvidia.com>
Date: Thu, 17 Jan 2013 14:33:29 +0530
From: Pritesh Raithatha <praithatha@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2 2/2] pinctrl: tegra114: add pinctrl driver for NVIDIA's
 Tegra114 SoC
References: <1357630357-7309-1-git-send-email-ldewangan@nvidia.com> <1357630357-7309-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1357630357-7309-2-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2013 01:02 PM, Laxman Dewangan wrote:
> From: Pritesh Raithatha <praithatha@nvidia.com>
> 
> This adds a driver for the Tegra114 pinmux, and required
> parameterization data for Tegra114.
> 
> The driver uses the common Tegra pincontrol driver utility
> functions to implement the majority of the driver.
> 
> This driver is not compatible with the earlier NVIDIA's SoCs,
> hence add new compatibile as "nvidia,tegra114-pinmux".
> 
> Originally written by Pritesh.
> ldewangan:
>         - cleanup the patches,
>         - remove non-require tables.
>         - Use module_platform_driver() for driver registartion.
> 
> Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> ---
> Changes from V1:
> - Converted arch_init() to module_platform_driver().
> - added Stephen in reviewed-by.

The series,

Acked-by: Pritesh Raithatha <praithatha@nvidia.com>
