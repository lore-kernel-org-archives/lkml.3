Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3ARPPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:15:38 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:49468 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3ARPPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:15:36 -0500
MIME-Version: 1.0
In-Reply-To: <1357630357-7309-2-git-send-email-ldewangan@nvidia.com>
References: <1357630357-7309-1-git-send-email-ldewangan@nvidia.com>
	<1357630357-7309-2-git-send-email-ldewangan@nvidia.com>
Date: Fri, 18 Jan 2013 16:15:35 +0100
Message-ID: <CACRpkdYm8tjhbVofGJA59n78GRpUVBhss6zdQ8gDBme-URo=4w@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] pinctrl: tegra114: add pinctrl driver for NVIDIA's
 Tegra114 SoC
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: praithatha@nvidia.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 8:32 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

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

Patch applied, thanks.

Yours,
Linus Walleij
