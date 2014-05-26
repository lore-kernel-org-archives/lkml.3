Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaEZPH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:07:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42089 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaEZPH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:07:28 -0400
Message-ID: <1401116825.3400.27.camel@paszta.hi.pengutronix.de>
Subject: Re: [GIT PULL] clockevents: new material for 3.16
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Matthew Leach <matthew.leach@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Xiubo Li <Li.Xiubo@freescale.com>, "Yang,Wei" <Wei.Yang@windriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        khilman@linaro.org
Date: Mon, 26 May 2014 17:07:05 +0200
In-Reply-To: <20140526134052.GA3790@lukather>
References: <537F214C.8000700@linaro.org>
	 <20140526194512.032c6630@canb.auug.org.au> <53830ED9.9060001@linaro.org>
	 <20140526134052.GA3790@lukather>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Am Montag, den 26.05.2014, 15:40 +0200 schrieb Maxime Ripard:
> On Mon, May 26, 2014 at 11:52:25AM +0200, Daniel Lezcano wrote:
> > On 05/26/2014 11:45 AM, Stephen Rothwell wrote:
> > >Hi all,
> > >
> > >On Fri, 23 May 2014 12:22:04 +0200 Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> > >>
> > >>        clocksource: sun5i: Add support for reset controller
> > >
> > >This commit caused a build failure on arm in linux-next today ...
> 
> It's weird... of_reset_control_get has been merged in 3.15 by this
> commit fc0a5921561c71be2c334a335c1680f7930434d7 ("reset: Add
> of_reset_control_get"), and then the commit
> b424080a9e086e683ad5fdc624a7cf3c024e0c0f ("reset: Add optional resets
> and stubs") removed it, still in 3.15 (probably a mismerge).
> 
> Finally, Hans de Goede introduced it back in the following patch:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/246738.html
> 
> That should have shown up in one of 3.15-rc's according to:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/252317.html
> 
> Philipp, what's going on?

I have sent a pull request now.

regards
Philipp

