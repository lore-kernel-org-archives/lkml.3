Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab3FDOPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:15:34 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:52416 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab3FDOPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:15:30 -0400
Date: Tue, 4 Jun 2013 15:15:26 +0100
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
Subject: Re: [PATCH v2 2/4] clocksource: dw_apb_timer_of: add clock-handling
Message-ID: <20130604141526.GB5308@maple>
References: <201306041136.09566.heiko@sntech.de>
 <201306041137.37036.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201306041137.37036.heiko@sntech.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 11:37:36AM +0200, Heiko Stübner wrote:
> Add the possibility to get the clock-frequency from a timer clock instead
> of specifying it as dt property. Additionally also add the possibility
> to also define a controlling periphal clock for the timer block.
> 
> The clock-frequency property is kept to act as fallback if no clocks
> are specified.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Acked-by: Jamie Iles <jamie@jamieiles.com>
