Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaLAF0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 00:26:12 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:39555 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbaLAF0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 00:26:09 -0500
MIME-Version: 1.0
In-Reply-To: <1416900743-29204-4-git-send-email-zyw@rock-chips.com>
References: <1416900743-29204-1-git-send-email-zyw@rock-chips.com>
	<1416900743-29204-4-git-send-email-zyw@rock-chips.com>
Date: Sun, 30 Nov 2014 21:26:08 -0800
X-Google-Sender-Auth: AbvmVYQuHdZzGB7hPNht0grUM3k
Message-ID: <CAD=FV=Vv3ZG3WjMSkGdAW=2Vpev2JWfqJtyFdX=PVB_YjY7__g@mail.gmail.com>
Subject: Re: [PATCH v9 3/4] ARM: dts: add RK3288 suspend support
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

On Mon, Nov 24, 2014 at 11:32 PM, Chris Zhong <zyw@rock-chips.com> wrote:
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
> Changes in v9: None

This is untrue.  v8 had more stuff than v9.  See:

https://patchwork.kernel.org/patch/5311621/

vs.

https://patchwork.kernel.org/patch/5372911/

I prefer v8.
