Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbaHZVIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:08:51 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:51073 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbaHZVIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:08:48 -0400
MIME-Version: 1.0
In-Reply-To: <1409062737-12259-1-git-send-email-zyw@rock-chips.com>
References: <1409062737-12259-1-git-send-email-zyw@rock-chips.com>
Date: Tue, 26 Aug 2014 14:08:48 -0700
X-Google-Sender-Auth: khOCnsTt9oGdmLgzlEy7Ix3mxXM
Message-ID: <CAD=FV=WHM1ouCA_D35MG9u9B+gYLC8MGebw_X94_bLkkDVKCXQ@mail.gmail.com>
Subject: Re: [PATCH v6 5/5] regulator: RK808: remove redundant code
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Tue, Aug 26, 2014 at 7:18 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> remove the redundant code, since pdata has been removed from stuct rk808
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> ---
>
> Changes in v6:
> - remove the redundant code
>
> Changes in v5:
> - re-edit base on Mark's branch
>
> Changes in v4:
> - use &client->dev replace rk808->dev
>
> Changes in v3: None
> Changes in v2:
> Adviced by Mark Browm:
> - change of_find_node_by_name to find_child_by_name
> - use RK808_NUM_REGULATORS as the name of the constant
> - create a pdata when missing platform data
> - use the rk808_reg name to supply_regulator name
> - replace regulator_register with devm_regulator_register
> - some other problem with coding styl
>
>  drivers/regulator/rk808-regulator.c |   17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)

Probably shouldn't land until we've solved problems around the
"platform data" in the MFD patch...
