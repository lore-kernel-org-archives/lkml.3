Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3C3Jv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 05:51:58 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:40132 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab3C3Jvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 05:51:55 -0400
MIME-Version: 1.0
In-Reply-To: <afc636963b63becccf34d092203c53369bd1b735.1364229828.git.viresh.kumar@linaro.org>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
	<afc636963b63becccf34d092203c53369bd1b735.1364229828.git.viresh.kumar@linaro.org>
Date: Sat, 30 Mar 2013 15:21:54 +0530
Message-ID: <CAKohponax2iDZeA-WG_L2XVHU5GGJB2nSPWVoVxbZUoez1ZpDw@mail.gmail.com>
Subject: Re: [PATCH 4/9] ia64: cpufreq: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 March 2013 22:24, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
> index 9a02f71..dd59848 100644
> --- a/arch/ia64/Kconfig
> +++ b/arch/ia64/Kconfig
> @@ -591,9 +591,8 @@ source "kernel/power/Kconfig"
>  source "drivers/acpi/Kconfig"
>
>  if PM
> -
> -source "arch/ia64/kernel/cpufreq/Kconfig"
> -
> +menu "CPU Frequency scaling"
> +source "drivers/cpufreq/Kconfig"
>  endif
>
>  endmenu

Fixup:

commit 509bc3c30aff65045918f69f750d8845f004cc0a
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Sat Mar 30 15:20:41 2013 +0530

    fixup! ia64: cpufreq:  move cpufreq driver to drivers/cpufreq
---
 arch/ia64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index dd59848..152b5f2 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -593,6 +593,7 @@ source "drivers/acpi/Kconfig"
 if PM
 menu "CPU Frequency scaling"
 source "drivers/cpufreq/Kconfig"
+endmenu
 endif

 endmenu
