Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab3L2WDD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 17:03:03 -0500
Received: from mail-gg0-f181.google.com ([209.85.161.181]:64600 "EHLO
	mail-gg0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab3L2WDA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 17:03:00 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Andrew Bresticker <abrestic@chromium.org>,
        "Stephen Warren" <swarren@wwwdotorg.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
Cc: "Thierry Reding" <thierry.reding@gmail.com>,
        "Peter De Schrijver" <pdeschrijver@nvidia.com>,
        "Prashant Gaikwad" <pgaikwad@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Andrew Bresticker" <abrestic@chromium.org>
References: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
Message-ID: <20131229220233.12054.64110@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 0/7] misc Tegra clock fixes
Date: Sun, 29 Dec 2013 14:02:33 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Bresticker (2013-12-26 16:44:20)
> Fixes for various clock-related issues found during bringup of
> Tegra124-based Venice2 and Norrin boards.

Acked-by: Mike Turquette <mturquette@linaro.org>

> 
> Andrew Bresticker (3):
>   clk: tegra: fix sdmmc clks on Tegra1x4
>   clk: tegra: cclk_lp has a pllx/2 divider
>   clk: tegra: use max divider if divider overflows
> 
> David Ung (1):
>   clk: tegra: PLLD2 fixes for hdmi
> 
> Gabe Black (1):
>   clk: tegra: Fix PLLP rate table
> 
> Mark Zhang (1):
>   clk: tegra: fix host1x clock on Tegra124
> 
> Rhyland Klein (1):
>   clk: tegra: Fix PLLD mnp table
> 
>  drivers/clk/tegra/clk-divider.c          |  2 +-
>  drivers/clk/tegra/clk-id.h               |  4 +++
>  drivers/clk/tegra/clk-tegra-periph.c     |  4 +++
>  drivers/clk/tegra/clk-tegra-super-gen4.c |  2 +-
>  drivers/clk/tegra/clk-tegra114.c         |  8 +++---
>  drivers/clk/tegra/clk-tegra124.c         | 46 +++++++++++++++++++-------------
>  6 files changed, 41 insertions(+), 25 deletions(-)
> 
> -- 
> 1.8.5.1
> 
