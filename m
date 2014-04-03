Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbaDCEX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 00:23:58 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:60092 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaDCEX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 00:23:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140402144020.GA20438@zod>
References: <CA+5PVA6awqaSHQboqdv9nynV9Xjp46VeqijDWxZX1v5wDK0NWQ@mail.gmail.com>
	<CAKohpok3gKyOWD0=pSv0yQLNqJcNPNZagRGFXNFHW+3J7E=mOg@mail.gmail.com>
	<20140402144020.GA20438@zod>
Date: Thu, 3 Apr 2014 09:53:56 +0530
X-Google-Sender-Auth: rcD1yDTxTftPA0PnLxLypxP3feg
Message-ID: <CAOh2x=nHX0_2v0WtBAh6xLqmkk1SVQSpNZX54jirByDCwtoSXQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: Fix duplicated Kconfig entries again
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Mark Brown <broonie@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2014 at 8:10 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> Commit 74397174989e5f70 attempted to clean up the power management options
> for arm64, but when things were merged it didn't fully take effect.  Fix
> it again.
>
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> ---
>  arch/arm64/Kconfig | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 07aa3556952c..8033b9b8a2df 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -321,12 +321,6 @@ menu "CPU Power Management"
>
>  source "drivers/cpuidle/Kconfig"
>
> -source "drivers/cpufreq/Kconfig"
> -
> -endmenu
> -
> -menu "Power management options"
> -
>  source "kernel/power/Kconfig"
>
>  source "drivers/cpufreq/Kconfig"

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
