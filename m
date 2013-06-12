Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab3FLRxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:53:09 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:36532 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523Ab3FLRxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:53:07 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130612175142.GB2760@quad.lixom.net>
References: <201306041136.09566.heiko@sntech.de>
	<201306121055.53685.heiko@sntech.de>
	<CACRpkdZmDWTy=U_rhU9uVXy9N5jEOk6qQingiO5kb+Kc2WkL3w@mail.gmail.com>
	<20130612175142.GB2760@quad.lixom.net>
Date: Wed, 12 Jun 2013 10:53:06 -0700
Message-ID: <CAOesGMjogjjFcvKbQtyY+DpW5WOcoo7mSxfqeyre22vP5-OUjA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] dw_apb_timer: osc as sched_clock, clocks and
 clocksource_of support
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Baruch Siach <baruch@tkos.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 10:51 AM, Olof Johansson <olof@lixom.net> wrote:
> On Wed, Jun 12, 2013 at 11:46:37AM +0200, Linus Walleij wrote:
>> On Wed, Jun 12, 2013 at 10:55 AM, Heiko Stübner <heiko@sntech.de> wrote:
>>
>> > with clocksource_of conversion of picoxcell and socfpga, this series stands on
>> > its own. Is anybody going to pick it up?
>>
>> I would suggest you send a pull request to the ARM SoC maintainers.
>> This is where most clocksource code and refactorings related to
>> ARM things come in.
>
> Yeah, or we can pick them up and apply from the list too. Have you collected
> all Acked-bys and reposted a final version? If not, cc arm@kenrel.org on the
> final posting.

Nevermind, I just came across the pull request. :-)


-Olof
