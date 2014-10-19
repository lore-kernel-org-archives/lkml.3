Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaJSUsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 16:48:16 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:46120 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaJSUsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 16:48:12 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20141019152801.GC5189@saruman>
References: <20141009210715.GH25729@saruman>
	<20141010135743.GB31348@saruman>
	<20141010162531.GL12379@n2100.arm.linux.org.uk>
	<54388B81.5020306@mentor.com>
	<063D6719AE5E284EB5DD2968C1650D6D174C996E@AcuExch.aculab.com>
	<20141013114307.GO12379@n2100.arm.linux.org.uk>
	<20141014020640.GB25433@kroah.com>
	<20141015212310.GP12379@n2100.arm.linux.org.uk>
	<20141015212513.GA3247@n2100.arm.linux.org.uk>
	<20141019095416.GT12379@n2100.arm.linux.org.uk>
	<20141019152801.GC5189@saruman>
Date: Sun, 19 Oct 2014 13:48:12 -0700
Message-ID: <CAOesGMhokPjb8eU67t9NFOqPU=dBTuFBJ=aC+99i2UvdX_D8Hw@mail.gmail.com>
Subject: Re: RCU bug with v3.17-rc3 ?
From: Olof Johansson <olof@lixom.net>
To: Felipe Balbi <balbi@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <greg@kroah.com>, Rik van Riel <riel@redhat.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        Rabin Vincent <rabin@rab.in>, David Laight <David.Laight@aculab.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 8:28 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Sun, Oct 19, 2014 at 10:54:16AM +0100, Russell King - ARM Linux wrote:
>> On Wed, Oct 15, 2014 at 10:25:13PM +0100, Russell King - ARM Linux wrote:
>> > On Wed, Oct 15, 2014 at 10:23:10PM +0100, Russell King - ARM Linux wrote:
>> > > As I said, I have a patch in progress, but it seems that there needed
>> > > to be some discussion about exactly which compiler versions are affected.
>> > > It seems that it's not as trivial as looking at the GCC bug entry.
>> >
>> > ... and in any case, it has been a known bug for well over a year now,
>> > and it seems that it doesn't affect _that_ many people.  So taking some
>> > extra time to get it properly correct is the _right_ thing to do.
>>
>> Well, this is just great.  Pushing out the change which blacklists these
>> compilers takes out Olof's kernel build system...
>>
>> Things are not as trivial as they seem.
>
> Maybe Olof just needs to update his compiler. Olof ?

Yep, doing a run with 4.9.1 to see how it looks. In the past, 4.9 has
been really noisy with warnings, maybe most of them have been fixed by
now.


-Olof
