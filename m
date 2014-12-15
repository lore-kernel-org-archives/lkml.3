Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaLOSPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:15:41 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:35409 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaLOSPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:15:38 -0500
MIME-Version: 1.0
In-Reply-To: <1418397422-17249-1-git-send-email-lyz@rock-chips.com>
References: <1418396413-27937-1-git-send-email-lyz@rock-chips.com>
	<1418397422-17249-1-git-send-email-lyz@rock-chips.com>
Date: Mon, 15 Dec 2014 10:15:37 -0800
X-Google-Sender-Auth: RT-afMU6kSaqYFS1pTyHie-IAZE
Message-ID: <CAD=FV=V93J81SVnOpA1jciGfs9Bh9En-quda677tKzdt7sQDMg@mail.gmail.com>
Subject: Re: [PATCH v7 5/5] ARM: dts: rockchip: Enable usb PHY on rk3288-evb board
From: Doug Anderson <dianders@chromium.org>
To: Yunzhi Li <lyz@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jwerner@chromium.org, Olof Johansson <olof@lixom.net>,
        Tao Huang <huangtao@rock-chips.com>, Chris <zyw@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yunzhi,

On Fri, Dec 12, 2014 at 7:17 AM, Yunzhi Li <lyz@rock-chips.com> wrote:
> Enable usb PHY for all usb ports on rk3288-evb.
>
> Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
>
> ---
>
> Changes in v7: None
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
>
>  arch/arm/boot/dts/rk3288-evb.dtsi | 4 ++++
>  1 file changed, 4 insertions(+)

I have tested a similar change on rk3288-pinky (on a 3.14 tree with
backports).  There I can confirm that this properly gets us into low
power at suspend time.  I have not tested on EVB itself though, so
leaving off my tested tag.

This does look reasonable to me, though:

Reviewed-by: Doug Anderson <dianders@chromium.org>
