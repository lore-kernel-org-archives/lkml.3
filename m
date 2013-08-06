Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3HFHSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 03:18:35 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:42540 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab3HFHSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 03:18:33 -0400
Date: Tue, 6 Aug 2013 08:18:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>, arnd@arndb.de,
        linus.walleij@stericsson.com, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v3 07/22] ARM: dts: Remove '0x's from Exynos4210 DTSI file
Message-ID: <20130806071827.GB5100@lee--X1>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-7-git-send-email-lee.jones@linaro.org>
 <20130724150937.GO26801@laptop>
 <51FFE9F0.1000100@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51FFE9F0.1000100@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Aug 2013, Kukjin Kim wrote:

> On 07/25/13 00:09, Lee Jones wrote:
> >... for the sake of consistency and assumed convention.
> >
> >Cc: Kukjin Kim<kgene.kim@samsung.com>
> >Cc: linux-samsung-soc@vger.kernel.org
> >Signed-off-by: Lee Jones<lee.jones@linaro.org>
> >
> >diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
> >index b7f358a..53e2527 100644
> >--- a/arch/arm/boot/dts/exynos4210.dtsi
> >+++ b/arch/arm/boot/dts/exynos4210.dtsi
> >@@ -72,7 +72,7 @@
> >                 };
>    ^^^^^^^^^^^^^^^^
> >         };
>    ^^^^^^^^
> >
> >-       clock: clock-controller@0x10030000 {
>    ^^^^^^^^
> >+       clock: clock-controller@10030000 {
>    ^^^^^^^^
> >                 compatible = "samsung,exynos4210-clock";
>    ^^^^^^^^^^^^^^^^
> >                 reg =<0x10030000 0x20000>;
>    ^^^^^^^^^^^^^^^^
> >                 #clock-cells =<1>;
>    ^^^^^^^^^^^^^^^^
> 
> BTW, should be tab at the mark '^' not white space :(

Agreed, but this should be a separate patch.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
