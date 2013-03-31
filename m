Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3CaD6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 23:58:34 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:36742 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab3CaD6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 23:58:32 -0400
MIME-Version: 1.0
In-Reply-To: <60261de9edc02fa85ef16fb07abc4dfc49c8b333.1364229828.git.viresh.kumar@linaro.org>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
	<60261de9edc02fa85ef16fb07abc4dfc49c8b333.1364229828.git.viresh.kumar@linaro.org>
Date: Sun, 31 Mar 2013 09:28:31 +0530
Message-ID: <CAKohpokSWXVCSfWoL1rwHGyBrB=gHPJRO4-D3ofbrP2V7sjidw@mail.gmail.com>
Subject: Re: [PATCH 1/9] AVR32: cpufreq: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: hans-christian.egtvedt@atmel.com,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        rjw@sisk.pl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 March 2013 22:24, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> This patch moves cpufreq driver of AVR32 based at32ap platform to
> drivers/cpufreq.
>
> Cc: hans-christian.egtvedt@atmel.com
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  arch/avr32/Kconfig                                          | 13 -------------
>  arch/avr32/configs/atngw100_defconfig                       |  2 +-
>  arch/avr32/configs/atngw100_evklcd100_defconfig             |  2 +-
>  arch/avr32/configs/atngw100_evklcd101_defconfig             |  2 +-
>  arch/avr32/configs/atngw100_mrmt_defconfig                  |  2 +-
>  arch/avr32/configs/atngw100mkii_defconfig                   |  2 +-
>  arch/avr32/configs/atngw100mkii_evklcd100_defconfig         |  2 +-
>  arch/avr32/configs/atngw100mkii_evklcd101_defconfig         |  2 +-
>  arch/avr32/configs/atstk1002_defconfig                      |  2 +-
>  arch/avr32/configs/atstk1003_defconfig                      |  2 +-
>  arch/avr32/configs/atstk1004_defconfig                      |  2 +-
>  arch/avr32/configs/atstk1006_defconfig                      |  2 +-
>  arch/avr32/configs/favr-32_defconfig                        |  2 +-
>  arch/avr32/configs/hammerhead_defconfig                     |  2 +-
>  arch/avr32/configs/mimc200_defconfig                        |  2 +-
>  arch/avr32/mach-at32ap/Makefile                             |  1 -
>  drivers/cpufreq/Kconfig                                     | 13 +++++++++++++
>  drivers/cpufreq/Makefile                                    |  4 ++++
>  .../cpufreq.c => drivers/cpufreq/at32ap-cpufreq.c           |  0
>  19 files changed, 31 insertions(+), 28 deletions(-)
>  rename arch/avr32/mach-at32ap/cpufreq.c => drivers/cpufreq/at32ap-cpufreq.c (100%)

Hans/Haavard,

Can i have your Ack or comments on this?
