Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3H0Ald (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 20:41:33 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35850 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab3H0Alb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 20:41:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joseph Lo <josephl@nvidia.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [GIT PULL]: CPUFreq: ARM Fixes for 3.12
Date: Tue, 27 Aug 2013 02:52:10 +0200
Message-ID: <1633112.3VJ8iVoDW6@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpo=2msHhAWqqe==yLCszE5U6ccSti31E82eovkb4emJd5A@mail.gmail.com>
References: <CAKohpoksNiGT+r3JTY6KFwnDFA5OYE-vQe8W_9GT-fN21UMrfQ@mail.gmail.com> <CAKohpo=2msHhAWqqe==yLCszE5U6ccSti31E82eovkb4emJd5A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 26, 2013 07:36:56 PM Viresh Kumar wrote:
> On 26 August 2013 11:48, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > Hi Rafael,
> >
> > Hopefully this is the last patch for 3.12 for ARM CPUFreq subsystem.
> 
> Another last minute patch from Sascha..
> 
> -----------x------------------x------------------
> 
> The following changes since commit b36f4be3de1b123d8601de062e7dbfc904f305fb:
> 
>   Linux 3.11-rc6 (2013-08-18 14:36:53 -0700)
> 
> are available in the git repository at:
> 
>   git://git.linaro.org/people/vireshk/linux.git cpufreq-fixes
> 
> for you to fetch changes up to fae19b84724ff93c1ac59ce1eecc1411f8269d9e:
> 
>   cpufreq: imx6q: Fix clock enable balance (2013-08-26 19:34:07 +0530)
> 
> ----------------------------------------------------------------
> Joseph Lo (1):
>       cpufreq: tegra: fix the wrong clock name
> 
> Sascha Hauer (1):
>       cpufreq: imx6q: Fix clock enable balance

Pulled, thanks Viresh!

