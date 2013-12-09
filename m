Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456Ab3LIS1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:27:45 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:45861 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760593Ab3LIS1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:27:42 -0500
Message-ID: <52A60B9A.7010709@wwwdotorg.org>
Date: Mon, 09 Dec 2013 11:27:38 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, linus.walleij@linaro.org
CC: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        thierry.reding@gmail.com, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ashwini Ghuge <aghuge@nvidia.com>
Subject: Re: [PATCH V2 2/2] pinctrl: tegra: add pinmux controller driver for
 Tegra124
References: <1386585140-1137-1-git-send-email-ldewangan@nvidia.com> <1386585140-1137-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1386585140-1137-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 03:32 AM, Laxman Dewangan wrote:
> From: Ashwini Ghuge <aghuge@nvidia.com>
> 
> This adds a driver for the Tegra124 pinmux, and required
> parameterization data for Tegra124.
> 
> The driver uses the common Tegra pincontrol driver utility
> functions to implement the majority of the driver.
> 
> This driver is not compatible with the earlier NVIDIA's SoCs,
> hence add new compatibile as "nvidia,tegra124-pinmux".
> 
> Originally written by Ashwini Gguhe.
> Thierry:
> 	- Cleanups in patches.
> ldewangan:
>         - Fix some entries for groups.
> 	- Fix MUX enums and group sequence.

> +static const struct pinctrl_pin_desc  tegra124_pins[] = {

Still two spaces there...

BTW, I said the following before for both patches; please make sure you
add this to the commit description...

Acked-by: Stephen Warren <swarren@nvidia.com>

Even if I didn't say it before, it's certainly now,

Tested-by: Stephen Warren <swarren@nvidia.com>

(I also tested your patches that add the pinctrl DT entries to the
Venice2 DT file. Thanks.)
