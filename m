Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab3GPD1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 23:27:46 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:49416 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3GPD1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 23:27:44 -0400
MIME-Version: 1.0
In-Reply-To: <1373942486.31067.122.camel@deadeye.wl.decadent.org.uk>
References: <1373916476.2748.69.camel@dabdike>
	<20130715214422.GA2478@kroah.com>
	<1373925699.17876.218.camel@gandalf.local.home>
	<20130716000623.GB26261@kroah.com>
	<1373940594.17876.241.camel@gandalf.local.home>
	<1373942486.31067.122.camel@deadeye.wl.decadent.org.uk>
Date: Tue, 16 Jul 2013 13:27:42 +1000
Message-ID: <CAPM=9twPxz60WObwG5SuCxFrGTr7KzQyS3iqGnF8MQJPUZuHOg@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Dave Airlie <airlied@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>, Greg KH <greg@kroah.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 12:41 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Mon, 2013-07-15 at 22:09 -0400, Steven Rostedt wrote:
> [...]
>> > > How important is the stable releases? Are maintainers willing to do a
>> > > little more work now to make sure their subsystems work fine in older
>> > > kernels? This isn't the same stable as it was 8 years ago.
>> >
>> > And that annoys the hell out of some Linux companies who feel that the
>> > stable kernels compete with them.  So people working for those companies
>> > might not get as much help with doing any additional work for stable
>> > kernel releases (this is not just idle gossip, I've heard it directly
>> > from management's mouths.)
>>
>> Hmm, this is new to me. Really, I thought the whole point of the stable
>> releases was to help Linux companies.
> [...]
>
> I also heard some managers decided their kernel source packages should
> have all the patches squashed together to make them harder to cherry-
> pick... could it have been the same company?

Greg loves to tell stories about RH management, but really if he can
find any engineer who works for RH that says he can't work on stable
due to being told by management, I'd be surprised. Maybe when stable
first surfaced there was a hope of it being close to RHEL, but at this
point stable has little to no usefulness from a RHEL point of view,
and since nearly all the RH employed maintainers all do stable work, I
can't see why Greg would think this matters.

In fact Greg how much of stable queue does come from Red Hatters?

Dave.
