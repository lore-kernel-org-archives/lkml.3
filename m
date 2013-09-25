Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab3IYV3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:29:12 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41154 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab3IYV3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:29:10 -0400
Date: Wed, 25 Sep 2013 14:29:03 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Olof Johansson <olof@lixom.net>
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
        "Balbi, Felipe" <balbi@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v6 1/4] ARM: OMAP2+: cleaned-up DT support of various
 ECC schemes
Message-ID: <20130925212903.GI23337@ld-irv-0074.broadcom.com>
References: <1378986619-26765-1-git-send-email-pekon@ti.com>
 <1378986619-26765-2-git-send-email-pekon@ti.com>
 <20980858CB6D3A4BAE95CA194937D5E73EA15ED7@DBDE04.ent.ti.com>
 <20130925134619.GG10746@radagast>
 <20130925175527.GA23337@ld-irv-0074.broadcom.com>
 <20980858CB6D3A4BAE95CA194937D5E73EA16884@DBDE04.ent.ti.com>
 <20130925200539.GH23337@ld-irv-0074.broadcom.com>
 <CAOesGMif301iBe9zxHudkC_G9SzPPy1Mj4XYvQ-MY8nmx4wO+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMif301iBe9zxHudkC_G9SzPPy1Mj4XYvQ-MY8nmx4wO+A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 01:33:27PM -0700, Olof Johansson wrote:
> On Wed, Sep 25, 2013 at 1:05 PM, Brian Norris
> <computersforpeace@gmail.com> wrote:
> 
> > Olof has given good advice on your DT binding and has (slowly) been
> > responding to other requests for DT review that make it to his list. I
> > see that he hasn't followed up on your changes (this v6), so pinging him
> > (as you did) is probably the correct approach. But please do recognize
> > that the DT list is very high volume, so it's hard to get good timely
> > responses there.
> 
> I am not a DT mainainer, but sometimes when I see a binding that
> appears to be wrong I speak up. In this case, the binding was one of
> those.

Whoops, my bad. I was deceived by the responses I've seen from you on
other issues (thanks, BTW). In that case, I haven't seen any response
from a proper DT binding maintainer :(
 
> So, I have no more objections to it, and I hope you can get a quick
> review from a DT maintainer on the rest of the binding.

At this point, I'm comfortable going ahead without their ack, since they
obviously don't care/don't have the manpower to review.

Brian
