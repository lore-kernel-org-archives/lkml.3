Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbaHGVR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 17:17:29 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:34088 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaHGVRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 17:17:25 -0400
MIME-Version: 1.0
In-Reply-To: <1407404095-3265-4-git-send-email-kever.yang@rock-chips.com>
References: <1407404095-3265-1-git-send-email-kever.yang@rock-chips.com>
	<1407404095-3265-4-git-send-email-kever.yang@rock-chips.com>
Date: Thu, 7 Aug 2014 14:17:24 -0700
X-Google-Sender-Auth: NBDioB4TK7Ypw884CIoalYLKxTY
Message-ID: <CAD=FV=WubCx0yn7FV_qpiW31hrOgaa4Qv0N7TdRyTtKshooYgA@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] ARM: dts: add rk3288 dwc2 controller support
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Paul Zimmerman <paulz@synopsys.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, wulf <wulf@rock-chips.com>,
        lyz <lyz@rock-chips.com>, han jiang <hj@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Thu, Aug 7, 2014 at 2:34 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> rk3288 has two kind of usb controller, this add the dwc2 controller
> for otg and host1.
>
> Controller can works with usb PHY default setting and Vbus on.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
>
> ---
>
> Changes in v4: None
> Changes in v3:
> - EHCI and HSIC move new for version 3.
>
> Changes in v2: None
>
>  arch/arm/boot/dts/rk3288.dtsi | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

This looks good to me.  I haven't been able to personally test the OTG
port (since my board doesn't have vbus wired), but I've tested the
Host port.

I would request that you re-sort by base address (ignoring uart2,
which apparently is in the wrong place).  Please make sure you base
atop my patch that fixes the sort order of OHCI and EHCI.  I think
that's supposed to land any day now.

After changing the sort order:

Tested-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Doug Anderson <dianders@chromium.org>
