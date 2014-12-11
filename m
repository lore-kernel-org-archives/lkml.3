Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965567AbaLKWFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:05:15 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:46747 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaLKWFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:05:12 -0500
MIME-Version: 1.0
In-Reply-To: <1418267802-13159-3-git-send-email-zyw@rock-chips.com>
References: <1418267802-13159-1-git-send-email-zyw@rock-chips.com>
	<1418267802-13159-3-git-send-email-zyw@rock-chips.com>
Date: Thu, 11 Dec 2014 14:05:11 -0800
X-Google-Sender-Auth: 5voxkd_ckkTDJz5whi4oTf4gfX4
Message-ID: <CAD=FV=UQ8=05_LS6AVEmWdKgYT=gk9hu+jdK0yOKxNZJApUQLQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] regulator: rk808: add dvs support
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Wed, Dec 10, 2014 at 7:16 PM, Chris Zhong <zyw@rock-chips.com> wrote:
> rk808 has a dvs function, there are 3 pins for dvs, dvs1 & dvs2 & dvsok.
> Normally, the voltage of DCDC1/DCDC2 are controlled by BUCKn_ON_VSEL, when
> we pull dvs1/dvs2 pin to active, they would be controlled by BUCKn_DVS_VSEL.
> And the dvsok pin is used to indicate whether regulating has been completed.
> When dvs1/dvs2 pin change, dvsok would be pull down, and it would be pull up
> once the regulating is complete.
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> ---
>
> Changes in v2:
> - modify the multiline commenting
>
>  drivers/regulator/rk808-regulator.c | 192 +++++++++++++++++++++++++++++++++---
>  1 file changed, 180 insertions(+), 12 deletions(-)

Reviewed-by: Doug Anderson <dianders@chromium.org>
