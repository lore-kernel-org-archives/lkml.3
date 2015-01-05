Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbbAEOiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:38:52 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:38392 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbbAEOiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:38:51 -0500
MIME-Version: 1.0
In-Reply-To: <20141219162343.GF11764@sirena.org.uk>
References: <1414729631-11005-1-git-send-email-tharvey@gateworks.com>
	<1414729631-11005-5-git-send-email-tharvey@gateworks.com>
	<CAOMZO5DzEe91pTv+UkCbj0DzgVDOb9hjuakt9NmpTJnEk-j8UA@mail.gmail.com>
	<CAJ+vNU3PQYCE4tABUiqU+vGkGqBEqdVKz25W88-ByOQZxunVLw@mail.gmail.com>
	<20141218142205.GZ11764@sirena.org.uk>
	<CAJ+vNU1YQWGFaEm8w8wtaFvUy1jig26jW3+3teMFHLB_oFyn8Q@mail.gmail.com>
	<20141219162343.GF11764@sirena.org.uk>
Date: Mon, 5 Jan 2015 06:38:50 -0800
Message-ID: <CAJ+vNU0S_=H=VDwxUXBGyNrvjg5MRe3UP-UV9Xnj3MkNdWM0ng@mail.gmail.com>
Subject: Re: [PATCH 4/5] cpufreq: imx6q: add ldo-bypass support
From: Tim Harvey <tharvey@gateworks.com>
To: Mark Brown <broonie@kernel.org>, Fabio Estevam <festevam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Silvio F <silvio.fricke@gmail.com>, Christian Hemp <c.hemp@phytec.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Iain Paton <ipaton0@gmail.com>, Anson.Huang@freescale.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 8:23 AM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Dec 19, 2014 at 08:17:41AM -0800, Tim Harvey wrote:
>
>> frequency setpoint. If however you have an external PMIC that is
>> capable of adjusting the VDD_ARM and VDD_SOC to the IMX6 and an
>> appropriate regulator driver is capable of doing so, you must
>> configure the cpu nodes vddarm and vddsoc regulators to those provided
>> by your PMIC and 'bypass' the internal LDO's by setting their scaling
>
> You're describing the implementation again, not the system.  Describe
> the system then if you want to describe the solution you've come up with
> for modelling it do so separately.
>
> Please also try to use paragraphs to break up what you're saying a bit.

Mark,

I'm not sure I'm understanding what your asking for or how to describe
it differently. Fabio / Shawn / Philipp could you help me out here
with the proper explanation of the IMX6 LDO's so that we can make some
progress on getting LDO bypass implemented?

Regards,

Tim
