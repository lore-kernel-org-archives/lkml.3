Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbaKUJWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:22:08 -0500
Received: from mail-oi0-f42.google.com ([209.85.218.42]:63337 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaKUJWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:22:06 -0500
MIME-Version: 1.0
In-Reply-To: <1416561518-24835-1-git-send-email-Yuantian.Tang@freescale.com>
References: <1416561518-24835-1-git-send-email-Yuantian.Tang@freescale.com>
Date: Fri, 21 Nov 2014 14:52:05 +0530
Message-ID: <CAKohpokKJQV3-b-hqUz7pKgM+SVRBqW=tq54sxpkeAU=Pg73pQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] cpufreq: qoriq: Make the driver usable on all
 QorIQ platforms
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tang Yuantian <Yuantian.Tang@freescale.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        r64188@freescale.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2014 14:48, Tang Yuantian <Yuantian.Tang@freescale.com> wrote:
> Freescale introduced new ARM core-based SoCs which support dynamic
> frequency switch feature. DFS on new SoCs are compatible with current
> PowerPC CoreNet platforms. In order to support those new platforms,
> this driver needs to be updated. The main changes include:
>
> 1. Changed the names of functions in driver.
> 2. Added two new functions get_cpu_physical_id() and get_bus_freq().
> 3. Used a new way to get the CPU mask which share clock wire.
>
> Signed-off-by: Tang Yuantian <Yuantian.Tang@freescale.com>
> ---
> v3:
>         - put the menu entries into Kconfig
> v2:
>         - split the name change into a separete patch
>         - use policy->driver_data instead of per_cpu variable
>
>  drivers/cpufreq/Kconfig               |   8 ++
>  drivers/cpufreq/Kconfig.powerpc       |   9 --
>  drivers/cpufreq/ppc-corenet-cpufreq.c | 160 +++++++++++++++++++++-------------
>  3 files changed, 107 insertions(+), 70 deletions(-)

For both patches:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
