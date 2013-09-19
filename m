Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab3ISW5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 18:57:44 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:37281 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab3ISW5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 18:57:41 -0400
MIME-Version: 1.0
In-Reply-To: <1379626776.753.164.camel@shinybook.infradead.org>
References: <20130919194752.GA19975@quad.lixom.net>
	<1379626776.753.164.camel@shinybook.infradead.org>
Date: Thu, 19 Sep 2013 15:57:40 -0700
Message-ID: <CAN8TOE8j=oosn-5hAdqoTPcuW-sGvDAHd_nK6BZfJpxMwwpisQ@mail.gmail.com>
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

On Thu, Sep 19, 2013 at 2:39 PM, Woodhouse, David
<david.woodhouse@intel.com> wrote:
> On Thu, 2013-09-19 at 12:47 -0700, Olof Johansson wrote:
>>
>> - A fix for build breakage in the MTD subsystem for some PXA devices.
>>   David Woodhouse has this patch in his for-next branch but has not been
>>   responding to our requests to send it up so here it is.
>>   I should have amended the commit message to describe the build failure for
>>   CONFIG_OF=n setups, but forgot and now it's down in the stack of commits.
>
> Thanks for pulling that in. Apologies for the screwup.

Speaking of such process issues: there's an outstanding patch for a
(small) memory leak that was introduced in the nand_base.c ONFI code
in 3.12-rc1. Can I expect you to attend to these sort of -rcX (where X
> 1) issues? Or should I send Linus the patch myself? I don't really
want it to wait around until 3.13-rc1 to go to -stable.

It's in l2-mtd.git (will need cherry-picked out of there) and ready
for the next linux-next:

commit b2bdf43fcc1d440d8f4e1d5c8c59bf2ca76204df
Author: Brian Norris <computersforpeace@gmail.com>
Date:   Mon Sep 16 17:59:20 2013 -0700

    mtd: nand: fix memory leak in ONFI extended parameter page

Brian
