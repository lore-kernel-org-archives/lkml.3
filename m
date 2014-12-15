Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaLOSOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:14:21 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:39167 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaLOSOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:14:17 -0500
MIME-Version: 1.0
In-Reply-To: <1418397141-1079-1-git-send-email-lyz@rock-chips.com>
References: <1418396413-27937-1-git-send-email-lyz@rock-chips.com>
	<1418397141-1079-1-git-send-email-lyz@rock-chips.com>
Date: Mon, 15 Dec 2014 10:14:16 -0800
X-Google-Sender-Auth: tLRAcd7Yq2U3c0yDT7MzH5Wm74U
Message-ID: <CAD=FV=U2C0bfG-STz0Bu9iwtzaaDOk-9K773t3VV--XnVb78hQ@mail.gmail.com>
Subject: Re: [PATCH v7 4/5] ARM: dts: rockchip: add rk3288 usb PHY
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

On Fri, Dec 12, 2014 at 7:12 AM, Yunzhi Li <lyz@rock-chips.com> wrote:
> This patch adds a device_node for RK3288 SoC usb phy. It also
> defines the phy to be used by three usb controllers: usb_host0/1
> and usb_otg.
>
> Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
>
> ---
>
> Changes in v7:
> - Update dtsi for new usb phy driver.
>
> Changes in v6: None
> Changes in v5:
> - reorder the phy dt node to a correct position.
>
> Changes in v4:
> - Add phy subnodes.
>
> Changes in v3: None
>
>  arch/arm/boot/dts/rk3288.dtsi | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)

On rk3288-pinky (on a 3.14 tree with backports), I can confirm that
this properly gets us into low power at suspend time.

Tested-by: Doug Anderson <dianders@chromium.org>


This looks reasonable to me:

Reviewed-by: Doug Anderson <dianders@chromium.org>
