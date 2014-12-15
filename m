Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbaLOKmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:42:32 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:46263 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaLOKma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:42:30 -0500
MIME-Version: 1.0
In-Reply-To: <1418404738-19124-1-git-send-email-nm@ti.com>
References: <1418404738-19124-1-git-send-email-nm@ti.com>
Date: Mon, 15 Dec 2014 11:42:28 +0100
X-Google-Sender-Auth: rk6wfbaVsMbm_8OoB5OOYMdMVW0
Message-ID: <CAMuHMdW4CQz_n8b4-JOogDvc6ggBjWrFWcqr4Tezojj+mJD6pw@mail.gmail.com>
Subject: Re: [PATCH] ARM: omap2plus_defconfig: use CONFIG_CPUFREQ_DT
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Nishanth Menon <nm@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Simon Horman <horms@verge.net.au>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 6:18 PM, Nishanth Menon <nm@ti.com> wrote:
> CONFIG_GENERIC_CPUFREQ_CPU0 disappeared with commit bbcf071969b20f
> ("cpufreq: cpu0: rename driver and internals to 'cpufreq_dt'")
>
> Use the renamed CONFIG_CPUFREQ_DT generic driver. It looks like with
> v3.18-rc1, commit bbcf071969b20f and fdc509b15eb3eb came in via
> different trees causing the resultant v3.18-rc1 to be non-functional for
> cpufreq as default supported with omap2plus_defconfig.
>
> Fixes: fdc509b15eb3eb ("ARM: omap2plus_defconfig: Add cpufreq to defconfig")
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>
> NOTE: as of v3.18 tag, The following still need to be fixed - I do not have all
> the platforms impacted to make a generic change, so CCying folks who might be interested
>
> arch/arm/configs/shmobile_defconfig:CONFIG_GENERIC_CPUFREQ_CPU0=y

Thanks!

FTR: this has been fixed in Simon's defconfig-for-v3.20 branch.

> arch/arm/configs/multi_v7_defconfig:CONFIG_GENERIC_CPUFREQ_CPU0=y

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
