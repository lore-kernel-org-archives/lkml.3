Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaJ1Ahn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:37:43 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:43715 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaJ1Ahl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:37:41 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dbasehore@chromium.org, huangtao@rock-chips.com,
        cjf@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v14 2/5] dt-bindings: document Rockchip thermal
Date: Mon, 27 Oct 2014 17:37:38 -0700
Message-ID: <4038023.8IINY8khj6@dtor-glaptop>
User-Agent: KMail/4.13.3 (Linux/3.13.0-37-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <544EE42D.3030208@rock-chips.com>
References: <1414377588-2237-1-git-send-email-caesar.wang@rock-chips.com> <20141028002915.GJ7594@dtor-ws> <544EE42D.3030208@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 28, 2014 08:32:45 AM Caesar Wang wrote:
> Dmitry,
> 
> 在 2014年10月28日 08:29, Dmitry Torokhov 写道:
> > On Mon, Oct 27, 2014 at 10:39:45AM +0800, Caesar Wang wrote:
> >> This add the necessary binding documentation for the thermal
> >> found on Rockchip SoCs
> >> 
> >> Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
> >> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> >> ---
> >> 
> >>   .../bindings/thermal/rockchip-thermal.txt          | 53
> >>   ++++++++++++++++++++++ 1 file changed, 53 insertions(+)
> >>   create mode 100644
> >>   Documentation/devicetree/bindings/thermal/rockchip-thermal.txt>> 
> >> diff --git
> >> a/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
> >> b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt new
> >> file mode 100644
> >> index 0000000..d5b1401
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
> >> @@ -0,0 +1,53 @@
> >> +* Temperature Sensor ADC (TSADC) on rockchip SoCs
> >> +
> >> +Required properties:
> >> +- compatible : "rockchip,rk3288-tsadc"
> >> +- reg : physical base address of the controller and length of memory
> >> mapped +	region.
> >> +- interrupts : The interrupt number to the cpu. The interrupt specifier
> >> format +	       depends on the interrupt controller.
> >> +- clocks : Must contain an entry for each entry in clock-names.
> >> +- clock-names : Shall be "tsadc" for the converter-clock, and "apb_pclk"
> >> for +		the peripheral clock.
> >> +- #thermal-sensor-cells : Should be 1. See ./thermal.txt for a
> >> description.> 
> > I think you are missing description of hw-shut-temp, tsadc-tshut-mode
> > and tsadc-tshut-mode
> > 
> >   and optional pinctrl settings.
> 
> If it's really need,we just have hw-shut-temp,tsadc-tshut-mode
> and tsadc-tshut-mode,no need  pinctrl setting,I think.

This is more question to DeviceTree guys, but I can see us not documenting
pinctrl since it is generic property used by every driver out there. We should
definitely document driver-specific properties.

Thanks.

-- 
Dmitry
