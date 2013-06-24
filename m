Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3FXNNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:13:21 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49090 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab3FXNK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:10:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [GIT PULL] ARM: CPUFreq updates for 3.11
Date: Mon, 24 Jun 2013 15:20:23 +0200
Message-ID: <2762325.xSxJKsi0Kg@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpo=3DHa0+3trrL7b1JVhxrXLtERX9kth5AjLGu7Tf6Adig@mail.gmail.com>
References: <CAKohpo=v4qPDH32Y4ithr_p007nTn5AOUzkUCiHTGgQN6-=BEw@mail.gmail.com> <1662523.HdXbLYrd2q@vostro.rjw.lan> <CAKohpo=3DHa0+3trrL7b1JVhxrXLtERX9kth5AjLGu7Tf6Adig@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 24, 2013 06:20:35 PM Viresh Kumar wrote:
> On 24 June 2013 17:15, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Well, it should go last.  Also I'd prefer to apply it directly.
> 
> Okay.. Below is pull request for ARM patches alone.

Pulled, thanks!

> The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:
> 
>   Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)
> 
> are available in the git repository at:
> 
>   git://git.linaro.org/people/vireshk/linux.git cpufreq-fix-notification-arm
> 
> for you to fetch changes up to f56cc99e3f189ce214408e9c0fdda9e664d83dc1:
> 
>   cpufreq: tegra: call CPUFREQ_POSTCHANGE notfier in error cases
> (2013-06-24 18:19:01 +0530)
> 
> ----------------------------------------------------------------
> Viresh Kumar (8):
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
>  drivers/cpufreq/davinci-cpufreq.c |  3 +++
>  drivers/cpufreq/dbx500-cpufreq.c  |  4 ++--
>  drivers/cpufreq/exynos-cpufreq.c  | 10 ++++++++--
>  drivers/cpufreq/imx6q-cpufreq.c   | 17 +++++++++++------
>  drivers/cpufreq/omap-cpufreq.c    |  6 +++---
>  drivers/cpufreq/s3c64xx-cpufreq.c |  8 ++++++--
>  drivers/cpufreq/tegra-cpufreq.c   |  4 ++--
>  8 files changed, 36 insertions(+), 20 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
