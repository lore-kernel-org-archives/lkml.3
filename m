Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaAVOk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:40:57 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:43610 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbaAVOkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:40:55 -0500
MIME-Version: 1.0
In-Reply-To: <1390394643-25443-1-git-send-email-naresh.bhat@linaro.org>
References: <1390394643-25443-1-git-send-email-naresh.bhat@linaro.org>
Date: Wed, 22 Jan 2014 20:10:54 +0530
Message-ID: <CAKohpo=_e-CH9ZGoAxJVsfoFO3pcr0Fi_=QzEc5DnR7EFVewcA@mail.gmail.com>
Subject: Re: [PATCH] watchdog: Add sp805_wdt depends on ARM64
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Naresh Bhat <naresh.bhat@linaro.org>
Cc: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>, linaro-acpi@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 January 2014 18:14,  <naresh.bhat@linaro.org> wrote:
> From: Naresh Bhat <naresh.bhat@linaro.org>
>
> Add sp805_wdt depends on ARM64.
>
> Signed-off-by: Naresh Bhat <naresh.bhat@linaro.org>
> ---
>  drivers/watchdog/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 5be6e91..2385124 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -109,7 +109,7 @@ config WM8350_WATCHDOG
>
>  config ARM_SP805_WATCHDOG
>         tristate "ARM SP805 Watchdog"
> -       depends on ARM && ARM_AMBA
> +       depends on (ARM || ARM64) && ARM_AMBA
>         select WATCHDOG_CORE
>         help
>           ARM Primecell SP805 Watchdog timer. This will reboot your system when

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
