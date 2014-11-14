Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161691AbaKNR2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:28:17 -0500
Received: from down.free-electrons.com ([37.187.137.238]:37541 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161108AbaKNR2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:28:16 -0500
Date: Fri, 14 Nov 2014 18:28:12 +0100
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        Peter.Chen@freescale.com, balbi@ti.com, p.zabel@pengutronix.de,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 03/13] ARM: Berlin: select the reset controller
Message-ID: <20141114172812.GD2991@kwain>
References: <1415978763-27345-1-git-send-email-antoine.tenart@free-electrons.com>
 <1415978763-27345-4-git-send-email-antoine.tenart@free-electrons.com>
 <3287202.nx0cnO5WUI@wuerfel>
 <54662192.6000403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54662192.6000403@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Fri, Nov 14, 2014 at 04:36:50PM +0100, Sebastian Hesselbarth wrote:
> On 11/14/2014 04:33 PM, Arnd Bergmann wrote:
> >On Friday 14 November 2014 16:25:53 Antoine Tenart wrote:
> >>  menuconfig ARCH_BERLIN
> >>         bool "Marvell Berlin SoCs" if ARCH_MULTI_V7
> >>+       select ARCH_HAS_RESET_CONTROLLER
> >>         select ARCH_REQUIRE_GPIOLIB
> >>         select ARM_GIC
> >>         select GENERIC_IRQ_CHIP
> >>         select DW_APB_ICTL
> >>         select DW_APB_TIMER_OF
> >>         select PINCTRL
> >>+       select RESET_CONTROLLER
> >
> >RESET_CONTROLLER is meant to be user-selectable, don't add a 'select' here,
> >but instead make the driver 'depends on RESET_CONTROLLER'.
> 
> It already went into arm-soc for v3.19 - ergo, we need an extra
> patch for removing the current 'select'.

Do you want me to send the extra patch fixing this issue?

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
