Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaLCQuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:50:14 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:36073 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750833AbaLCQuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:50:12 -0500
Date: Wed, 3 Dec 2014 16:49:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Doug Anderson <dianders@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Russ Dill <russ.dill@gmail.com>, Olof Johansson <olof@lixom.net>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Chris Zhong <zyw@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>
Subject: Re: [PATCH] ARM: rockchip: Convert resume code to C
Message-ID: <20141203164951.GI11285@n2100.arm.linux.org.uk>
References: <1417461694-5129-1-git-send-email-dianders@chromium.org>
 <20141201225057.GA11285@n2100.arm.linux.org.uk>
 <CAD=FV=VT7gr504-ZgWPfha+40XDX5eShkzZ36bg=-4Oub1S27w@mail.gmail.com>
 <25485084.A6ydfR9Xle@wuerfel>
 <CAD=FV=UFWZEcbO2ty0m+qEGv4Xgq0N=Rs30wBgw=6+OGd5gSpg@mail.gmail.com>
 <CACRpkdapVhrQe7n5wDzZbf3fYGGpB-jPzG8Z+A8X6j5ERLxAfg@mail.gmail.com>
 <CAD=FV=Vn_U6YWFN-hruWcYo-HSHt9=hwduEv32Bb5aP_hzNB8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=Vn_U6YWFN-hruWcYo-HSHt9=hwduEv32Bb5aP_hzNB8Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 08:44:55AM -0800, Doug Anderson wrote:
> Sure.  I look forward to someone solving it.  ...and as I said, until
> someone does solve it I think we're blocked from landing deep sleep
> mode for rk3288 upstream (unless someone decides that my patches are
> OK).

What we definitely don't want to do is to have each SoC doing their
own thing on this, so we really need it to either be generic across
all ARMs, or fully generic.

So, if it can be turned into some kind of generic infrastructure, I'd
be happier with it, because that would help it be re-used across other
SoCs.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
