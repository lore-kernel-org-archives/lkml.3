Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaH2NNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:13:14 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:36816 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbaH2NNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:13:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140827090146.GU17528@sirena.org.uk>
References: <1409062737-12259-1-git-send-email-zyw@rock-chips.com>
	<20140827090146.GU17528@sirena.org.uk>
Date: Fri, 29 Aug 2014 06:13:10 -0700
X-Google-Sender-Auth: xT6S5un5iM6Jago7yZ6_9B7kD9w
Message-ID: <CAD=FV=X1xOg=-_xZ70X5=ZzRLiuws_2gv5n2fj_AaLTYMq58=A@mail.gmail.com>
Subject: Re: [PATCH v6 5/5] regulator: RK808: remove redundant code
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Chris Zhong <zyw@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
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
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Wed, Aug 27, 2014 at 2:01 AM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Aug 26, 2014 at 10:18:57PM +0800, Chris Zhong wrote:
>> remove the redundant code, since pdata has been removed from stuct rk808
>
> I've applied this but if there's further changes needed please wait
> until the MFD changes they depend on have been accepted before
> resending.  This will be less work all round.

Can you clarify?  As Chris makes the MFD changes that Lee and others
have requested then the regulator driver needs to change as well.
It's helpful for reviewers (and testers) of Chris's changes to see how
the regulator driver changes as the MFD interface changes.  Should he
just take you off the CC list until he's ready?

I've asked Chris to please send out the next version of the series
(including the regulator changes needed) since I'd like to see
feedback addressed.  If that doesn't match what you want him to do,
please yell at me and not at him...


Thanks!

-Doug
