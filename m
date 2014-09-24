Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaIXR5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:57:23 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:51970 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaIXR5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:57:21 -0400
MIME-Version: 1.0
In-Reply-To: <1411572802-22042-3-git-send-email-kever.yang@rock-chips.com>
References: <1411572802-22042-1-git-send-email-kever.yang@rock-chips.com>
	<1411572802-22042-3-git-send-email-kever.yang@rock-chips.com>
Date: Wed, 24 Sep 2014 10:57:20 -0700
X-Google-Sender-Auth: ZsriFer_SYXnINymhQX_abA_wJY
Message-ID: <CAD=FV=X1A6zKsGzctS6_Ve_zuNRW6_5kyawPEK1VeBJTimXTwA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] clk: rockchip: use the clock id for nodes init
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Wed, Sep 24, 2014 at 8:33 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> This patch use the new defined clock ID to initial the clock nodes.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> ---
>
> Changes in v2:
> - split into two patches of add clock node in PD_VIDEO and
>   use new defined clock ID
>
>  drivers/clk/rockchip/clk-rk3288.c | 68 +++++++++++++++++++--------------------
>  1 file changed, 34 insertions(+), 34 deletions(-)

Reviewed-by: Doug Anderson <dianders@chromium.org>
