Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaKJSkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:40:18 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:57092 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaKJSkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:40:15 -0500
MIME-Version: 1.0
In-Reply-To: <1415368177-6637-5-git-send-email-zyw@rock-chips.com>
References: <1415368177-6637-1-git-send-email-zyw@rock-chips.com>
	<1415368177-6637-5-git-send-email-zyw@rock-chips.com>
Date: Mon, 10 Nov 2014 10:40:14 -0800
X-Google-Sender-Auth: VyKvlDRP3clLTnjmj4kYKQD7OKY
Message-ID: <CAD=FV=Uur0za+NX-vKWhPq61JFBwFRHu2MNFeaLQmpsZbs87dg@mail.gmail.com>
Subject: Re: [PATCH v7 4/5] ARM: dts: add RK3288 suspend support
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kevin Hilman <khilman@kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Tony Xie <xxx@rock-chips.com>, Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Fri, Nov 7, 2014 at 5:49 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> add pmu sram node for suspend, add global_pwroff pinctrl.
> The pmu sram is used to store the resume code.
> global_pwroff is held low level at work, it would be pull to high
> when entering suspend. reference this in the board DTS file since
> some boards need it.
>
> Signed-off-by: Tony Xie <xxx@rock-chips.com>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>
>
> ---
>
> Changes in v7: None
> Changes in v6:
> - change pmu_intmem@ff720000 to sram@ff720000
>
> Changes in v5:
> - change size to 4k
>
> Changes in v4: None
> Changes in v3: None
> Changes in v2:
> - put "rockchip,rk3288-pmu-sram" to first
>
>  arch/arm/boot/dts/rk3288.dtsi | 11 +++++++++++
>  1 file changed, 11 insertions(+)

I was sorta hoping that when you sent out v7 you'd incorporate the
extra dts bits that you sent me and that I had stashed at
<https://chromium-review.googlesource.com/#/c/226826/>.  Maybe you
could do it if you send out a v8.

If you don't send out a v8 we could always land those bits separately.

-Doug
