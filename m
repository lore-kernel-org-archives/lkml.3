Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab3AYDkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:40:37 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:60673 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3AYDke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:40:34 -0500
MIME-Version: 1.0
In-Reply-To: <20130124143007.39c8545f.akpm@linux-foundation.org>
References: <CALjC5hYxtPymauFddf4Qci3S-KsZHHck0LKQPZY5ocHcLw-XrQ@mail.gmail.com>
	<CALjC5hZwVwRdY6muizzK-+jrq0RH43H6f2kgXstZuco7oM7FyQ@mail.gmail.com>
	<CALjC5hbMq+bc-X8Ad+=gEZLuWy3ZXm4Z0Y2w44k5UZjL4g7vqg@mail.gmail.com>
	<20130124143007.39c8545f.akpm@linux-foundation.org>
Date: Thu, 24 Jan 2013 19:40:34 -0800
Message-ID: <CALjC5hZaVwJBuR17dcM7hG1EMEoAYoUt0S-x6avCxRBuF54RGg@mail.gmail.com>
Subject: Re: crash in ocfs2_fast_symlink_readpage in kernel 3.5.0
From: Bret Towe <magnade@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joel Becker <jlbec@evilplan.org>,
        Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 2:30 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat, 19 Jan 2013 20:15:33 -0800
> Bret Towe <magnade@gmail.com> wrote:
>
>> >
>> > it looks like you have a patch for this problem in a queue somewhere
>> > (email found on ocfs2-dev:
>> > https://oss.oracle.com/pipermail/ocfs2-devel/2012-August/008677.html )
>> > but its not in 3.6, any reason for the delay?
>> > I've been running that patch on 3.5 for a while now likely since
>> > around the time i found that email
>> > and its been working well
>>
>> doesn't look to be in 3.7 or 3.8-git
>> and from what i see on ocfs2-dev there are at least 16 other patches
>> that are also being ignored?
>> I'm sure if I'm bothering at this point to maintain my own patchset to
>> keep ocfs2 from crashing
>> that there is other folks doing the same
>
> Please resend all OCFS2 patches, cc'ing myself, Mark, Joel and
> ocfs2-devel@oss.oracle.com.
>
> I shall then review them, merge them into -mm (and hence linux-next) so
> they can get a bit of visibility and testing while the maintainers are
> checking them over.
>
> Thanks.

I've just been browsing the ocfs2-dev archives do you want me to pull them
and resend or should i just link to the archive?
keep in mind I'm just a end user not really a dev persay
if you do want me to send the patches however I assume there is a document
i should read first?
