Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3ITApB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 20:45:01 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:55973 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab3ITAo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 20:44:59 -0400
MIME-Version: 1.0
In-Reply-To: <1379632757.12963.4.camel@shinybook.infradead.org>
References: <20130919194752.GA19975@quad.lixom.net>
	<1379626776.753.164.camel@shinybook.infradead.org>
	<CAN8TOE8j=oosn-5hAdqoTPcuW-sGvDAHd_nK6BZfJpxMwwpisQ@mail.gmail.com>
	<1379632757.12963.4.camel@shinybook.infradead.org>
Date: Thu, 19 Sep 2013 17:44:57 -0700
Message-ID: <CAN8TOE8Xf9fv9zyY6wof3b9QhqgV=s-cK4V4D6n+Gw4HgacT0g@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: SoC fixes for 3.12-rc
From: Brian Norris <computersforpeace@gmail.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: Olof Johansson <olof@lixom.net>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 4:19 PM, Woodhouse, David
<david.woodhouse@intel.com> wrote:
> On Thu, 2013-09-19 at 15:57 -0700, Brian Norris wrote:
>> On Thu, Sep 19, 2013 at 2:39 PM, Woodhouse, David
>> <david.woodhouse@intel.com> wrote:
>> > On Thu, 2013-09-19 at 12:47 -0700, Olof Johansson wrote:
>> >>
>> >> - A fix for build breakage in the MTD subsystem for some PXA devices.
>> >>   David Woodhouse has this patch in his for-next branch but has not been
>> >>   responding to our requests to send it up so here it is.
>> >>   I should have amended the commit message to describe the build failure for
>> >>   CONFIG_OF=n setups, but forgot and now it's down in the stack of commits.
>> >
>> > Thanks for pulling that in. Apologies for the screwup.
>>
>> Speaking of such process issues: there's an outstanding patch for a
>> (small) memory leak that was introduced in the nand_base.c ONFI code
>> in 3.12-rc1. Can I expect you to attend to these sort of -rcX (where X
>> > 1) issues? Or should I send Linus the patch myself? I don't really
>> want it to wait around until 3.13-rc1 to go to -stable.
>
> I'm aware of it, and will get to it shortly. Was going to round it up
> along with the one that Olof just sent, either some time this week at
> Plumbers or when I get home.
>
> If you want to stick it in the linux-mtd.git tree before that and send
> Linus a pull request, I have no objection.

If you're up to it, then you can take it. I'll take it myself if I
feel it's getting too late. The problem is just when I can't
differentiate your quiet awareness from oblivion (or obliviousness?).

> Does that m25p80 'fix 4 byte addressing' fix for Micron not also want to
> go in?

I suppose the m25p80 one can go in as well. It's not so much a bugfix
as augmenting my original patch to support more devices. But it is
safe enough.

Brian
