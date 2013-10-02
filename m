Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3JBIcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 04:32:48 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:60721 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab3JBIcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 04:32:46 -0400
Message-ID: <524BDA2A.7090108@linaro.org>
Date: Wed, 02 Oct 2013 10:32:42 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Fan Rong <cinifr@gmail.com>, coosty@163.com,
        maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
        tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-sunxi@googlegroups.com
Subject: Re: [Add SMP support for Allwinner A20: PATCH V4 0/3]
References: <1380642145-17295-1-git-send-email-cinifr@gmail.com>
In-Reply-To: <1380642145-17295-1-git-send-email-cinifr@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 05:42 PM, Fan Rong wrote:


> This is the version 4 patch. It use smp_prepare_cpus replacing early_init as cpuconfigure map init funcation caller and use sun7i replacing sunxi7i as funcation name and variable name.

Hi Fan,

your patchset does not have a changelog neither a description. You 
should fix this first if you want a proper review.

Thanks
   -- Daniel

>
> Fan Rong (3):
>    Add smp support for Allwinner A20(sunxi 7i).
>    Add cpuconfig nodes in dts for smp configure.
>    Add arch count timer node in dts for Allwinner A20(sunxi 7i).
>
>   arch/arm/boot/dts/sun7i-a20.dtsi |  15 ++++++
>   arch/arm/mach-sunxi/Makefile     |   2 +
>   arch/arm/mach-sunxi/headsmp.S    |  18 +++++++
>   arch/arm/mach-sunxi/platsmp.c    | 114 +++++++++++++++++++++++++++++++++++++++
>   arch/arm/mach-sunxi/sunxi.c      |   3 ++
>   5 files changed, 152 insertions(+)
>   create mode 100644 arch/arm/mach-sunxi/headsmp.S
>   create mode 100644 arch/arm/mach-sunxi/platsmp.c
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

