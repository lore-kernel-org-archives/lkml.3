Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3FXKkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:40:03 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48911 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab3FXKkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:40:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [GIT PULL] ARM: CPUFreq updates for 3.11
Date: Mon, 24 Jun 2013 12:49:26 +0200
Message-ID: <1524748.bV9OZAOR0D@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpo=v4qPDH32Y4ithr_p007nTn5AOUzkUCiHTGgQN6-=BEw@mail.gmail.com>
References: <CAKohpo=v4qPDH32Y4ithr_p007nTn5AOUzkUCiHTGgQN6-=BEw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 24, 2013 11:20:35 AM Viresh Kumar wrote:
> Hi Rafael,
> 
> This is part of my patchset "CPUFreq: Fix {PRE|POST}CHANGE notification
> sequence". It contains changes specific to cpufreq core and ARM drivers.
> 
> I have left changes to non-ARM cpufreq drivers from this pull request. See if
> you can take them for 3.11.
> 
> The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:
> 
>   Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)
> 
> are available in the git repository at:
> 
>   git://git.linaro.org/people/vireshk/linux.git cpufreq-fix-notification-arm
> 
> for you to fetch changes up to f2d65dd0d573e6961165f0be35bac84997b9e707:

Well, this contains changes that aren't specific to ARM as far as I can say.

Not pulled.

Thanks,
Rafael


>   cpufreq: tegra: call CPUFREQ_POSTCHANGE notfier in error cases
> (2013-06-24 11:14:24 +0530)
> 
> ----------------------------------------------------------------
> Viresh Kumar (9):
>       cpufreq: make sure frequency transitions are serialized
>       cpufreq: arm-big-little: call CPUFREQ_POSTCHANGE notfier in error cases
>       cpufreq: davinci: call CPUFREQ_POSTCHANGE notfier in error cases
>       cpufreq: dbx500: call CPUFREQ_POSTCHANGE notfier in error cases
>       cpufreq: exynos: call CPUFREQ_POSTCHANGE notfier in error cases
>       cpufreq: imx6q: call CPUFREQ_POSTCHANGE notfier in error cases
>       cpufreq: omap: call CPUFREQ_POSTCHANGE notfier in error cases
>       cpufreq: s3c64xx: call CPUFREQ_POSTCHANGE notfier in error cases
>       cpufreq: tegra: call CPUFREQ_POSTCHANGE notfier in error cases
> 
>  drivers/cpufreq/arm_big_little.c  |  4 +---
>  drivers/cpufreq/cpufreq.c         |  9 +++++++++
>  drivers/cpufreq/davinci-cpufreq.c |  3 +++
>  drivers/cpufreq/dbx500-cpufreq.c  |  4 ++--
>  drivers/cpufreq/exynos-cpufreq.c  | 10 ++++++++--
>  drivers/cpufreq/imx6q-cpufreq.c   | 17 +++++++++++------
>  drivers/cpufreq/omap-cpufreq.c    |  6 +++---
>  drivers/cpufreq/s3c64xx-cpufreq.c |  8 ++++++--
>  drivers/cpufreq/tegra-cpufreq.c   |  4 ++--
>  9 files changed, 45 insertions(+), 20 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
