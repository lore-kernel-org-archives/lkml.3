Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaFCE1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 00:27:16 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:51059 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaFCE1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 00:27:15 -0400
MIME-Version: 1.0
In-Reply-To: <1401746847-3193-1-git-send-email-sboyd@codeaurora.org>
References: <1401746847-3193-1-git-send-email-sboyd@codeaurora.org>
Date: Tue, 3 Jun 2014 09:57:14 +0530
X-Google-Sender-Auth: Yg4eOzDaFI2-tH10X7xCKn8lT2g
Message-ID: <CAOh2x==wsy2_+GygS03snFN_YOar3eHi7v1a-jNdsQYoWCAZsw@mail.gmail.com>
Subject: Re: [PATCH] ARM: Remove ARCH_HAS_CPUFREQ config option
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2014 at 3:37 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> This config exists entirely to hide the cpufreq menu from the
> kernel configuration unless a platform has selected it. Nothing
> is actually built if this config is 'Y' and it just leads to
> more patches that add a select under a platform Kconfig so that
> some other CPUfreq option can be chosen. Let's remove the
> option so that we can always enable CPUfreq drivers on ARM
> platforms.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/Kconfig               | 18 ------------------
>  arch/arm/mach-davinci/Kconfig  |  1 -
>  arch/arm/mach-highbank/Kconfig |  1 -
>  arch/arm/mach-imx/Kconfig      |  3 ---
>  arch/arm/mach-mvebu/Kconfig    |  1 -
>  arch/arm/mach-omap2/Kconfig    |  1 -
>  arch/arm/mach-shmobile/Kconfig |  2 --
>  arch/arm/mach-spear/Kconfig    |  1 -
>  arch/arm/mach-tegra/Kconfig    |  1 -
>  arch/arm/mach-ux500/Kconfig    |  1 -
>  arch/arm/mach-vexpress/Kconfig |  1 -
>  arch/arm/mach-vt8500/Kconfig   |  1 -
>  arch/arm/mach-zynq/Kconfig     |  1 -
>  13 files changed, 33 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

While you are at it, please see if you can also fix unicore as well.
