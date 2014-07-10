Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaGJNjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:39:48 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:46907 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbaGJNjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:39:46 -0400
Message-ID: <1404999558.16296.31.camel@iivanov-dev>
Subject: Re: [PATCH 0/4] New Qualcomm PMIC pin controller drivers
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Date: Thu, 10 Jul 2014 16:39:18 +0300
In-Reply-To: <CAJAp7Og0Cr3oY=XpT4NzKUWykxkRTq1ZRDyamW6tgohfBs3dmg@mail.gmail.com>
References: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
	 <CACRpkdYcoA-nifxojO5tZUy6dL6P2PTSGW0mVLUfqG20rOg-Nw@mail.gmail.com>
	 <1404904380.16296.17.camel@iivanov-dev>
	 <CACRpkdb25foEcNroqLyZbX93FxqAZ7=2pGo6GPWP8YdrjUS8gg@mail.gmail.com>
	 <CAJAp7Og0Cr3oY=XpT4NzKUWykxkRTq1ZRDyamW6tgohfBs3dmg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-09 at 07:02 -0700, Bjorn Andersson wrote:
> On Wed, Jul 9, 2014 at 4:43 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Wed, Jul 9, 2014 at 1:13 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> >> On Wed, 2014-07-09 at 11:43 +0200, Linus Walleij wrote:
> >>> On Mon, Jul 7, 2014 at 5:11 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:

<snip>

> However, the device tree bindings are a different thing; as the
> properties used to describe the hardware doesn't relate to how we
> communicate with it I think we should be able to (and therefor should)
> use the same documentation for the two (rather 7) chips.

Agreed.

> 
> >> Not sure. Björn patches cover older PMIC chips, if not mistaken, mine
> >> cover PMIC's used with APQ8074 and onward [1]. Main difference is
> >> the bus which connects them to SoC, interrupts handling, runtime
> >> pin type detection and register map.
> >
> 
> Correct Ivan; we do however share the same issues related to how to do
> interrupt handling, 

Yep, but do we actually need to do interrupt handling in driver?
Interrupts are handled by parent device. GPIO client drivers could 
use interrupt-controller registered by core driver?

> units for properties and how to split/reuse
> between gpio and mpp. Also we have solved the pins vs groups vs
> functions slightly different, that should all be aligned I think.

Sure.

<snip>

> > Then I guess even if the chips are totally unrelated it'd be interesting
> > to have you two guys cross-review each other's drivers so the behaviour
> > is consistent across qualcomm platforms.
> >
> 
> I hope we can meet somewhere in between

Sure.

Regards,
Ivan

