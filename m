Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaJ1Rgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:36:38 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:49070 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJ1Rgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:36:37 -0400
MIME-Version: 1.0
In-Reply-To: <20141028133253.223e47f7@gandalf.local.home>
References: <20140929124246.3e39dac8@gandalf.local.home>
	<cover.1412031505.git.joe@perches.com>
	<c1a1138f1b05e87a3fbd8737af2f2c0be6e2724b.1412031505.git.joe@perches.com>
	<20141022082916.GD16128@brian-ubuntu>
	<20141028111301.22481f2a@gandalf.local.home>
	<1414511877.6643.12.camel@perches.com>
	<20141028120552.63c2324c@gandalf.local.home>
	<1414517260.6643.21.camel@perches.com>
	<20141028133253.223e47f7@gandalf.local.home>
Date: Tue, 28 Oct 2014 10:36:36 -0700
Message-ID: <CAN8TOE-q7pDsT2+DxCQowtY2_ExekAzBjjkA5S5EA_9gjoqaOg@mail.gmail.com>
Subject: Re: [PATCH 7/7] docg3: Fix miuse of seq_printf return value
From: Brian Norris <computersforpeace@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Joe Perches <joe@perches.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 10:32 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 28 Oct 2014 10:27:40 -0700
> Joe Perches <joe@perches.com> wrote:
>> On Tue, 2014-10-28 at 12:05 -0400, Steven Rostedt wrote:
>> > On Tue, 28 Oct 2014 08:57:57 -0700
>> > Joe Perches <joe@perches.com> wrote:
>> >
>> > > On Tue, 2014-10-28 at 11:13 -0400, Steven Rostedt wrote:
>> > > > I'm going to be working on changes to remove the return value of
>> > > > seq_printf() and friends.
>> > >
>> > > I'm sure you know all of this, but for anyone else:
>> > >
>> > > This doesn't need to be done in a single pass.
>> >
>> > Yeah, I took a look at all the places, and I've decided to take it off
>> > in chunks. I'm starting with the ones you posted, and will try to get
>> > acks for them. And then go after other chunks as I have time.
>> >
>> > I would like to get this done before I do my merge of trace_seq and
>> > seq_file, but I'm thinking I may have to do that in parallel.
>>
>> I think the most important thing is to get the
>> seq_is_overflown (or seq_has_overflowed or whatever
>> other name is chosen) function added then the rest
>> of the patches can be applied whenever maintainers
>> (or Andrew or trivial or ...) pick them up.
>
> I can get that in without much of an issue. But the merge of trace_seq
> and seq_file would be easier if I didn't have to worry about return
> values. Which is why I want to get this in quickly.

Whatever you'd like. Please, have my ack and keep the patch in your own branch!

Acked-by: Brian Norris <computersforpeace@gmail.com>

It's no problem if we both have the patch, is it? Or if I see it in
linux-next, then I may drop it from my tree.

Regards,
Brian
