Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab3CaEBK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 00:01:10 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:58060 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab3CaEBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 00:01:07 -0400
MIME-Version: 1.0
In-Reply-To: <199e0d0a282290544ff562b904a0028a104aad45.1364229828.git.viresh.kumar@linaro.org>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
	<199e0d0a282290544ff562b904a0028a104aad45.1364229828.git.viresh.kumar@linaro.org>
Date: Sun, 31 Mar 2013 09:31:07 +0530
Message-ID: <CAKohpom4sckvmB12=KRX4aMJDJjpT=nN++_xyL=p_0ZY7v6oMQ@mail.gmail.com>
Subject: Re: [PATCH 5/9] mips: cpufreq: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
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

On 25 March 2013 22:24, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> This patch moves cpufreq driver of MIPS architecture to drivers/cpufreq.
>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: linux-mips@linux-mips.org
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  arch/mips/Kconfig                                  |  9 ++++-
>  arch/mips/kernel/Makefile                          |  2 --
>  arch/mips/kernel/cpufreq/Kconfig                   | 41 ----------------------
>  arch/mips/kernel/cpufreq/Makefile                  |  5 ---
>  drivers/cpufreq/Kconfig                            | 18 ++++++++++
>  drivers/cpufreq/Makefile                           |  1 +
>  .../kernel => drivers}/cpufreq/loongson2_cpufreq.c |  0
>  7 files changed, 27 insertions(+), 49 deletions(-)
>  delete mode 100644 arch/mips/kernel/cpufreq/Kconfig
>  delete mode 100644 arch/mips/kernel/cpufreq/Makefile
>  rename {arch/mips/kernel => drivers}/cpufreq/loongson2_cpufreq.c (100%)

Ralf or any other mips guy,

Can i have your ack or comments for this patch?
