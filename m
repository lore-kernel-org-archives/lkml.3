Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbaLSAdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 19:33:33 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:44854 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaLSAdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 19:33:31 -0500
MIME-Version: 1.0
In-Reply-To: <1418948026-3463-1-git-send-email-dtor@chromium.org>
References: <1418948026-3463-1-git-send-email-dtor@chromium.org>
Date: Thu, 18 Dec 2014 16:33:30 -0800
X-Google-Sender-Auth: ZaNNx-yM5UKDeR9NtQHsxOfz15c
Message-ID: <CAD=FV=WmSP09eK0-RQrWP2k=wuBzK4=th28OytpfVsaNP3kgag@mail.gmail.com>
Subject: Re: [PATCH 1/2] CHROMIUM: clk: rockchip: add clock IDs for the PVTM clocks
From: Doug Anderson <dianders@chromium.org>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

On Thu, Dec 18, 2014 at 4:13 PM, Dmitry Torokhov <dtor@chromium.org> wrote:
> From: Huang Lin <hl@rock-chips.com>
>
> Process-Voltage-Temperature Monitor has two clocks, PVTM_CORE and
> PVTM_GPU.
>
> Signed-off-by: Huang Lin <hl@rock-chips.com>
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
> ---
>
> Note that I left a hole at 122 for SCLK_USBPHY480M_SRC which is floating
> around.

I'm sure Heiko can adjust when he lands.


>  include/dt-bindings/clock/rk3288-cru.h | 3 +++
>  1 file changed, 3 insertions(+)

Thanks for sending!

Reviewed-by: Doug Anderson <dianders@chromium.org>
