Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab3IYUdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:33:31 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:52412 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab3IYUd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:33:28 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130925200539.GH23337@ld-irv-0074.broadcom.com>
References: <1378986619-26765-1-git-send-email-pekon@ti.com>
	<1378986619-26765-2-git-send-email-pekon@ti.com>
	<20980858CB6D3A4BAE95CA194937D5E73EA15ED7@DBDE04.ent.ti.com>
	<20130925134619.GG10746@radagast>
	<20130925175527.GA23337@ld-irv-0074.broadcom.com>
	<20980858CB6D3A4BAE95CA194937D5E73EA16884@DBDE04.ent.ti.com>
	<20130925200539.GH23337@ld-irv-0074.broadcom.com>
Date: Wed, 25 Sep 2013 13:33:27 -0700
Message-ID: <CAOesGMif301iBe9zxHudkC_G9SzPPy1Mj4XYvQ-MY8nmx4wO+A@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] ARM: OMAP2+: cleaned-up DT support of various ECC schemes
From: Olof Johansson <olof@lixom.net>
To: Brian Norris <computersforpeace@gmail.com>
Cc: "Gupta, Pekon" <pekon@ti.com>,
        "benoit.cousson@linaro.org" <benoit.cousson@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "avinashphilipk@gmail.com" <avinashphilipk@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 1:05 PM, Brian Norris
<computersforpeace@gmail.com> wrote:

> Olof has given good advice on your DT binding and has (slowly) been
> responding to other requests for DT review that make it to his list. I
> see that he hasn't followed up on your changes (this v6), so pinging him
> (as you did) is probably the correct approach. But please do recognize
> that the DT list is very high volume, so it's hard to get good timely
> responses there.

I am not a DT mainainer, but sometimes when I see a binding that
appears to be wrong I speak up. In this case, the binding was one of
those.

That doesn't mean you should necessarily rely on me for the rest of
the review, there are several dedicated maintainers right now that
should be able to spread the load across them, and it is their ack you
should seek on the binding, not mine.

That being said: this latest version looks good to me. See how much
simpler the binding got when you stopped trying to describe driver
behavior and focused on describing hardware? That's the way we want it
to look like.


So, I have no more objections to it, and I hope you can get a quick
review from a DT maintainer on the rest of the binding.


-Olof
