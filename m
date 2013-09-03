Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187Ab3ICA0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 20:26:24 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33219 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab3ICA0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 20:26:22 -0400
MIME-Version: 1.0
In-Reply-To: <1378156296.1953.117.camel@joe-AO722>
References: <20130902195056.GB32628@leaf>
	<9976.1378132260@warthog.procyon.org.uk>
	<1378138205.1953.66.camel@joe-AO722>
	<20130902181510.GA29787@leaf>
	<20130902181856.GB29787@leaf>
	<20130902153945.6d7e510c@samsung.com>
	<1378148367.1953.98.camel@joe-AO722>
	<13834.1378155023@warthog.procyon.org.uk>
	<1378156296.1953.117.camel@joe-AO722>
Date: Tue, 3 Sep 2013 08:26:21 +0800
Message-ID: <CAP9B-Q=xO8Rw_wD-tER2U1g4fKfiy01eT7rMAV6V_gCCNpy09Q@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
From: Shilong Wang <wangshilong1991@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: David Howells <dhowells@redhat.com>, Josh Triplett <josh@joshtriplett.org>,
        Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/9/3 Joe Perches <joe@perches.com>:
> On Mon, 2013-09-02 at 21:50 +0100, David Howells wrote:
>> Josh Triplett <josh@joshtriplett.org> wrote:
>>
>> > > There are many checkpatch rules (like semicolons) that
>> > > are not in CodingStyle.
>> >
>> > It's a rule of thumb, not a mandate.  In *general*, checkpatch.pl should
>> > not be enforcing style rules that aren't documented in CodingStyle.
>>
>> Except that it becomes a mandate when someone runs it automatically against
>> every one of your patches and then sends you an email for each patch it finds
>> a checkpatch niggle against...

Agree with this..
But using checkpatch.pl, i found there are *so many* patches that have
warnings or errors.

As far as i know, patches with checkpatch.pl's errors should be
avoided  at least unless
there is a *bug* in checkpatch.pl!

>
> I think that any robot sending such checkpatch-only
> emails should be disabled.
>
> I know of 2 email robots.
>
> Fengguang Wu's very useful build robot
> sends out emails on build failures.
> I think that's great.
>
> Wang Shilong <wangshilong1991@gmail.com>
> sent me an automated checkpatch email I
> thought was not useful.

I am sorry if i give you any trouble, i have disabled it(in fact, it
only has run for a day!)

Thanks,
wang
>
> Does anyone know of other checkpatch robots?
>
>
