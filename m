Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab3BAGlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 01:41:49 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:42242 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3BAGlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 01:41:46 -0500
MIME-Version: 1.0
In-Reply-To: <902bed453159832925df76e24806f3b919fdfc74.1359700706.git.viresh.kumar@linaro.org>
References: <1bf82454ab1f16b13212548d7c9605067c8b7a0d.1359700705.git.viresh.kumar@linaro.org>
	<902bed453159832925df76e24806f3b919fdfc74.1359700706.git.viresh.kumar@linaro.org>
Date: Fri, 1 Feb 2013 12:11:46 +0530
Message-ID: <CAKohponi342nGOq2nRYkzkoCcUT3MBdtugm1WifGcCFOBRkYSg@mail.gmail.com>
Subject: Re: [PATCH 3/3] cpufreq: Remove unnecessary use of policy->shared_type
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 February 2013 12:10, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> policy->shared_type field was added only for SoCs with ACPI support:
>
> commit 3b2d99429e3386b6e2ac949fc72486509c8bbe36
> Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Date:   Wed Dec 14 15:05:00 2005 -0500
>
>     P-state software coordination for ACPI core
>
>     http://bugzilla.kernel.org/show_bug.cgi?id=5737
>
> Many non-ACPI systems are filling this field by mistake, which makes its usage
> confusing. Lets clean it.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  arch/arm/mach-tegra/cpu-tegra.c  | 1 -
>  drivers/cpufreq/cpufreq-cpu0.c   | 1 -
>  drivers/cpufreq/db8500-cpufreq.c | 2 --
>  drivers/cpufreq/omap-cpufreq.c   | 4 +---
>  include/linux/cpufreq.h          | 3 ++-
>  5 files changed, 3 insertions(+), 8 deletions(-)

ARM mail servers are broken, please find patch attached.
