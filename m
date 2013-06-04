Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab3FDJoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:44:05 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:49032 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3FDJoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:44:00 -0400
MIME-Version: 1.0
In-Reply-To: <201306041029.39053.heiko@sntech.de>
References: <201306030055.15413.heiko@sntech.de>
	<201306030056.03522.heiko@sntech.de>
	<CACRpkdYAvUQ+aymJm1Fw1bE1aGdO7RUqLR9byvoT7ECTk4tkpw@mail.gmail.com>
	<201306041029.39053.heiko@sntech.de>
Date: Tue, 4 Jun 2013 11:43:59 +0200
Message-ID: <CACRpkdYXhsTRVaqi-KKLsuJut1Eq2kzSbSYzaZT=5FpMHSsouA@mail.gmail.com>
Subject: Re: [PATCH 01/10] clocksource: dw_apb_timer_of: use the clocksource
 as sched clock if necessary
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 10:29 AM, Heiko Stübner <heiko@sntech.de> wrote:

> How about:
>
> Currently the dw_apb_timer always expects a separate special timer to be
> availbable for the sched_clock. Some devices using dw_apb_timers do not
> have this sptimer but can use the clocksource as sched_clock instead.
>
> Therefore enable the driver to distiguish between devices with and without
> sptimer based on the devicetree data and select the correct timer as
> sched_clock.

Allright, Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
