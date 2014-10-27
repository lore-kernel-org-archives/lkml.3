Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaJ0RqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:46:17 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:47806 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaJ0RqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:46:15 -0400
MIME-Version: 1.0
In-Reply-To: <1413933960-25839-1-git-send-email-zyw@rock-chips.com>
References: <1413933461-25602-1-git-send-email-zyw@rock-chips.com>
	<1413933960-25839-1-git-send-email-zyw@rock-chips.com>
Date: Mon, 27 Oct 2014 10:46:14 -0700
X-Google-Sender-Auth: 62ziWHYO3A6aEa6OApq_ZosPU9M
Message-ID: <CAD=FV=VNuMc+J_3vhpD6Op4Qz8YW8NVyYrcmHnuehrFx7X2Fow@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] ARM: rockchip: Add pmu-sram binding
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tony Xie <xxx@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Tue, Oct 21, 2014 at 4:26 PM, Chris Zhong <zyw@rock-chips.com> wrote:
> The pmu-sram is used to store resume code, suspend/resume need get the
> address of it. Therefore add a binding and documentation for it.
>
> Signed-off-by: Tony Xie <xxx@rock-chips.com>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> ---
>
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
>
>  .../devicetree/bindings/arm/rockchip/pmu-sram.txt  |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)

Reviewed-by: Doug Anderson <dianders@chromium.org>
