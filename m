Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbaFCSLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:11:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56839 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbaFCSLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:11:50 -0400
Message-ID: <538E0FE2.4090405@codeaurora.org>
Date: Tue, 03 Jun 2014 11:11:46 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Remove ARCH_HAS_CPUFREQ config option
References: <1401746847-3193-1-git-send-email-sboyd@codeaurora.org> <CAOh2x==wsy2_+GygS03snFN_YOar3eHi7v1a-jNdsQYoWCAZsw@mail.gmail.com>
In-Reply-To: <CAOh2x==wsy2_+GygS03snFN_YOar3eHi7v1a-jNdsQYoWCAZsw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/14 21:27, Viresh Kumar wrote:
> On Tue, Jun 3, 2014 at 3:37 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> This config exists entirely to hide the cpufreq menu from the
>> kernel configuration unless a platform has selected it. Nothing
>> is actually built if this config is 'Y' and it just leads to
>> more patches that add a select under a platform Kconfig so that
>> some other CPUfreq option can be chosen. Let's remove the
>> option so that we can always enable CPUfreq drivers on ARM
>> platforms.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  arch/arm/Kconfig               | 18 ------------------
>>  arch/arm/mach-davinci/Kconfig  |  1 -
>>  arch/arm/mach-highbank/Kconfig |  1 -
>>  arch/arm/mach-imx/Kconfig      |  3 ---
>>  arch/arm/mach-mvebu/Kconfig    |  1 -
>>  arch/arm/mach-omap2/Kconfig    |  1 -
>>  arch/arm/mach-shmobile/Kconfig |  2 --
>>  arch/arm/mach-spear/Kconfig    |  1 -
>>  arch/arm/mach-tegra/Kconfig    |  1 -
>>  arch/arm/mach-ux500/Kconfig    |  1 -
>>  arch/arm/mach-vexpress/Kconfig |  1 -
>>  arch/arm/mach-vt8500/Kconfig   |  1 -
>>  arch/arm/mach-zynq/Kconfig     |  1 -
>>  13 files changed, 33 deletions(-)
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> While you are at it, please see if you can also fix unicore as well.

Sure I'll send a separate patch and Cc you.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

