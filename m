Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab3CEIbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:31:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52830 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3CEIbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:31:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] ARM: Scorpion is a v7 architecture, not v6
Date: Tue, 5 Mar 2013 08:31:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1362439159-29258-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1362439159-29258-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303050831.37177.arnd@arndb.de>
X-Provags-ID: V02:K0:9XgVavhbfiUwT0JuITeRkS6uHvt5ExPEnPDAOUKWTYB
 QrvPXPjpgNgHz07RmHfhYTY1SKvp7V/7+k1SPyKA8PzI5fL446
 rtu2ttaRu5u1zjJBC8xr7r53Py3qgmgDuq4R4K1LmaCb8yO1do
 fbLWUvyrFBgq5aZJ57EirlzcaMmIOzSKoLGuNoOmViAxsDCGfz
 2bEz3ZCEDCnZF5nDAHS6AAb0WKuFW+lfVXTsEz+TfoMFu97gz6
 GyZhLTkstNI6pgYJoOVB550J1e2Pc7/QrUsGZk3oTaHqAypGK0
 buS3z8idNDTe+b2nMNfLAD4Jd4cX3EpTRr2tGf1PmD0oyl2/Yp
 Qbm1pCo/cIOKmFWk/PT0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 March 2013, Stephen Boyd wrote:
> Scorpion processors have always been v7 CPUs. Fix the Kconfig
> text to reflect this.
> 
> Reported-by: Stepan Moskovchenko <stepanm@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index dedf02b..dc3bbbc 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1006,12 +1006,12 @@ config ARCH_MULTI_V4_V5
>         bool
>  
>  config ARCH_MULTI_V6
> -       bool "ARMv6 based platforms (ARM11, Scorpion, ...)"
> +       bool "ARMv6 based platforms (ARM11)"
>         select ARCH_MULTI_V6_V7
>         select CPU_V6

Sorry about that, my fault.

Was there also an ARMv6 core from Qualcomm, or did you only use ARM11 at
the time?

	Arnd
