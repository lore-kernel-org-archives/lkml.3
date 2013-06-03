Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab3FCIkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:40:04 -0400
Received: from gloria.sntech.de ([95.129.55.99]:43653 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab3FCIje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:39:34 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 08/10] clk: add basic Rockchip rk3066a clock support
Date: Mon, 3 Jun 2013 09:52:48 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
References: <201306030055.15413.heiko@sntech.de> <201306030100.31647.heiko@sntech.de> <20130603032711.GA3379@quad.lixom.net>
In-Reply-To: <20130603032711.GA3379@quad.lixom.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201306030952.49089.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 3. Juni 2013, 05:27:11 schrieb Olof Johansson:
> On Mon, Jun 03, 2013 at 01:00:31AM +0200, Heiko Stübner wrote:
> > This adds basic support for clocks on Rockchip rk3066 SoCs.
> > The clock handling thru small dt nodes is heavily inspired by the
> > sunxi clk code.
> > 
> > The clock specifiers are named as "x-cortex-a9-x", because the clock
> > semantics are the same thru the whole cortex-a9 series (rk30xx,
> > rk3188, rk2928; but not the other rk29 SoCs, which are Cortex-A8 based).
> 
> Hi,
> 
> I think you're better off naming them after the first SoC of that series.
> Otherwise, if there's an A9-based platform in the future that is not
> compatible, things will get complicated.
> 
> It's pretty common that we do this for other kinds of devices, so it seems
> appropriate for clock drivers too.

ok, I'll rename them
