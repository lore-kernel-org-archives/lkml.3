Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3CLJ3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 05:29:52 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64104 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab3CLJ3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 05:29:50 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130312041641.GE18595@thunk.org>
References: <20130312100950.e45ef0e721492ff0d5fd7c8d@canb.auug.org.au>
	<alpine.LRH.2.02.1303121510270.25612@tundra.namei.org>
	<20130312041641.GE18595@thunk.org>
Date: Tue, 12 Mar 2013 10:29:46 +0100
Message-ID: <CA+icZUUQMa3avo8HbqyZAjJF0xDTmSE4GXtw2YmypzauunW54g@mail.gmail.com>
Subject: Re: linux-next: unneeded merge in the security tree
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, James Morris <jmorris@namei.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 5:16 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Mar 12, 2013 at 03:10:53PM +1100, James Morris wrote:
>> On Tue, 12 Mar 2013, Stephen Rothwell wrote:
>> > The top commit in the security tree today is a merge of v3.9-rc2.  This
>> > is a completely unnecessary merge as the tree before the merge was a
>> > subset of v3.9-rc1 and so if the merge had been done using anything but
>> > the tag, it would have just been a fast forward.  I know that this is now
>> > deliberate behaviour on git's behalf, but isn't there some way we can
>> > make this easier on maintainers who are just really just trying to pick a
>> > new starting point for their trees after a release?  (at least I assume
>> > that is what James was trying to do)
>>
>> Yes, and I was merging to a tag as required by Linus.
>
> Why not just force the head of the security tree to be v3.9-rc2?  Then
> you don't end up creating a completely unnecessary merge commit, and
> users who were at the previous head of the security tree will
> experience a fast forward when they pull your new head.
>

If maintainers of their for-next trees switch to latest -rcX
(Linus-tree) as base, life would get a lot of easier.

That's what I am doing here before any build:
Take the latest available -rcX of Linus-tree and then pull in
Linux-Next GIT into it.
( Even if Stephen's "origin" GIT branch (Linus-tree) is post-rcX. )

That strategy makes merging a bit easier (for me).

- Sedat -

>                                                   - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
