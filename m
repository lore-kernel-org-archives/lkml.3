Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaH3Eaq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 00:30:46 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46322 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaH3Eao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 00:30:44 -0400
MIME-Version: 1.0
In-Reply-To: <1409350027-17604-1-git-send-email-jay.xu@rock-chips.com>
References: <1409350027-17604-1-git-send-email-jay.xu@rock-chips.com>
Date: Fri, 29 Aug 2014 21:30:43 -0700
X-Google-Sender-Auth: NYwkin561a0Rb_GUpPLOoEGFwTI
Message-ID: <CAD=FV=XPYkDJ2J3rTHZgKzbH_EMBUmCMwHWjpf1Aagnv_mUqGQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] rockchip-i2s: add power setting for I2S controller
 and fix some critical bugs
From: Doug Anderson <dianders@chromium.org>
To: Jianqun <jay.xu@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>, perex@perex.cz,
        tiwai@suse.de, yongjun_wei@trendmicro.com.cn,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jianqun,

On Fri, Aug 29, 2014 at 3:07 PM, Jianqun <jay.xu@rock-chips.com> wrote:
> Add optional power setting for i2s controller found on rk3066, rk3168 and rk3288
> processors from rockchip, should according to hardware design.
>
> Default setting for I2S controller is powered by 3.3V, there needs this patch if
> it's powered by 1.8V by hardware design.
>
> Jianqun (2):
>   rockchip-i2s: dt: add grf requested properties to set power of I2S controller
>   rockchip-i2s: add power setting for I2S controller, also fix some bugs
>
>  .../devicetree/bindings/sound/rockchip-i2s.txt     |  6 +-
>  sound/soc/rockchip/rockchip_i2s.c                  | 93 +++++++++++++---------
>  sound/soc/rockchip/rockchip_i2s.h                  | 13 +--
>  3 files changed, 68 insertions(+), 44 deletions(-)

Did the general solution I posted at
<https://patchwork.kernel.org/patch/4807821/> not work for you?  ...or
did you not see that?

-Doug
