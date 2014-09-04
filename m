Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbaIDEVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 00:21:24 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:50055 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaIDEVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 00:21:22 -0400
MIME-Version: 1.0
In-Reply-To: <1409793159-2573-4-git-send-email-zyw@rock-chips.com>
References: <1409793159-2573-1-git-send-email-zyw@rock-chips.com>
	<1409793159-2573-4-git-send-email-zyw@rock-chips.com>
Date: Wed, 3 Sep 2014 21:21:21 -0700
X-Google-Sender-Auth: -bf0D0Ha3sOfXUh-ThXfsmxtbjY
Message-ID: <CAD=FV=VpJtc+t7qsofjyDncTsVZS3VCuAn0SvKsTjGhxMtyw3Q@mail.gmail.com>
Subject: Re: [PATCH v9 3/3] regulator: RK808: Remove pdata from the regulator
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Wed, Sep 3, 2014 at 6:12 PM, Chris Zhong <zyw@rock-chips.com> wrote:
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> Tested-by: Heiko Stuebner <heiko@sntech.de>
> ---
>
> Changes in v9:
> Adviced by Doug
> - add reg_np
>
> Changes in v8:
> Adviced by Doug
> - remove rk808_regulator_dts() function
> - remove the check about "client->dev.of_node"
>
> Changes in v7:
> - remove pdata struct from header file, add rk808_regulator struct
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
> - some other problem with coding style
>
>  drivers/regulator/rk808-regulator.c |   91 +++++++----------------------------
>  1 file changed, 18 insertions(+), 73 deletions(-)

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
