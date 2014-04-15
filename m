Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaDOJ2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:28:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38576 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752506AbaDOJ2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:28:21 -0400
Date: Tue, 15 Apr 2014 11:27:46 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: berlin: add the LIBGPIO as a dependency for the
 BG2Q
Message-ID: <20140415092746.GC4584@kwain>
References: <1397549245-3338-1-git-send-email-antoine.tenart@free-electrons.com>
 <1397549245-3338-2-git-send-email-antoine.tenart@free-electrons.com>
 <534CF901.2080400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <534CF901.2080400@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Tue, Apr 15, 2014 at 11:16:49AM +0200, Sebastian Hesselbarth wrote:
> On 04/15/2014 10:07 AM, Antoine Ténart wrote:

[…]

> >diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
> >index 291f1cac6c3d..c31968712095 100644
> >--- a/arch/arm/mach-berlin/Kconfig
> >+++ b/arch/arm/mach-berlin/Kconfig
> >@@ -28,6 +28,7 @@ config MACH_BERLIN_BG2Q
> >  	select CPU_V7
> >  	select HAVE_ARM_TWD if SMP
> >  	select HAVE_SMP
> >+	select ARCH_REQUIRE_GPIOLIB
> 
> Apart from Jisheng's comment, I think we can directly move it
> into arch/arm/Kconfig's MACH_BERLIN directly?

I think so.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
