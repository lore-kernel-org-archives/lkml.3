Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab3HUFfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 01:35:43 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56101 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab3HUFfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 01:35:41 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130821101403.1706678a4bbdebec4756ee54@canb.auug.org.au>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
	<20130820130056.GA9652@infradead.org>
	<5213BFCB.3010503@oracle.com>
	<20130821101403.1706678a4bbdebec4756ee54@canb.auug.org.au>
Date: Wed, 21 Aug 2013 07:35:39 +0200
Message-ID: <CA+icZUUsxSXcVN7omFHHkgdfNcw2xTH9npX_Z=YHCOB2z=BFJg@mail.gmail.com>
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 2:14 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Dave,
>
> On Tue, 20 Aug 2013 14:13:15 -0500 Dave Kleikamp <dave.kleikamp@oracle.com> wrote:
>>
>> Would you be willing to pick up
>> git://github.com/kleikamp/linux-shaggy.git for-next
>> into linux-next?
>
> I have added that from today.
>
>> There will be some unclean merges, and I can send you updated patches
>> created against your latest tree. I'm not exactly sure of your process
>> wrt cleaning up merges, but I guess they would help.
>
> Since I will merge your tree into linux-next, I only need to fix merge
> conflicts, so while those patches can be a guide, they are mostly not
> needed.
>
>> On 08/20/2013 08:00 AM, Christoph Hellwig wrote:
>> > As I've seen very few replies to this:  how do we ensure this gets
>> > picked up for the 3.12 merge window?  The series has been a reposted
>> > a few times without complaints or major changes, but the ball still
>> > doesn't seem to get rolling.
>> >
>> > I'd really like to do some ecryptfs and scsi target work that is going
>> > to rely on this soon.
>
> If this happens, then it is important that your (Dave's) tree is not
> rebased/rewritten and that any other tree that depend on it merges your
> tree.
>
> I will merge your tree relatively early, that way the merge conflicts will
> be spread over several other merges and hopefully each be fairly minor.
>
> I gave called your tree "aio-direct", please let me know fi you think
> there is a better name.
>

Cool, to see Dave's work in Linux-next!

Dave named his GIT branch "aio_loop".
( If you (Stephen) prefer "hyphen" for your GIT branches, use
"aio-loop", but that's up to the Dave. )

Anyway, I am glad to see this getting pushed.

( Hmmm, OverlayFS
..................................................................................................................).

- Sedat -

[1] https://github.com/kleikamp/linux-shaggy/tree/aio_loop

> Thanks for adding your subsystem tree as a participant of linux-next.  As
> you may know, this is not a judgment of your code.  The purpose of
> linux-next is for integration testing and to lower the impact of
> conflicts between subsystems in the next merge window.
>
> You will need to ensure that the patches/commits in your tree/series have
> been:
>      * submitted under GPL v2 (or later) and include the Contributor's
>         Signed-off-by,
>      * posted to the relevant mailing list,
>      * reviewed by you (or another maintainer of your subsystem tree),
>      * successfully unit tested, and
>      * destined for the current or next Linux merge window.
>
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).  It is allowed to be rebased if you deem it necessary.
>
> --
> Cheers,
> Stephen Rothwell
> sfr@canb.auug.org.au
>
> Legal Stuff:
> By participating in linux-next, your subsystem tree contributions are
> public and will be included in the linux-next trees.  You may be sent
> e-mail messages indicating errors or other issues when the
> patches/commits from your subsystem tree are merged and tested in
> linux-next.  These messages may also be cross-posted to the linux-next
> mailing list, the linux-kernel mailing list, etc.  The linux-next tree
> project and IBM (my employer) make no warranties regarding the linux-next
> project, the testing procedures, the results, the e-mails, etc.  If you
> don't agree to these ground rules, let me know and I'll remove your tree
> from participation in linux-next.
