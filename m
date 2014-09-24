Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbaIXR5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:57:03 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:38777 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaIXR5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:57:00 -0400
MIME-Version: 1.0
In-Reply-To: <1411572802-22042-2-git-send-email-kever.yang@rock-chips.com>
References: <1411572802-22042-1-git-send-email-kever.yang@rock-chips.com>
	<1411572802-22042-2-git-send-email-kever.yang@rock-chips.com>
Date: Wed, 24 Sep 2014 10:56:59 -0700
X-Google-Sender-Auth: 14mWZ0zm0C6X21jyVOG9tCLjAI8
Message-ID: <CAD=FV=U1T8iApFw_PAUdw3=4+=HW3dEpJZ2smCg-DYroPcibog@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] clk: rockchip: add some needed clock binding id
 for rk3288
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Wed, Sep 24, 2014 at 8:33 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> This patch add some clock binding id for different modules
> that under development and going to send upstream.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> ---
>
> Changes in v2: None
>
>  include/dt-bindings/clock/rk3288-cru.h | 38 +++++++++++++++++++++++++++++++++-
>  1 file changed, 37 insertions(+), 1 deletion(-)

Reviewed-by: Doug Anderson <dianders@chromium.org>
