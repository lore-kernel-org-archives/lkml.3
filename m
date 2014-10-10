Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaJJJ77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:59:59 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:64158 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaJJJ74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:59:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Scott Branden <sbranden@broadcom.com>, Christian Daudt <bcm@fixthebug.org>,
        Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, devicetree@vger.kernel.org,
        Ray Jui <rjui@broadcom.com>, linux-kernel@vger.kernel.org,
        JD Zheng <jdzheng@broadcom.com>
Subject: Re: [PATCH V4 7/7] ARM: multi_v7_defconfig: Enable ARCH_BCM_CYGNUS config
Date: Fri, 10 Oct 2014 11:59:32 +0200
Message-ID: <8180880.ZD9iHlqhNz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412894671-5921-8-git-send-email-sbranden@broadcom.com>
References: <1412894671-5921-8-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bM25Zi9AqVG6jFSmV++/S8JiFJvQQQJll9U8Tjh18VL
 sKjQZrBKFrFr1NIlch+osR509osbnyX21laVN9bD0/VDwHeGgd
 rMgCCLJg02UJkfJaSQx9GxuErFow/lkeSK70HAp97dy28a8Bp9
 sWtUSddp40y8azm0fKBDq70DCcgnr5Nvy24o5HGu7+eSfl/ok4
 Tco4V1oTsf5gFdn9ivvrMRNeq9F/XG8+Glhhe1KHF5vDxuY9Lg
 DVQYv+kF2sPl4UXKHIcUPZZ+pfHHZR9leLLt/meg3cusAtnu9E
 P6vWWgZY6gXP7b9gnN8XbgJojUX5nCIjnPk1tUrICPXx+K7euf
 VJHAiLBzp9pExifPKlko=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2014 15:44:31 Scott Branden wrote:
> Enabled Broadcom Cygnus SoC family in multi_v7_defconfig by using
> CONFIG_ARCH_BCM_CYGNUS=y.
> 
> Signed-off-by: Scott Branden <sbranden@broadcom.com>
> ---
>  arch/arm/configs/multi_v7_defconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
> index 5fb95fb..d02f56d 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -17,6 +17,7 @@ CONFIG_MACH_ARMADA_38X=y
>  CONFIG_MACH_ARMADA_XP=y
>  CONFIG_MACH_DOVE=y
>  CONFIG_ARCH_BCM=y
> +CONFIG_ARCH_BCM_CYGNUS=y
>  CONFIG_ARCH_BCM_MOBILE=y
>  CONFIG_ARCH_BCM_5301X=y
>  CONFIG_ARCH_BRCMSTB=y
> 

Does this contain all the drivers you need that are enabled in cygnus_defconfig?

	Arnd
