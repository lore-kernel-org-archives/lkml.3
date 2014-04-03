Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaDCOk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:40:59 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:33273 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaDCOk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:40:58 -0400
MIME-Version: 1.0
In-Reply-To: <1396523809-6945-1-git-send-email-hanjun.guo@linaro.org>
References: <1396523809-6945-1-git-send-email-hanjun.guo@linaro.org>
Date: Thu, 3 Apr 2014 20:10:58 +0530
Message-ID: <CAKohpokpYLLTQTrqfE1o61hLyzW6Z3+HtMM3wjqE732cKskD2Q@mail.gmail.com>
Subject: Re: [PATCH] ARM64: Remove duplicated Kconfig entry for "kernel/power/Kconfig"
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 April 2014 16:46, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> There is a duplicated Kconfig entry for "kernel/power/Kconfig"
> in menu "Power management options" and "CPU Power Management",
> remove the one from menu "CPU Power Management" suggested by
> Viresh.
>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/arm64/Kconfig |    2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index e6e4d37..e759af5 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -323,8 +323,6 @@ menu "CPU Power Management"
>
>  source "drivers/cpuidle/Kconfig"
>
> -source "kernel/power/Kconfig"
> -
>  source "drivers/cpufreq/Kconfig"
>
>  endmenu

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
