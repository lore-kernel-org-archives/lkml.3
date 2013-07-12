Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965072Ab3GLQf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 12:35:28 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:34109 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965004Ab3GLQf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 12:35:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130712161708.GA3759@gmail.com>
References: <20130711214830.611455274@linuxfoundation.org>
	<20130711222935.GA11340@redhat.com>
	<20130711224455.GA17222@kroah.com>
	<20130712141530.GA3629@roeck-us.net>
	<CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
	<1373644044.17876.92.camel@gandalf.local.home>
	<CA+55aFxUZCWT55EZ7fZw0j_UgaqjPA8Wiv47s5qO01NvHNzFCQ@mail.gmail.com>
	<20130712161708.GA3759@gmail.com>
Date: Fri, 12 Jul 2013 12:35:26 -0400
Message-ID: <CA+5PVA6k8xQR4uCpiCnYD3iz421XHGX9eV8vNDH3y1t092aAdw@mail.gmail.com>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Josh Boyer <jwboyer@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 12:17 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Fri, Jul 12, 2013 at 8:47 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> >
>> > I tend to hold things off after -rc4 because you scare me more than Greg
>> > does ;-)
>>
>> Have you guys *seen* Greg? The guy is a freakish giant. He *should*
>> scare you. He might squish you without ever even noticing.
>
> Greg might be a giant and he might squish people without ever even
> noticing, but that's just a grave, deadly physical threat no real kernel
> hacker ever feels threatened by. (Not much can hurt us deep in our dark
> basements after all, except maybe earthquakes, gamma ray eruptions and Mom
> trying to clean up around the computers.)
>
> So Greg, if you want it all to change, create some _real_ threat: be frank
> with contributors and sometimes swear a bit. That will cut your mailqueue
> in half, promise!

I don't think it's that simple.  The problem here isn't that Greg is
being too nice.  The problem is that people are holding back fixes
from Linus' tree.  Greg might be able to yell at maintainers more, but
if he does it's after the fact and it's sort of a too late situation.
Those fixes should probably get in the tree because they should
probably have been in the .0 release to begin with.  I don't envy Greg
here.

I know... let's push this off onto linux-next. It isn't like Stephen
has anything better to do anyway ;).

More seriously though, those -stable fixes queued up for months show
up there first.  Perhaps if we watch the trees feeding into linux-next
for a bit for fixes tagged with -stable in the middle -rc windows, we
can prod maintainers more.

josh
