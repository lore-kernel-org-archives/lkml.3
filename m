Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaLPVEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 16:04:47 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:56632 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaLPVEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 16:04:46 -0500
MIME-Version: 1.0
In-Reply-To: <1415863357-15680-2-git-send-email-kever.yang@rock-chips.com>
References: <1415863357-15680-1-git-send-email-kever.yang@rock-chips.com>
	<1415863357-15680-2-git-send-email-kever.yang@rock-chips.com>
Date: Tue, 16 Dec 2014 13:04:45 -0800
X-Google-Sender-Auth: oxiyiyMfVIvCsNAa6OSCraO2Lbg
Message-ID: <CAD=FV=US1eS4jj-uVFpG2hYFQ3W1D-B3D_ysaCrbee8L=dEU-g@mail.gmail.com>
Subject: Re: [PATCH 2/2] clk: rockchip: use the clock ID for usbphy480m_src
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>,
        =?UTF-8?B?5oi05YWL6ZyWIChKYWNrKQ==?= <dkl@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Wed, Nov 12, 2014 at 11:22 PM, Kever Yang <kever.yang@rock-chips.com> wrote:
> Use the clock ID for usbphy480m_src so that we can find
> this clock node in dts.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
>
>  drivers/clk/rockchip/clk-rk3288.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Tested-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Doug Anderson <dianders@chromium.org>
