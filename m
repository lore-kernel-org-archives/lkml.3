Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab3FDOQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:16:19 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:64005 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab3FDOP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:15:57 -0400
Date: Tue, 4 Jun 2013 15:15:54 +0100
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
Subject: Re: [PATCH v2 3/4] clocksource: dw_apb_timer_of: select DW_APB_TIMER
Message-ID: <20130604141554.GC5308@maple>
References: <201306041136.09566.heiko@sntech.de>
 <201306041138.11447.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201306041138.11447.heiko@sntech.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 11:38:11AM +0200, Heiko Stübner wrote:
> dw_apb_timer_of is the driver part facing devicetree platforms and
> calls into dw_apb_timer with the data gathered from the dt.
> 
> Currently the two platforms using the dw_apb_timer_of select both
> the options for the core timer and the dt addon.
> 
> As dw_apb_timer_of always depends on dw_apb_timer let it select
> DW_APB_TIMER itself without the need for every platform to do it.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Acked-by: Jamie Iles <jamie@jamieiles.com>
