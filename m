Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaI3Sf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:35:58 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:60271 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaI3Sfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:35:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=WRYeW4giA+yRWmXGxAvdG38GcW-7tA39SZDH1GPamf6A@mail.gmail.com>
References: <1411900693-30484-1-git-send-email-caesar.wang@rock-chips.com>
	<1411900693-30484-4-git-send-email-caesar.wang@rock-chips.com>
	<CAD=FV=WRYeW4giA+yRWmXGxAvdG38GcW-7tA39SZDH1GPamf6A@mail.gmail.com>
Date: Tue, 30 Sep 2014 11:35:53 -0700
X-Google-Sender-Auth: xpmUBPD5YAwrX0aIC0BRcayxkls
Message-ID: <CAD=FV=Wyv9P9cvTFEfD5_0BzgFNC5nyduT0THKKwERkX4-cY0Q@mail.gmail.com>
Subject: Re: [PATCH v7 3/5] ARM: dts: add RK3xxx CPU Thermal data
From: Doug Anderson <dianders@chromium.org>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, zyf <zyf@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Eddie Cai <cf@rock-chips.com>, Derek Basehore <dbasehore@chromium.org>,
        Tao Huang <huangtao@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 30, 2014 at 11:24 AM, Doug Anderson <dianders@chromium.org> wrote:
> Caesar,
>
> On Sun, Sep 28, 2014 at 3:38 AM, Caesar Wang <caesar.wang@rock-chips.com> wrote:
>> This patch changes a dtsi file to contain the thermal data
>> on RK3288 and later SoCs. This data will
>> enable a thermal shutdown over 125C.
>>
>> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
>> ---
>>  arch/arm/boot/dts/rk3xxx-cpu-thermal.dtsi | 32 +++++++++++++++++++++++++++++++
>>  1 file changed, 32 insertions(+)
>>  create mode 100644 arch/arm/boot/dts/rk3xxx-cpu-thermal.dtsi
>
> I haven't done lots of review of this series, but I did notice that
> this file has bad spacing.  It's fairly obvious in your gerrit patch
> <https://chromium-review.googlesource.com/#/c/220270/1/arch/arm/boot/dts/rk3xxx-cpu-thermal.dtsi>
> because gerrit (by default) shows you "tab" characters...
>
> In general you should use tab for indentation, not spaces.  You seem
> to use a mix of the two.

I suppose I should also point out that it's generally not great to
name things "rk3xxx" since it makes too many predictions about how
future products will behave.  It's better to name things after the
first relevant product.  I'd just name this "rk3288-cpu-thermal.dtsi".

-Doug
