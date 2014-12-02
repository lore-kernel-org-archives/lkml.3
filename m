Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817AbaLBR5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:57:30 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:64703 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550AbaLBR52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:57:28 -0500
MIME-Version: 1.0
In-Reply-To: <1417531766-29669-2-git-send-email-jay.xu@rock-chips.com>
References: <1417531766-29669-1-git-send-email-jay.xu@rock-chips.com>
	<1417531766-29669-2-git-send-email-jay.xu@rock-chips.com>
Date: Tue, 2 Dec 2014 09:57:27 -0800
X-Google-Sender-Auth: yb7xpA1UaeTIKVOKH9c5JteKD1g
Message-ID: <CAD=FV=UhV6gmR4dYUJdPB5tTP9abySCWZotZW_X8ZCtV1v8+cw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ASoC: rockchip-i2s: dt: add an optional property "i2s_clk_out"
From: Doug Anderson <dianders@chromium.org>
To: Jianqun Xu <jay.xu@rock-chips.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>, perex@perex.cz,
        tiwai@suse.de, Sonny Rao <sonnyrao@chromium.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jianqun,

On Tue, Dec 2, 2014 at 6:49 AM, Jianqun Xu <jay.xu@rock-chips.com> wrote:
> Add an property "i2s_clk_out", which enables to output clock to outside
> of rockchip SoCs. Let's make it optional since not each board needs it.
>
> Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
> ---
>  Documentation/devicetree/bindings/sound/rockchip-i2s.txt | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

You forgot to mention that this is a v3 in the subject line and forgot
to mention what changed between v2 and v3 (nothing changed, but you
should say that).

Despite that, this patch looks reasonable to me.

Reviewed-by: Doug Anderson <dianders@chromium.org>
