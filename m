Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaGGRf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:35:28 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:41374 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaGGRfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:35:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140707134637.GA31174@thunk.org>
References: <CAPDOMVieG951+0chzvjmKTdpZf-fEB5mjUL9YK-rgqF3+O537w@mail.gmail.com>
	<20140707134637.GA31174@thunk.org>
Date: Mon, 7 Jul 2014 13:35:24 -0400
Message-ID: <CAPDOMVjEmVJJEd_LVpCkXC8qR7APTKeHNJQSQ5SFNuWj9BQuLA@mail.gmail.com>
Subject: Re: Arm Compiler - Part 1 of Compiling Tests
From: Nick Krause <xerofoify@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's fine I don't mind cleaning up the warning  or not using Bugzilla.
On the other hand there seems to be too many FIXMEs in the main
kernel for one person to fix. In addition all the arm configs that were
failing for linux next to compile that didn't succeed are succeeded as
of now. That seems useful to tell the arm developers.
Cheers Nick


On Mon, Jul 7, 2014 at 9:46 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Jul 07, 2014 at 01:22:13AM -0400, Nick Krause wrote:
>> Here are my logs of the builds attached  with warnings if they succeed
>> for now failing arm configs
>> according to the tests here,
>
> fs/direct-io.c: In function ‘__blockdev_direct_IO’:
> fs/direct-io.c:1011:12: warning: ‘to’ may be used uninitialized in this
> function [-Wmaybe-uninitialized]
>     u = (to - from) >> blkbits;
>
> OK, do you see why this is a false positive?  And why asking the
> thousands of people "in the commmunity" to all do exactly the same
> evaluation is a massive waste of time?
>
> And why people, after doing a quick evaluation to determine that the
> very first warning you sent out (which was repeated multiple times in
> your log; you didn't even bother to winnow out duplicate warnings)
> is a false positive, might be inclined to ignore all e-mails from
> you "asking for help" in the future?
>
> Look, it's good that you're being enthusiastic.  But you need to do
> more than just send screen shots of a kernel bugzilla where it's
> already been explained to you that darned few people care about the
> open/closed statistics, or running builds to complain about warnings.
>
> If you want to send a patch to clean up the warning, figure out how to
> do that, and then to send the to the right people.  (Hint: reading the
> Documentation/SubmittingPatches and Documentation/Submitchecklist
> files.)
>
> Regards,
>
>                                                 - Ted
