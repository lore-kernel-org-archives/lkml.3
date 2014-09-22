Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121AbaIVESO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 00:18:14 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:43569 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaIVESL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 00:18:11 -0400
MIME-Version: 1.0
In-Reply-To: <1411354380-14326-2-git-send-email-zyw@rock-chips.com>
References: <1411354380-14326-1-git-send-email-zyw@rock-chips.com>
	<1411354380-14326-2-git-send-email-zyw@rock-chips.com>
Date: Sun, 21 Sep 2014 21:18:10 -0700
X-Google-Sender-Auth: 9IU4Fp1gayXcVZLCavrSVG3kQXQ
Message-ID: <CAD=FV=VxqQhp8A_yGMe8U+_Z1DNzLvMp-Bsj_iEx=5mumeHpvw@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] regulator: st-pwm: get voltage and duty table from dts
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Sun, Sep 21, 2014 at 7:52 PM, Chris Zhong <zyw@rock-chips.com> wrote:
> Get voltage & duty table from device tree might be better, other platforms can also use this
> driver without any modify.
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> Reviewed-by: Doug Anderson <dianders@chromium.org>

No need to re-spin, but please remember that all tags should be
bunched together (no blank lines).  In other words,

YES:

> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> Reviewed-by: Doug Anderson <dianders@chromium.org>

NO:

> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
