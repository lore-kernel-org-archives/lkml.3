Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaKZAtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:49:12 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:48908 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaKZAtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:49:10 -0500
MIME-Version: 1.0
In-Reply-To: <1717801.sWHeWsmqUi@diego>
References: <1416960783-25119-1-git-send-email-dianders@chromium.org>
	<1717801.sWHeWsmqUi@diego>
Date: Tue, 25 Nov 2014 16:49:08 -0800
X-Google-Sender-Auth: SFGRHF_KMz1_VAfh-ICwP3_JctA
Message-ID: <CAD=FV=WxeFFZekYOkttx4YcDq=td+Vpu9rFALuNu_6zs+7b2tw@mail.gmail.com>
Subject: Re: [PATCH 1/2] clk: rockchip: add binding ID for DMC (memory
 controller) clocks on rk3288
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: jeff chen <cym@rock-chips.com>, Mike Turquette <mturquette@linaro.org>,
        Derek Basehore <dbasehore@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kever Yang <kever.yang@rock-chips.com>,
        Mark yao <mark.yao@rock-chips.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

On Tue, Nov 25, 2014 at 4:45 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Dienstag, 25. November 2014, 16:13:02 schrieb Doug Anderson:
>> From: Jeff Chen <cym@rock-chips.com>
>>
>> The DMC clocks need to be turned off at runtime, so we should have IDs
>> so we can export them.
>>
>> Signed-off-by: Jeff Chen <cym@rock-chips.com>
>> [dianders: split into two patches; adjusted commit msg]
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>
> both patches look ok to me and I'll probably pick them up tomorrow.

OK, thanks!


> Just as handling question, do you plan on sending dts changes using these
> clocks in time for 3.19 [i.e. in the next couple of days]?

There's pretty much zero chance.  Maybe negative.


> We have currently three clock patches/series adding new clock ids [this one,
> the mmc phases and Sonny's i2s_clkout] and I'm trying to dertermine if I need
> a shared branch for those.
>
> Currently it doesn't look like the others will provide dts patches using the
> clocks in time, so it looks like I can skip the shared branch and we can use
> the clock ids regularly after the merge-window. Some true for your clocks?

Yup, no problem for me.  I provided this as two patches to you just in
case it was convenient, since I saw that as feedback in previous
submissions.

Thanks!

-Doug
