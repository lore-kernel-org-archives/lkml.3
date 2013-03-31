Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab3CaDyK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 23:54:10 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:64122 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab3CaDyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 23:54:06 -0400
MIME-Version: 1.0
In-Reply-To: <87d2cd71a29fb826efe15a3d97cc3444031387c0.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
	<87d2cd71a29fb826efe15a3d97cc3444031387c0.1364205812.git.viresh.kumar@linaro.org>
Date: Sun, 31 Mar 2013 09:24:05 +0530
Message-ID: <CAKohpomQPkgk+BRaE5bC-TTveDB97qUmL0MST9um2WLtAXbOkQ@mail.gmail.com>
Subject: Re: [PATCH 9/9] cpufreq: sa11x0: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: linux@arm.linux.org.uk
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 March 2013 15:41, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> This patch moves cpufreq driver of ARM based sa11x0 platform to drivers/cpufreq.
>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  arch/arm/Kconfig                                   |  8 -------
>  arch/arm/mach-sa1100/Kconfig                       | 26 +++++++++++-----------
>  arch/arm/mach-sa1100/Makefile                      |  3 ---
>  arch/arm/mach-sa1100/include/mach/generic.h        |  1 +
>  drivers/cpufreq/Kconfig.arm                        |  6 +++++
>  drivers/cpufreq/Makefile                           |  2 ++
>  .../cpufreq/sa1100-cpufreq.c                       |  3 +--
>  .../cpufreq/sa1110-cpufreq.c                       |  3 +--
>  8 files changed, 24 insertions(+), 28 deletions(-)
>  create mode 100644 arch/arm/mach-sa1100/include/mach/generic.h
>  rename arch/arm/mach-sa1100/cpu-sa1100.c => drivers/cpufreq/sa1100-cpufreq.c (99%)
>  rename arch/arm/mach-sa1100/cpu-sa1110.c => drivers/cpufreq/sa1110-cpufreq.c (99%)

For this one too :)
