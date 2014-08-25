Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbaHYEJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 00:09:52 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:60993 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaHYEJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 00:09:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140823145737.GJ24407@sirena.org.uk>
References: <1408791890-17328-1-git-send-email-zyw@rock-chips.com>
	<20140823145737.GJ24407@sirena.org.uk>
Date: Sun, 24 Aug 2014 21:09:49 -0700
X-Google-Sender-Auth: 1dOIMtZSYgY-Xvgau6VKDtTosyQ
Message-ID: <CAD=FV=XsNn9OHZkmtGEvX0HoidzH=aSF0e9cm6MB3Xq==UBZaA@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] Regulator: RK808: Add regulator driver for RK808
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
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
        Kever Yang <kever.yang@rock-chips.com>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Sat, Aug 23, 2014 at 7:57 AM, Mark Brown <broonie@kernel.org> wrote:
> On Sat, Aug 23, 2014 at 07:04:50PM +0800, Chris Zhong wrote:
>> The regulator module consists of 4 DCDCs, 8 LDOs and 2 switches.
>> The output voltages are configurable and are meant to supply power
>> to the main processor and other components
>
> To repeat what I said on your previous posting: this driver has already
> been applied, if there are any changes required please send incremental
> patches against what is in the tree.

In you're next version, you should include your fixup to the regulator
driver in the series and you shouldn't include the regulator patch.
So you'd have:

1. Regulator: RK808: modify for struct rk808 change
2. MFD: Add rk808 device tree bindings documentation
3. MFD: RK808: Add new mfd driver for RK808
4. RTC: RK808: add RTC driver for RK808
5. Clk: RK808: Add clkout driver for RK808

Also please check your capitalization.  "Clk" should be "clk" and you
should be consistent about whether RK808 is caps or lower case.
