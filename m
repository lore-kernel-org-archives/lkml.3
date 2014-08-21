Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbaHUISy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:18:54 -0400
Received: from gloria.sntech.de ([95.129.55.99]:53973 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634AbaHUISu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:18:50 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Russell King <linux@arm.linux.org.uk>,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 11/11] clk: rockchip: add restart handler
Date: Thu, 21 Aug 2014 10:18:08 +0200
Message-ID: <18796253.Gqruund2RM@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAD=FV=U+WbodSLyQVQieiKkWNTBROCktJLgR9B8eOWZhGWYxgg@mail.gmail.com>
References: <1408495538-27480-1-git-send-email-linux@roeck-us.net> <1408495538-27480-12-git-send-email-linux@roeck-us.net> <CAD=FV=U+WbodSLyQVQieiKkWNTBROCktJLgR9B8eOWZhGWYxgg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 20. August 2014, 21:15:10 schrieb Doug Anderson:
> Guenter / Heiko,
> 
> On Tue, Aug 19, 2014 at 5:45 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > From: Heiko Stübner <heiko@sntech.de>
> > 
> > Add infrastructure to write the correct value to the restart register and
> > register the restart notifier for both rk3188 (including rk3066) and
> > rk3288.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > v7: Added patch to series.
> > 
> >  drivers/clk/rockchip/clk-rk3188.c |  2 ++
> >  drivers/clk/rockchip/clk-rk3288.c |  2 ++
> >  drivers/clk/rockchip/clk.c        | 25 +++++++++++++++++++++++++
> >  drivers/clk/rockchip/clk.h        |  1 +
> >  4 files changed, 30 insertions(+)
> 
> This patch doesn't apply cleanly with the in-flight (clk: rockchip:
> protect critical clocks from getting disabled) patch from Heiko.  It's
> trivial to resolve and unclear which will land first, so I think it's
> fine...

This should be expected :-) .

The patch about critical clocks will (hopefully soon) go through Mike's tree, 
while this series will most likely go through somewhere else (Linus' tree 
directly or something), so I guess the merge conflic will be resolved by Linus 
when both trees meet each other during the merge window.
So both this patch as well as the other one should stay independent of each 
other.


Heiko
