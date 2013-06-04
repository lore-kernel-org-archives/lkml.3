Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab3FDONu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:13:50 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:58706 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab3FDONr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:13:47 -0400
Date: Tue, 4 Jun 2013 15:13:42 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jamie Iles <jamie@jamieiles.com>, Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Baruch Siach <baruch@tkos.co.il>
Subject: Re: [PATCH v2 1/4] clocksource: dw_apb_timer_of: enable the use the
 clocksource as sched clock
Message-ID: <20130604141342.GA5308@maple>
References: <201306041136.09566.heiko@sntech.de>
 <201306041137.03319.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201306041137.03319.heiko@sntech.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks goot to me, Heiko!

On Tue, Jun 04, 2013 at 11:37:02AM +0200, Heiko Stübner wrote:
> Currently the dw_apb_timer always expects a separate special timer to be
> availbable for the sched_clock. Some devices using dw_apb_timers do not
> have this sptimer but can use the clocksource as sched_clock instead.
> 
> Therefore enable the driver to distiguish between devices with and without
> sptimer based on the devicetree data and select the correct timer as
> sched_clock.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Acked-by: Jamie Iles <jamie@jamieiles.com>
