Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaHZQ0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:26:18 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:52743 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaHZQ0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:26:16 -0400
Date: Tue, 26 Aug 2014 17:26:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lgirdwood@gmail.com, broonie@kernel.org,
        a.zummo@towertech.it, mturquette@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com
Subject: Re: [PATCH v6 0/5] Add rockchip RK808 pmic driver
Message-ID: <20140826162606.GC26707@lee--X1>
References: <1409062218-11844-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409062218-11844-1-git-send-email-zyw@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Chris Zhong wrote:
> This is the initial version of the RK808 PMIC. This is a power management IC
> for multimedia products.
> 
> It provides regulators that are able to supply power to processor cores
> and other components. The chip provides other modules including RTC, Clockout
> 
> Chris Zhong (5):
>   dt-bindings: Add RK808 device tree bindings document
>   MFD: RK808: Add new mfd driver for RK808
>   RTC: RK808: add RTC driver for RK808
>   clk: RK808: Add clkout driver for RK808
>   regulator: RK808: remove redundant code

You're still sending your sets un-threaded.  Please see the `git
send-email` help for information on how to do that.  It makes things
so much easier to cross-reference if the patches stay together in ones
INBOX.

>  Documentation/devicetree/bindings/mfd/rk808.txt |  150 +++++++++
>  drivers/clk/Kconfig                             |    9 +
>  drivers/clk/Makefile                            |    1 +
>  drivers/clk/clk-rk808.c                         |  163 +++++++++
>  drivers/mfd/Kconfig                             |   13 +
>  drivers/mfd/Makefile                            |    1 +
>  drivers/mfd/rk808.c                             |  257 ++++++++++++++
>  drivers/regulator/rk808-regulator.c             |   17 +-
>  drivers/rtc/Kconfig                             |   10 +
>  drivers/rtc/Makefile                            |    1 +
>  drivers/rtc/rtc-rk808.c                         |  412 +++++++++++++++++++++++
>  include/dt-bindings/clock/rockchip,rk808.h      |   11 +
>  include/linux/mfd/rk808.h                       |  202 +++++++++++
>  13 files changed, 1234 insertions(+), 13 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/rk808.txt
>  create mode 100644 drivers/clk/clk-rk808.c
>  create mode 100644 drivers/mfd/rk808.c
>  create mode 100644 drivers/rtc/rtc-rk808.c
>  create mode 100644 include/dt-bindings/clock/rockchip,rk808.h
>  create mode 100644 include/linux/mfd/rk808.h
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
