Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbaHHOjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:39:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39607 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754807AbaHHOjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:39:09 -0400
Date: Fri, 8 Aug 2014 16:39:05 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: mathieu.poirier@linaro.org
Cc: linus.walleij@linaro.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        robherring2@gmail.com, daniel.thompson@linaro.org,
        robbelibobban@gmail.com, Al.Grant@arm.com, patches@linaro.org,
        marcin.jabrzyk@gmail.com, linux-kernel@vger.kernel.org,
        panchaxari.prasannamurthy@linaro.org, r.sengupta@samsung.com,
        arve@android.com, Tony.Armitstead@arm.com, john.stultz@linaro.org,
        linux-arm-kernel@lists.infradead.org, james.king@linaro.org,
        pratikp@codeaurora.org, varshney@ti.com,
        jonas.svennebring@avagotech.com
Subject: Re: [PATCH 00/10 v3] Coresight framework and drivers
Message-ID: <20140808163905.30f7cb12@free-electrons.com>
In-Reply-To: <1407435706-19441-1-git-send-email-mathieu.poirier@linaro.org>
References: <1407435706-19441-1-git-send-email-mathieu.poirier@linaro.org>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu,

On Thu,  7 Aug 2014 12:21:36 -0600, mathieu.poirier@linaro.org wrote:

>  arch/arm/Kconfig.debug                     |   36 +-
>  arch/arm/boot/dts/omap3-beagle-xm.dts      |   28 +
>  arch/arm/boot/dts/omap3-beagle.dts         |   28 +
>  arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts |  199 ++++
>  arch/arm/include/asm/hardware/coresight.h  |  157 ---
>  arch/arm/include/asm/hardware/cp14.h       |  540 ++++++++++
>  arch/arm/kernel/Makefile                   |    1 -
>  arch/arm/kernel/etm.c                      |  654 ------------
>  arch/arm/kernel/hw_breakpoint.c            |    4 +-
>  arch/arm/mach-omap2/Kconfig                |    8 -
>  arch/arm/mach-omap2/Makefile               |    1 -
>  arch/arm/mach-omap2/emu.c                  |   50 -
>  drivers/Makefile                           |    1 +
>  drivers/amba/bus.c                         |    2 +-
>  drivers/coresight/Makefile                 |    9 +
>  drivers/coresight/coresight-etb10.c        |  529 ++++++++++
>  drivers/coresight/coresight-etm-cp14.c     |  506 ++++++++++
>  drivers/coresight/coresight-etm.h          |  192 ++++
>  drivers/coresight/coresight-etm3x.c        | 1516 ++++++++++++++++++++++++++++
>  drivers/coresight/coresight-funnel.c       |  251 +++++
>  drivers/coresight/coresight-priv.h         |   63 ++
>  drivers/coresight/coresight-replicator.c   |  153 +++
>  drivers/coresight/coresight-tmc.c          |  740 ++++++++++++++
>  drivers/coresight/coresight-tpiu.c         |  212 ++++
>  drivers/coresight/coresight.c              |  638 ++++++++++++
>  drivers/coresight/of_coresight.c           |  202 ++++
>  include/linux/amba/bus.h                   |    1 +
>  include/linux/coresight.h                  |  200 ++++

So a brand new framework gets added, and there's nothing added in
Documentation/ ? It'd be nice to have a short documentation that
explains what the framework is defined for, how driver should be
written for it, what is its kernel-space or user-space interface, etc.

Thanks,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
