Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbaAHW2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:28:43 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:53469 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaAHW2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:28:39 -0500
MIME-Version: 1.0
In-Reply-To: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
References: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
Date: Wed, 8 Jan 2014 14:28:37 -0800
X-Google-Sender-Auth: CtDbK8Pw60HJjEF5iWmYRigVR-Q
Message-ID: <CAL1qeaG0Y4__viWsZeoFdf8XFN3Wk7CO2abeEjzRZg+wNRV56w@mail.gmail.com>
Subject: Re: [PATCH 0/7] misc Tegra clock fixes
From: Andrew Bresticker <abrestic@chromium.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-tegra@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Bresticker <abrestic@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen, Peter,

> Fixes for various clock-related issues found during bringup of
> Tegra124-based Venice2 and Norrin boards.
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

Any comments on this series?

Thanks!
Andrew
