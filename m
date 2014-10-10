Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbaJJQxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 12:53:11 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:56265 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaJJQxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 12:53:09 -0400
MIME-Version: 1.0
In-Reply-To: <1412916630-8256-2-git-send-email-kever.yang@rock-chips.com>
References: <1412916630-8256-1-git-send-email-kever.yang@rock-chips.com>
	<1412916630-8256-2-git-send-email-kever.yang@rock-chips.com>
Date: Fri, 10 Oct 2014 09:53:08 -0700
X-Google-Sender-Auth: gP6qDT0JApxan3E8kVQy5F94hbc
Message-ID: <CAD=FV=XHrOvgtF9eAibgdOiwOT6dztAh7xCmWzbhRC-dFQmEZQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] clk: rockchip: add 400MHz and 500MHz for rk3288
 clock rate
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        =?UTF-8?B?5oi05YWL6ZyWIChKYWNrKQ==?= <dkl@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever

On Thu, Oct 9, 2014 at 9:50 PM, Kever Yang <kever.yang@rock-chips.com> wrote:
> This patch add 400MHz and 500MHz to clock rate table for rk3288.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
>
> Changes in v2:
> - change the PLL setting of 400M to meet the constraints of TRM
>
>  drivers/clk/rockchip/clk-rk3288.c | 2 ++
>  1 file changed, 2 insertions(+)

Thanks!  These numbers for 400MHz look better.

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
