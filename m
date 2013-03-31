Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab3CaHaZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 03:30:25 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:40254 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab3CaHaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 03:30:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponJJKDcFXK-Zs-eCS2=v3=-CrkEqF1FaHz64D-kq888BA@mail.gmail.com>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
	<2641a3f059f1698ee6825c7b6bfe25a3937e1474.1364229828.git.viresh.kumar@linaro.org>
	<20130325.130745.670476511400589185.davem@davemloft.net>
	<CAKohpomnOaVG1xktDL=YGz6yM2vFoYVF2Un-9_zL7owiJVG6gw@mail.gmail.com>
	<CAKohponJJKDcFXK-Zs-eCS2=v3=-CrkEqF1FaHz64D-kq888BA@mail.gmail.com>
Date: Sun, 31 Mar 2013 13:00:21 +0530
Message-ID: <CAKohpokGRPJGPh8e_NjpZQRTWOxk=SGzhcNbjkHWAKE-Gfig9g@mail.gmail.com>
Subject: Re: [PATCH 8/9] spark: cpufreq: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: David Miller <davem@davemloft.net>
Cc: rjw@sisk.pl, arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, arnd.bergmann@linaro.org,
        sparclinux@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2013 09:55, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> From: Viresh Kumar <viresh.kumar@linaro.org>
> Date: Mon, 25 Mar 2013 11:20:23 +0530
> Subject: [PATCH] sparc: cpufreq:  move cpufreq driver to drivers/cpufreq
>
> This patch moves cpufreq driver of SPARC architecture to drivers/cpufreq.
>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: sparclinux@vger.kernel.org
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  arch/sparc/Kconfig                                 | 23 ----------------------
>  arch/sparc/kernel/Makefile                         |  3 ---
>  drivers/cpufreq/Kconfig                            | 23 ++++++++++++++++++++++
>  drivers/cpufreq/Makefile                           |  2 ++
>  .../cpufreq/sparc-us2e-cpufreq.c                   |  0
>  .../cpufreq/sparc-us3-cpufreq.c                    |  0
>  6 files changed, 25 insertions(+), 26 deletions(-)
>  rename arch/sparc/kernel/us2e_cpufreq.c =>
> drivers/cpufreq/sparc-us2e-cpufreq.c (100%)
>  rename arch/sparc/kernel/us3_cpufreq.c =>
> drivers/cpufreq/sparc-us3-cpufreq.c (100%)

Hi David,

Does this one look fine to you?
