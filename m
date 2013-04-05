Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab3DEGqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 02:46:31 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:64060 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3DEGq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 02:46:29 -0400
MIME-Version: 1.0
In-Reply-To: <027e8f1d4ac8de6351115f15a408431558510abb.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
	<027e8f1d4ac8de6351115f15a408431558510abb.1365079581.git.viresh.kumar@linaro.org>
Date: Fri, 5 Apr 2013 12:16:27 +0530
Message-ID: <CAKohpokGkZ9m0v1QaoXEv1m0mZqY70adWpXf3edQGmZnToRRcg@mail.gmail.com>
Subject: Re: [PATCH 17/18] cpufreq: powerpc: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, deepthi@linux.vnet.ibm.com
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Olof Johansson <olof@lixom.net>,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 April 2013 18:24, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> This patch moves cpufreq driver of powerpc platform to drivers/cpufreq.
>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: linuxppc-dev@lists.ozlabs.org
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Compile Tested only.
>
>  arch/powerpc/platforms/Kconfig                     | 31 ----------------------
>  arch/powerpc/platforms/pasemi/Makefile             |  1 -
>  arch/powerpc/platforms/powermac/Makefile           |  2 --
>  drivers/cpufreq/Kconfig.powerpc                    | 26 ++++++++++++++++++
>  drivers/cpufreq/Makefile                           |  3 +++
>  .../cpufreq.c => drivers/cpufreq/pasemi-cpufreq.c  |  0
>  .../cpufreq/pmac32-cpufreq.c                       |  0
>  .../cpufreq/pmac64-cpufreq.c                       |  0
>  8 files changed, 29 insertions(+), 34 deletions(-)
>  rename arch/powerpc/platforms/pasemi/cpufreq.c => drivers/cpufreq/pasemi-cpufreq.c (100%)
>  rename arch/powerpc/platforms/powermac/cpufreq_32.c => drivers/cpufreq/pmac32-cpufreq.c (100%)
>  rename arch/powerpc/platforms/powermac/cpufreq_64.c => drivers/cpufreq/pmac64-cpufreq.c (100%)

Hi Deepthi,

Can you help testing this please?
