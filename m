Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030487Ab3HIH2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 03:28:46 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42517 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030396Ab3HIH2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 03:28:45 -0400
MIME-Version: 1.0
In-Reply-To: <1376032991.2219.122.camel@sauron.fi.intel.com>
References: <1368760654-28754-1-git-send-email-b32955@freescale.com>
	<CAN8TOE-QvScbPUEPyrs-fYVQZmPu1h-wWX2hjz46KYtaWRckBw@mail.gmail.com>
	<520357DF.3030403@freescale.com>
	<20130808230630.GA14434@norris.computersforpeace.net>
	<1376020723.2219.105.camel@sauron.fi.intel.com>
	<52048565.1030707@gmail.com>
	<1376032991.2219.122.camel@sauron.fi.intel.com>
Date: Fri, 9 Aug 2013 00:28:44 -0700
Message-ID: <CAN8TOE_GzzXcsifQOiD1WbgXKJmXkJjBbUfgv88Oit95oaY18g@mail.gmail.com>
Subject: Re: [PATCH v6 00/10] mtd: add datasheet's ECC information to nand_chip{}
From: Brian Norris <computersforpeace@gmail.com>
To: dedekind1@gmail.com
Cc: Huang Shijie <b32955@freescale.com>, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        vikram186@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 9, 2013 at 12:23 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Thu, 2013-08-08 at 23:00 -0700, Brian Norris wrote:
>> On 08/08/2013 08:58 PM, Artem Bityutskiy wrote:
>> > There are few minor issues in aiaiai, which I can fix if you hit them
>> > and complain. Also, I did not invest much time in making the user
>> > interface and experience very nice. But this can also be improved.
>>
>> One issue (possibly related to the above question?) was that aiaia
>> complained (via checkpatch.pl) about no sign-offs when I processed using
>> the input redirection method on a multi-message mbox.
>
> Yes, aiaiai runs checkpatch.pl for individual patches, and then to a
> concatenated patch, and the latter does not have a signed-off-by. Fixing
> is about adding --no-signoff to the right place.

I can look at that if I run into it again and have the time to fix it.

> I am a bit worried that at some point we may screw each other's work by
> pushing things out at the same time. We should be very careful with
> --force.

I think by limiting our use of rebase and exercising care with
--force, we should be fine. And if we do a 'fetch' just before, then
the probability of a collision should be pretty low. Famous last
words.

Brian
