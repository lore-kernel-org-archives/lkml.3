Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab3FCD1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 23:27:20 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:63854 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab3FCD1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 23:27:12 -0400
Date: Sun, 2 Jun 2013 20:27:11 -0700
From: Olof Johansson <olof@lixom.net>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
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
Subject: Re: [PATCH 08/10] clk: add basic Rockchip rk3066a clock support
Message-ID: <20130603032711.GA3379@quad.lixom.net>
References: <201306030055.15413.heiko@sntech.de>
 <201306030100.31647.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201306030100.31647.heiko@sntech.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 01:00:31AM +0200, Heiko Stübner wrote:
> This adds basic support for clocks on Rockchip rk3066 SoCs.
> The clock handling thru small dt nodes is heavily inspired by the
> sunxi clk code.
> 
> The clock specifiers are named as "x-cortex-a9-x", because the clock
> semantics are the same thru the whole cortex-a9 series (rk30xx,
> rk3188, rk2928; but not the other rk29 SoCs, which are Cortex-A8 based).

Hi,

I think you're better off naming them after the first SoC of that series.
Otherwise, if there's an A9-based platform in the future that is not
compatible, things will get complicated.

It's pretty common that we do this for other kinds of devices, so it seems
appropriate for clock drivers too.


-Olof

