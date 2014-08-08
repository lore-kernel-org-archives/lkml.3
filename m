Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbaHHPpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:45:21 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:45693 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaHHPpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:45:19 -0400
MIME-Version: 1.0
In-Reply-To: <1407470159-14722-4-git-send-email-kever.yang@rock-chips.com>
References: <1407470159-14722-1-git-send-email-kever.yang@rock-chips.com>
	<1407470159-14722-4-git-send-email-kever.yang@rock-chips.com>
Date: Fri, 8 Aug 2014 08:45:16 -0700
X-Google-Sender-Auth: 33r-Tw37BkeIdT7izC_fWPrud1Q
Message-ID: <CAD=FV=XNSp85H2zVrLPdxDfhokEWFspvwUHjVMWRu8k_wFFm0Q@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] ARM: dts: add rk3288 dwc2 controller support
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Paul Zimmerman <paulz@synopsys.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        wulf <wulf@rock-chips.com>, lyz <lyz@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
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

On Thu, Aug 7, 2014 at 8:55 PM, Kever Yang <kever.yang@rock-chips.com> wrote:
> rk3288 has two kind of usb controller, this add the dwc2 controller
> for otg and host1.
>
> Controller can works with usb PHY default setting and Vbus on.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>
> ---
>
> Changes in v5:
> - change the sort order of dwc2 in rk3288.dtsi
>
> Changes in v4: None
> Changes in v3:
> - EHCI and HSIC move new for version 3.
>
> Changes in v2: None
>
>  arch/arm/boot/dts/rk3288.dtsi | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

IMHO this series is ready to go in for 3.18.  I'm assuming Heiko will
pick it up once the bindings have landed.  It already has my tags.  ;)
