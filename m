Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab3LLVag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 16:30:36 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:56966 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3LLVab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 16:30:31 -0500
MIME-Version: 1.0
In-Reply-To: <1386659456-16887-2-git-send-email-ldewangan@nvidia.com>
References: <1386659456-16887-1-git-send-email-ldewangan@nvidia.com>
	<1386659456-16887-2-git-send-email-ldewangan@nvidia.com>
Date: Thu, 12 Dec 2013 22:30:30 +0100
Message-ID: <CACRpkdbv8r68r5Lz19sqVq8g7Yk__DbjLgW9c6P6HGtWNj6M=Q@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] pinctrl: tegra: add pinmux controller driver for Tegra124
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ashwini Ghuge <aghuge@nvidia.com>, Thierry Reding <treding@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 8:10 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

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
>         - Cleanups in patches.
> ldewangan:
>         - Fix some entries for groups.
>         - Fix MUX enums and group sequence.
>
> Signed-off-by: Ashwini Ghuge <aghuge@nvidia.com>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Acked-by: Stephen Warren <swarren@nvidia.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> CC: Thierry Reding <treding@nvidia.com>
> ---
> Changes from V1:
> - Lots of cleanups and fixes for string separator by Thierry.
> - Fixes for some of group entries.
> Changes from V2:
> - remove extra space.
> - Added Ack and Tested by: Stephen and cc to Thierry.

Applied this v3 version, thanks!

Yours,
Linus Walleij
