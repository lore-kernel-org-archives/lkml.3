Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaLSAjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 19:39:07 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:47140 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaLSAjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 19:39:05 -0500
MIME-Version: 1.0
In-Reply-To: <1418948026-3463-2-git-send-email-dtor@chromium.org>
References: <1418948026-3463-1-git-send-email-dtor@chromium.org>
	<1418948026-3463-2-git-send-email-dtor@chromium.org>
Date: Thu, 18 Dec 2014 16:33:55 -0800
X-Google-Sender-Auth: UlbWM_Tzgj5bPlnrexPkV-Q6Xp8
Message-ID: <CAD=FV=XNMLpLq8doA+h_1mxT1CjSxVshRN_KaxLCPA8veTVvRw@mail.gmail.com>
Subject: Re: [PATCH 2/2] CHROMIUM: clk: rockchip: add PVTM clocks on rk3288
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
> From: huang lin <hl@rock-chips.com>
>
> Process-Voltage-Temperatiure Monitor block on RK3288 has two clocks:
> PVTM_CORE and PVTM_GPU.
>
> Signed-off-by: Huang Lin <hl@rock-chips.com>
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
> ---
>  drivers/clk/rockchip/clk-rk3288.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks for sending!

Reviewed-by: Doug Anderson <dianders@chromium.org>
