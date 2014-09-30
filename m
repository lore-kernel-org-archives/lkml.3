Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaI3SYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:24:32 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:36670 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbaI3SY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:24:29 -0400
MIME-Version: 1.0
In-Reply-To: <1411900693-30484-4-git-send-email-caesar.wang@rock-chips.com>
References: <1411900693-30484-1-git-send-email-caesar.wang@rock-chips.com>
	<1411900693-30484-4-git-send-email-caesar.wang@rock-chips.com>
Date: Tue, 30 Sep 2014 11:24:28 -0700
X-Google-Sender-Auth: D2ac7zS6aSVq7BuYWNnMbtvs2hY
Message-ID: <CAD=FV=WRYeW4giA+yRWmXGxAvdG38GcW-7tA39SZDH1GPamf6A@mail.gmail.com>
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

Caesar,

On Sun, Sep 28, 2014 at 3:38 AM, Caesar Wang <caesar.wang@rock-chips.com> wrote:
> This patch changes a dtsi file to contain the thermal data
> on RK3288 and later SoCs. This data will
> enable a thermal shutdown over 125C.
>
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> ---
>  arch/arm/boot/dts/rk3xxx-cpu-thermal.dtsi | 32 +++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>  create mode 100644 arch/arm/boot/dts/rk3xxx-cpu-thermal.dtsi

I haven't done lots of review of this series, but I did notice that
this file has bad spacing.  It's fairly obvious in your gerrit patch
<https://chromium-review.googlesource.com/#/c/220270/1/arch/arm/boot/dts/rk3xxx-cpu-thermal.dtsi>
because gerrit (by default) shows you "tab" characters...

In general you should use tab for indentation, not spaces.  You seem
to use a mix of the two.

-Doug
