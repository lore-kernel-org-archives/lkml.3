Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3JSQDc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 12:03:32 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:37248 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3JSQD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 12:03:29 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: rjw@sisk.pl, kgene.kim@samsung.com, mturquette@linaro.org
Cc: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>, viresh.kumar@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        kyungmin.park@samsung.com, ben-linux@fluff.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        thomas.abraham@linaro.org, s.nawrocki@samsung.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        t.stanislaws@samsung.com, m.szyprowski@samsung.com,
        b.zolnierkie@samsung.com
Subject: Re: [PATCH v5 0/3] ARM: S5PV210: move to common clk framework
Date: Sat, 19 Oct 2013 18:03:26 +0200
Message-ID: <1816869.ggMDlA1qNY@flatron>
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1380027009-2239-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1380027009-2239-1-git-send-email-m.krawczuk@partner.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike, Kukjin, Rafael,

On Tuesday 24 of September 2013 14:50:06 Mateusz Krawczuk wrote:
> This patch series is the new s5pv210 clock implementation
> (using common clk framework).
> 
> This implementation is compatible with device tree definition and board
> files.
> 
> This patch series is based on linux-next and has been tested on goni and
> aquila
> boards using board file.
> 
> Since v4:
> Corrected mux flags for finpll.
> 
> Since v3:
> 
> Replace s5pv210_clk_register_finpll, by creating mux finpll
> with xusbxti and xxti as parrents.
> 
> 
> Mateusz Krawczuk (3):
>   clk: samsung: Add clock driver for s5pc110/s5pv210
>   Cpufreq: s5pv210 cpufreq fixes for CCF
>   ARM: s5pv210: Migrate clock handling to Common Clock Framework
> 
>  .../bindings/clock/samsung,s5pv210-clock.txt       |  75 +++
>  arch/arm/mach-s5pv210/Kconfig                      |   9 +
>  arch/arm/mach-s5pv210/Makefile                     |   4 +-
>  arch/arm/mach-s5pv210/common.c                     |  17 +
>  arch/arm/mach-s5pv210/common.h                     |  10 +
>  arch/arm/mach-s5pv210/mach-goni.c                  |   2 +-
>  arch/arm/mach-s5pv210/mach-smdkv210.c              |   2 +-
>  arch/arm/plat-samsung/Kconfig                      |   2 +-
>  drivers/clk/samsung/Makefile                       |   3 +
>  drivers/clk/samsung/clk-s5pv210.c                  | 673
> +++++++++++++++++++++ drivers/cpufreq/s5pv210-cpufreq.c                
>  |   6 +-
>  include/dt-bindings/clock/samsung,s5pv210-clock.h  | 224 +++++++
>  12 files changed, 1019 insertions(+), 8 deletions(-)
>  create mode 100644
> Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
> create mode 100644 drivers/clk/samsung/clk-s5pv210.c
>  create mode 100644 include/dt-bindings/clock/samsung,s5pv210-clock.h

I believe this series is reasonable to be applied. Could we agree on
the tree it would go through and get all tne required acks?

Best regards,
Tomasz

