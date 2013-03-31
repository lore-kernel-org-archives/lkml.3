Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab3CaDvZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 23:51:25 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:38550 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab3CaDvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 23:51:24 -0400
MIME-Version: 1.0
In-Reply-To: <fae1030e861c5dfd00df8f03526b0bdc5156de4d.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
	<fae1030e861c5dfd00df8f03526b0bdc5156de4d.1364205812.git.viresh.kumar@linaro.org>
Date: Sun, 31 Mar 2013 09:21:23 +0530
Message-ID: <CAKohpommmFkaEtq6beKJpfH8JSov=dZGy=H_GJzLOr0kc3AJQQ@mail.gmail.com>
Subject: Re: [PATCH 5/9] cpufreq: integrator: move cpufreq driver to drivers/cpufreq
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

Russell,

On 25 March 2013 15:41, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> This patch moves cpufreq driver of ARM based integrator platform to
> drivers/cpufreq.
>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  arch/arm/Kconfig                                              | 11 -----------
>  arch/arm/mach-integrator/Makefile                             |  1 -
>  drivers/cpufreq/Kconfig.arm                                   |  8 ++++++++
>  drivers/cpufreq/Makefile                                      |  1 +
>  .../cpu.c => drivers/cpufreq/integrator-cpufreq.c             |  2 --
>  5 files changed, 9 insertions(+), 14 deletions(-)
>  rename arch/arm/mach-integrator/cpu.c => drivers/cpufreq/integrator-cpufreq.c (99%)

Can i have your Ack or views about this Patch?
