Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbaDOJ0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:26:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38556 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750855AbaDOJ0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:26:52 -0400
Date: Tue, 15 Apr 2014 11:26:48 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: berlin: add the LIBGPIO as a dependency for the
 BG2Q
Message-ID: <20140415092648.GB4584@kwain>
References: <1397549245-3338-1-git-send-email-antoine.tenart@free-electrons.com>
 <1397549245-3338-2-git-send-email-antoine.tenart@free-electrons.com>
 <20140415170750.7721e907@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140415170750.7721e907@xhacker>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jisheng,

On Tue, Apr 15, 2014 at 05:07:50PM +0800, Jisheng Zhang wrote:
> On Tue, 15 Apr 2014 01:07:24 -0700
> Antoine Ténart <antoine.tenart@free-electrons.com> wrote:
[…]
> > diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
> > index 291f1cac6c3d..c31968712095 100644
> > --- a/arch/arm/mach-berlin/Kconfig
> > +++ b/arch/arm/mach-berlin/Kconfig
> > @@ -28,6 +28,7 @@ config MACH_BERLIN_BG2Q
> >  	select CPU_V7
> >  	select HAVE_ARM_TWD if SMP
> >  	select HAVE_SMP
> > +	select ARCH_REQUIRE_GPIOLIB
> 
> alphabetically sort.

You're right, will do.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
