Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517AbaH0Mjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 08:39:32 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51613 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933220AbaH0Mja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 08:39:30 -0400
Date: Wed, 27 Aug 2014 13:39:18 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Chris Zhong <zyw@rock-chips.com>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "hl@rock-chips.com" <hl@rock-chips.com>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "zhangqing@rock-chips.com" <zhangqing@rock-chips.com>,
        "xxx@rock-chips.com" <xxx@rock-chips.com>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "heiko@sntech.de" <heiko@sntech.de>, "olof@lixom.net" <olof@lixom.net>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>,
        "dtor@chromium.org" <dtor@chromium.org>,
        "javier.martinez@collabora.co.uk" <javier.martinez@collabora.co.uk>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>
Subject: Re: [PATCH v6 1/5] dt-bindings: Add RK808 device tree bindings
 document
Message-ID: <20140827123917.GA8742@leverpostej>
References: <1409062288-11882-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409062288-11882-1-git-send-email-zyw@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 26, 2014 at 03:11:28PM +0100, Chris Zhong wrote:
> Add device tree bindings documentation and a header file
> for rockchip's RK808 pmic.
> 
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> Signed-off-by: Zhang Qing <zhangqing@rock-chips.com>
> 
> ---
> 
> Changes in v6:
> Advices by Mark Rutland
> - add description about clock-cells
> Advices by Doug
> - modify description about regulator
> - remove pinctrl description
> 
> Changes in v5:
> Advices by Mark Brown
> - add description about regulator valid name.
> - add a header file "rockchip,rk808".
> 
> Changes in v4:
> Advices by Doug
> - add a "#clock-cells" propertiy
> - update the example
> 
> Changes in v3: None
> Changes in v2: None
> 
>  Documentation/devicetree/bindings/mfd/rk808.txt |  150 +++++++++++++++++++++++
>  include/dt-bindings/clock/rockchip,rk808.h      |   11 ++
>  2 files changed, 161 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/rk808.txt
>  create mode 100644 include/dt-bindings/clock/rockchip,rk808.h
> 
> diff --git a/Documentation/devicetree/bindings/mfd/rk808.txt b/Documentation/devicetree/bindings/mfd/rk808.txt
> new file mode 100644
> index 0000000..6c39360
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/rk808.txt
> @@ -0,0 +1,150 @@
> +RK808 Power Management Integrated Circuit
> +
> +Required properties:
> +- compatible: "rockchip,rk808"
> +- reg: I2C slave address
> +- interrupt-parent: The parent interrupt controller.
> +- interrupts: the interrupt outputs of the controller.
> +- #clock-cells: RK808 has 2 clkout, they are always 32khz,
> +  the value should be 1

When I mentioned the describing the value values before, I meant the
values that the cell in the specifier can take, 0 and 1, possibly
described as mnemnoics with reference to the binding header file.

Apologies if that was unclear.

Thanks,
Mark.
