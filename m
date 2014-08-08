Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbaHHPmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:42:18 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:41142 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259AbaHHPmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:42:16 -0400
MIME-Version: 1.0
In-Reply-To: <1407470159-14722-2-git-send-email-kever.yang@rock-chips.com>
References: <1407470159-14722-1-git-send-email-kever.yang@rock-chips.com>
	<1407470159-14722-2-git-send-email-kever.yang@rock-chips.com>
Date: Fri, 8 Aug 2014 08:42:14 -0700
X-Google-Sender-Auth: 97YGotsrKSePSDgLmyMpAUc6TEM
Message-ID: <CAD=FV=WzGJ5HMffxRKMTS_Rue5VRK+M6kU3suv316sJS=81sQw@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] Documentation: dt-bindings: add dt binding info
 for Rockchip dwc2
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paul Zimmerman <paulz@synopsys.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, wulf <wulf@rock-chips.com>,
        lyz <lyz@rock-chips.com>, han jiang <hj@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Matt Porter <mporter@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Thu, Aug 7, 2014 at 8:55 PM, Kever Yang <kever.yang@rock-chips.com> wrote:
> This add necessary dwc2 binding documentation for Rockchip socs:
> rk3066, rk3188 and rk3288
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> Acked-by: Stephen Warren <swarren@nvidia.com>
> ---
>
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2:
> - Split out dr_mode and rk3288 bindings.
> - add compatible "snps,dwc2" bingding info
>
>  Documentation/devicetree/bindings/usb/dwc2.txt | 3 +++
>  1 file changed, 3 insertions(+)

IMHO this series is ready to go in for 3.18 whenever maintainers feel
it's the right time.

Reviewed-by: Doug Anderson <dianders@chromium.org>
