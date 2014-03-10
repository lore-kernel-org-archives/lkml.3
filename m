Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaCJDwQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 23:52:16 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:63628 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbaCJDwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 23:52:15 -0400
MIME-Version: 1.0
In-Reply-To: <1394401306.9066.2.camel@x220>
References: <1394401306.9066.2.camel@x220>
Date: Mon, 10 Mar 2014 11:52:14 +0800
Message-ID: <CAKohpokaF6xbi0Da=OpDZQiJL6tF_kvfKXiWq7FHeTY59y-Yfw@mail.gmail.com>
Subject: Re: [PATCH] [TRIVIAL] ARM: spear: clean up editing mistake
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jiri Kosina <trivial@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 March 2014 05:41, Paul Bolle <pebolle@tiscali.nl> wrote:
> Clean up an obvious editing mistake introduced by commit 4b6effb6ff38
> ("ARM: spear: merge Kconfig files").
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  arch/arm/mach-spear/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-spear/Kconfig b/arch/arm/mach-spear/Kconfig
> index 1595776..596e990 100644
> --- a/arch/arm/mach-spear/Kconfig
> +++ b/arch/arm/mach-spear/Kconfig
> @@ -91,7 +91,7 @@ config MACH_SPEAR600
>         depends on ARCH_SPEAR6XX
>         select USE_OF
>         help
> -         Supports ST SPEAr600 boards configured via the device-treesource "arch/arm/mach-spear6xx/Kconfig"
> +         Supports ST SPEAr600 boards configured via the device-tree
>
>  config ARCH_SPEAR_AUTO
>         depends on !ARCH_SPEAR13XX && !ARCH_SPEAR6XX

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
