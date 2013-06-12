Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3FLJqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:46:39 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:52525 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3FLJqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:46:37 -0400
MIME-Version: 1.0
In-Reply-To: <201306121055.53685.heiko@sntech.de>
References: <201306041136.09566.heiko@sntech.de>
	<201306121055.53685.heiko@sntech.de>
Date: Wed, 12 Jun 2013 11:46:37 +0200
Message-ID: <CACRpkdZmDWTy=U_rhU9uVXy9N5jEOk6qQingiO5kb+Kc2WkL3w@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] dw_apb_timer: osc as sched_clock, clocks and
 clocksource_of support
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jamie Iles <jamie@jamieiles.com>, Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Baruch Siach <baruch@tkos.co.il>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 10:55 AM, Heiko Stübner <heiko@sntech.de> wrote:

> with clocksource_of conversion of picoxcell and socfpga, this series stands on
> its own. Is anybody going to pick it up?

I would suggest you send a pull request to the ARM SoC maintainers.
This is where most clocksource code and refactorings related to
ARM things come in.

Yours,
Linus Walleij
