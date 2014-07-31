Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaGaWBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:01:55 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:35613 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaGaWBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:01:52 -0400
MIME-Version: 1.0
In-Reply-To: <1406841985-15790-5-git-send-email-kever.yang@rock-chips.com>
References: <1406841985-15790-1-git-send-email-kever.yang@rock-chips.com>
	<1406841985-15790-5-git-send-email-kever.yang@rock-chips.com>
Date: Thu, 31 Jul 2014 15:01:51 -0700
X-Google-Sender-Auth: tuhLP7oCFr_CBFXz2LPSFkk-JeE
Message-ID: <CAD=FV=U-7D016n08My-SZRjqN68wTW9iuBEMDzkpy+LdTGRdtw@mail.gmail.com>
Subject: Re: [REPOST PATCH v3 4/5] ARM: dts: Fix the sort ordering of EHCI and
 HSIC in rk3288.dtsi
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

On Thu, Jul 31, 2014 at 2:26 PM, Kever Yang <kever.yang@rock-chips.com> wrote:
> From: Doug Anderson <dianders@chromium.org>
>
> The EHCI and HSIC device tree nodes were added in the wrong place.
> Fix them.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
>
> Changes in v3:
> - EHCI and HSIC move new for version 3.
>
> Changes in v2: None
>
>  arch/arm/boot/dts/rk3288.dtsi |   41 ++++++++++++++++++++---------------------
>  1 file changed, 20 insertions(+), 21 deletions(-)
>
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index a5607a1..673dee3 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -205,6 +205,17 @@
>                 status = "disabled";
>         };
>
> +       usb_host0_ehci: ehci@ff500000 {

Argh.  When I was helping you I messed this up.  :(  I pointed you at
an older version of the EHCI patch.

I'll post a fixup myself.  Sorry for the bother...

-Doug
