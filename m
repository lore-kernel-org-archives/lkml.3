Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab3FEHL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:11:26 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:33375 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3FEHLX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:11:23 -0400
Date: Wed, 5 Jun 2013 09:11:19 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Heiko =?UTF-8?B?U3TDvGJuZXI=?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>, linux-mmc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        John Stultz <john.stultz@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        devicetree-discuss@lists.ozlabs.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 10/10] arm: add basic support for Rockchip RK3066a
 boards
Message-ID: <20130605091119.18432af4@skate>
In-Reply-To: <201306030102.20890.heiko@sntech.de>
References: <201306030055.15413.heiko@sntech.de>
	<201306030102.20890.heiko@sntech.de>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Heiko Stübner,

On Mon, 3 Jun 2013 01:02:20 +0200, Heiko Stübner wrote:
> index 0000000..a2d8c70
> --- /dev/null
> +++ b/arch/arm/mach-rockchip/Makefile.boot
> @@ -0,0 +1,3 @@
> +zreladdr-$(CONFIG_ARCH_ROCKCHIP)	:= 0x60408000
> +params_phys-$(CONFIG_ARCH_ROCKCHIP)	:= 0x60088000
> +initrd_phys-$(CONFIG_ARCH_ROCKCHIP)	:= 0x60800000

Thanks to the AUTO_ZRELADDR thing that you're using as part of the
MULTIPLATFORM support, this Makefile.boot file is no longer useful. See
mach-socfpga, mach-mvebu, mach-bcm2835, mach-bcm, mach-highbank, etc.

Cc'ing Maxime Ripard, since I see that mach-sunxi does have a
Makefile.boot, even though I believe it is not needed.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
