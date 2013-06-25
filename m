Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab3FYO5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:57:37 -0400
Received: from multi.imgtec.com ([194.200.65.239]:39259 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab3FYO5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:57:36 -0400
Message-ID: <51C9AFC4.1020305@imgtec.com>
Date: Tue, 25 Jun 2013 15:57:08 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/4] pinctrl: remove slew-rate parameter from tz1090
References: <201306251455.01540.heiko@sntech.de> <201306251456.36499.heiko@sntech.de> <51C99581.2010403@imgtec.com> <CACRpkdaVsKCNzQ9zAG5DXfDO2BFpcCzw5VbmARazOrXCW1kmeQ@mail.gmail.com>
In-Reply-To: <CACRpkdaVsKCNzQ9zAG5DXfDO2BFpcCzw5VbmARazOrXCW1kmeQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_25_15_57_35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/13 14:22, Linus Walleij wrote:
> Can't we just try to come up with a patch that nails down the meaning of
> slew rate in some meaningful manner then?
> 
> So according to:
> http://en.wikipedia.org/wiki/Slew_rate
> a proper expression for slew rate would be dV/dt i.e.
> something like microvolts per microsecond (which then just
> becomes volts/second).
> 
> What we need to figure out is what range will be applicable within
> reasonable doubt for current scenarios and the next few years.
> 
> What are your datasheets specifying here, and what would be
> a proper measure?

My datasheet says:

0: slow (half frequency)
1: fast

I just got a reply back from a hardware engineer, who said that the
relationship with the actual volts/usec will depend on both the drive
strength and the load on the pad, and that a definite answer probably
requires running a simulation.

Cheers
James

