Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3EMJ2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:28:41 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:63460 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab3EMJ2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:28:39 -0400
MIME-Version: 1.0
In-Reply-To: <1368437025.1350.35.camel@x61.thuisdomein>
References: <1368437025.1350.35.camel@x61.thuisdomein>
Date: Mon, 13 May 2013 14:58:39 +0530
Message-ID: <CAKohpo=WKr_+1E6KvrsNyy8xPJHVVt-panTrt409k9wP27u8Gg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: rename references to CPU_FREQ_SA11x0
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arnd Bergmann <arnd@arndb.de>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 May 2013 14:53, Paul Bolle <pebolle@tiscali.nl> wrote:
> The Kconfig symbols CPU_FREQ_SA1100 and CPU_FREQ_SA1110 were renamed in
> commit 59a2e613d0 ("cpufreq: sa11x0: move cpufreq driver to
> drivers/cpufreq"). Rename the last references to those symbols too.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
>
>  drivers/cpufreq/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
> index a1488f5..534fcb8 100644
> --- a/drivers/cpufreq/Kconfig
> +++ b/drivers/cpufreq/Kconfig
> @@ -47,7 +47,7 @@ config CPU_FREQ_STAT_DETAILS
>
>  choice
>         prompt "Default CPUFreq governor"
> -       default CPU_FREQ_DEFAULT_GOV_USERSPACE if CPU_FREQ_SA1100 || CPU_FREQ_SA1110
> +       default CPU_FREQ_DEFAULT_GOV_USERSPACE if ARM_SA1100_CPUFREQ || ARM_SA1110_CPUFREQ
>         default CPU_FREQ_DEFAULT_GOV_PERFORMANCE
>         help
>           This option sets which CPUFreq governor shall be loaded at

Already Acked.

http://www.spinics.net/lists/arm-kernel/msg242828.html
