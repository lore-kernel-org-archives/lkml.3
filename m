Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaHZShb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:37:31 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:62703 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaHZSh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:37:29 -0400
MIME-Version: 1.0
In-Reply-To: <1409062288-11882-1-git-send-email-zyw@rock-chips.com>
References: <1409062288-11882-1-git-send-email-zyw@rock-chips.com>
Date: Tue, 26 Aug 2014 11:37:29 -0700
X-Google-Sender-Auth: ILXjxKr9CMmk4Q3_AJNVOfvkx_Y
Message-ID: <CAD=FV=UTLML+kbNTu9_J1JM+EHP0fr9gOZHGv66dbL1sWC3vkA@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] dt-bindings: Add RK808 device tree bindings document
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Tue, Aug 26, 2014 at 7:11 AM, Chris Zhong <zyw@rock-chips.com> wrote:
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


Is it worth picking a new example from
<https://patchwork.kernel.org/patch/4783471/>?  Then if someone
happens to copy your example the'll get slightly more sane things
(level low for interrupt, wakeup-source, proper "clock-output-name"
that's compatible with rk3288, etc.

Other than that this looks find to me:

Reviewed-by: Doug Anderson <dianders@chromium.org>
