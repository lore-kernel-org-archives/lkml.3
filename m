Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbaIDTHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:07:20 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:40603 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaIDTHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:07:17 -0400
MIME-Version: 1.0
In-Reply-To: <1409793159-2573-4-git-send-email-zyw@rock-chips.com>
References: <1409793159-2573-1-git-send-email-zyw@rock-chips.com>
	<1409793159-2573-4-git-send-email-zyw@rock-chips.com>
Date: Thu, 4 Sep 2014 12:07:16 -0700
X-Google-Sender-Auth: z988y_-ukN7HfT4xv7DXRipYV5w
Message-ID: <CAD=FV=VhB93xOTYB3LoZhq2bsjRh8uZp4ehyPLzU_A+=f8NV0w@mail.gmail.com>
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

Hi,

On Wed, Sep 3, 2014 at 6:12 PM, Chris Zhong <zyw@rock-chips.com> wrote:

> - * Author: Chris Zhong <zyw@rock-chips.com>
> - * Author: Zhang Qing <zhangqing@rock-chips.com>
> + * Author: Chris Zhong<zyw@rock-chips.com>
> + * Author: Zhang Qing<zhanqging@rock-chips.com>

As Dmitry pointed out, you probably shouldn't have changed these
lines--they were good like they were.

-Doug
