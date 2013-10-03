Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab3JCFC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 01:02:57 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:52113 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab3JCFCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 01:02:55 -0400
MIME-Version: 1.0
In-Reply-To: <1379632757.12963.4.camel@shinybook.infradead.org>
References: <20130919194752.GA19975@quad.lixom.net>
	<1379626776.753.164.camel@shinybook.infradead.org>
	<CAN8TOE8j=oosn-5hAdqoTPcuW-sGvDAHd_nK6BZfJpxMwwpisQ@mail.gmail.com>
	<1379632757.12963.4.camel@shinybook.infradead.org>
Date: Wed, 2 Oct 2013 22:02:54 -0700
Message-ID: <CAN8TOE-AozeOs3N0q4x-cMbvRnSTcJYCRx83K-56UJth_WGp3A@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: SoC fixes for 3.12-rc
From: Brian Norris <computersforpeace@gmail.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Trimming CC list)

Hi David,

On Thu, Sep 19, 2013 at 4:19 PM, Woodhouse, David
<david.woodhouse@intel.com> wrote:
> On Thu, 2013-09-19 at 15:57 -0700, Brian Norris wrote:
>> Speaking of such process issues: there's an outstanding patch for a
>> (small) memory leak that was introduced in the nand_base.c ONFI code
>> in 3.12-rc1. Can I expect you to attend to these sort of -rcX (where X
>> > 1) issues? Or should I send Linus the patch myself? I don't really
>> want it to wait around until 3.13-rc1 to go to -stable.
>
> I'm aware of it, and will get to it shortly. Was going to round it up
> along with the one that Olof just sent, either some time this week at
> Plumbers or when I get home.

I see that you have queued up some 3.12-rc patches in linux-mtd.git.
This is a reminder to send a pull request...

> If you want to stick it in the linux-mtd.git tree before that and send
> Linus a pull request, I have no objection.

...or else I will just send them myself within a week.

Thanks,
Brian
