Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaLCQ7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:59:53 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:39415 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaLCQ7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:59:51 -0500
MIME-Version: 1.0
In-Reply-To: <20141203164951.GI11285@n2100.arm.linux.org.uk>
References: <1417461694-5129-1-git-send-email-dianders@chromium.org>
	<20141201225057.GA11285@n2100.arm.linux.org.uk>
	<CAD=FV=VT7gr504-ZgWPfha+40XDX5eShkzZ36bg=-4Oub1S27w@mail.gmail.com>
	<25485084.A6ydfR9Xle@wuerfel>
	<CAD=FV=UFWZEcbO2ty0m+qEGv4Xgq0N=Rs30wBgw=6+OGd5gSpg@mail.gmail.com>
	<CACRpkdapVhrQe7n5wDzZbf3fYGGpB-jPzG8Z+A8X6j5ERLxAfg@mail.gmail.com>
	<CAD=FV=Vn_U6YWFN-hruWcYo-HSHt9=hwduEv32Bb5aP_hzNB8Q@mail.gmail.com>
	<20141203164951.GI11285@n2100.arm.linux.org.uk>
Date: Wed, 3 Dec 2014 08:59:50 -0800
X-Google-Sender-Auth: UYRXza1gPJL_jzORTUEhmivqnM8
Message-ID: <CAD=FV=VDD82SD85WS3MGBChKTfdvxvK0L1iJW6R1cwqZeqx0LQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: rockchip: Convert resume code to C
From: Doug Anderson <dianders@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Russ Dill <russ.dill@gmail.com>, Olof Johansson <olof@lixom.net>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Chris Zhong <zyw@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On Wed, Dec 3, 2014 at 8:49 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Dec 03, 2014 at 08:44:55AM -0800, Doug Anderson wrote:
>> Sure.  I look forward to someone solving it.  ...and as I said, until
>> someone does solve it I think we're blocked from landing deep sleep
>> mode for rk3288 upstream (unless someone decides that my patches are
>> OK).
>
> What we definitely don't want to do is to have each SoC doing their
> own thing on this, so we really need it to either be generic across
> all ARMs, or fully generic.
>
> So, if it can be turned into some kind of generic infrastructure, I'd
> be happier with it, because that would help it be re-used across other
> SoCs.

If folks can come up with a way to adapt my current approach to be
acceptable then I'm happy to do it.

...but if not then I'll happily drop this patch and patiently await
the day when this problem is solved upstream.  Once that happens,
someone can try landing the deep sleep for rk3288 using that new
approach.


-Doug
