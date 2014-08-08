Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbaHHPqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:46:04 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:44237 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307AbaHHPqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:46:02 -0400
MIME-Version: 1.0
In-Reply-To: <1407470159-14722-5-git-send-email-kever.yang@rock-chips.com>
References: <1407470159-14722-1-git-send-email-kever.yang@rock-chips.com>
	<1407470159-14722-5-git-send-email-kever.yang@rock-chips.com>
Date: Fri, 8 Aug 2014 08:46:00 -0700
X-Google-Sender-Auth: LytCHJ0M8UplijYgZBAh9hBmW3E
Message-ID: <CAD=FV=Xwo6DLDapqpaVc3G+1Sx_rapwsw=w-to0JHy+E_U+-iw@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] ARM: dts: Enable USB host1(dwc) on rk3288-evb
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
> USB host1 port is the host A port nearby the otg port.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
>
> ---
>
> Changes in v5:
> - don't enable otg port for evb
>
> Changes in v4: None
> Changes in v3:
> - Rebase
>
> Changes in v2:
> - evb patch added in version 2
>
>  arch/arm/boot/dts/rk3288-evb.dtsi | 4 ++++
>  1 file changed, 4 insertions(+)

IMHO this series is ready to go in for 3.18.  I'm assuming Heiko will
pick it up once the bindings have landed.

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
