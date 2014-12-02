Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaLBB0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 20:26:31 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:46081 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518AbaLBB03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 20:26:29 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>,
        Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list\:ARM\/Rockchip SoC..." 
	<linux-rockchip@lists.infradead.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Tony Xie <xxx@rock-chips.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 0/4] This suspend patch is only support cut off the power of cpu and some external
References: <1417423940-1669-1-git-send-email-zyw@rock-chips.com>
	<7htx1f409k.fsf@deeprootsystems.com>
	<CAD=FV=V2go5BMFbiFKu73_aVz5ck949W-kJQ6WLkAQRPJbjPVA@mail.gmail.com>
	<CAD=FV=XuQk17CTNKJY++J+w9Ab9_OUX0ca0A99m7yKPAWSs2=w@mail.gmail.com>
Date: Mon, 01 Dec 2014 17:26:26 -0800
In-Reply-To: <CAD=FV=XuQk17CTNKJY++J+w9Ab9_OUX0ca0A99m7yKPAWSs2=w@mail.gmail.com>
	(Doug Anderson's message of "Mon, 1 Dec 2014 17:07:39 -0800")
Message-ID: <7hmw763kql.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson <dianders@chromium.org> writes:

> Hi,
>
> On Mon, Dec 1, 2014 at 2:08 PM, Doug Anderson <dianders@chromium.org> wrote:
>> Hi,
>>
>> On Mon, Dec 1, 2014 at 11:51 AM, Kevin Hilman <khilman@kernel.org> wrote:
>>> Chris Zhong <zyw@rock-chips.com> writes:
>>>
>>>> devices, since we still lack power_domain driver, so the other power rail
>>>> of rk3288 need keep power on.
>>>> I have tested it on rk3288-evb board, atop next-20141112. goto suspend by type
>>>> "echo mem > /sys/power/state", vdd_cpu is about 0mv by measuring, so it can be
>>>> determined in sleep mode, then press power button to wakeup it.
>>>
>>> I tested this on top of today's linux-next (next-20141201) and it
>>> suspends, but doesn't wake up from any of the button presses.  What
>>> wakeup sources are configured for the rk3288-evb-rk808?
>>
>> Just to close the loop (I talked with Kevin over IM about this, too):
>>
>> I have a huge description of how I tested this as part of my patch at
>> <https://patchwork.kernel.org/patch/5414941/>.  Chris:  I think Kevin
>> has asked you several times to include information like this in your
>> cover letter.  Please, please, please can you try to remember to do
>> this?
>
> Talked to Chris offline.  He said that in his tests the other patches
> weren't needed, so he didn't list any other patches.  Things just
> worked for him.  ...so I guess he did post the instructions that
> worked for him.  Sorry for the complaint.  Possibly things are
> different on "next-20141112" and that's where Chris said he tested.

This series doesn't apply cleanly to next-20141112.  Manually applying
(with fuzz), it boots but I have the same results: it suspends, but none
of the buttons wake it up.

Kevin
