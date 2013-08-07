Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab3HGFoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:44:03 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:62949 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab3HGFoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:44:00 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130807153840.4f2997b603397c07aca98b2d@canb.auug.org.au>
References: <20130729110816.12958c3a26400f444a9a5012@canb.auug.org.au>
	<CA+icZUUt4domktYZZn0Qp3BZoSFqmKic4qSnVP4cuTKwUww_=A@mail.gmail.com>
	<20130807153840.4f2997b603397c07aca98b2d@canb.auug.org.au>
Date: Wed, 7 Aug 2013 07:43:59 +0200
Message-ID: <CA+icZUX-gyFK4kNwnbqwOUzM9_T9hhj+AKufUfg8yJb4kQ-pfA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the ext4 tree
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 7:38 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Sedat,
>
> On Wed, 7 Aug 2013 07:16:57 +0200 Sedat Dilek
> <sedat.dilek@gmail.com> wrote:
>>
>> On Mon, Jul 29, 2013 at 3:08 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> >
>> > After merging the ext4 tree, today's linux-next build (powerpc
>> > ppc64_defconfig) failed like this:
>> >
>> > fs/ext4/ialloc.c: In function '__ext4_new_inode':
>> > fs/ext4/ialloc.c:817:1: warning: label 'next_ino' defined but not used [-Wunused-label]
>> >  next_ino:
>> >  ^
>> > fs/ext4/ialloc.c:792:4: error: label 'next_inode' used but not defined
>> >     goto next_inode;
>> >     ^
>> >
>> > Hmm ...
>> >
>> > Caused by commit 4a8603ef197a ("ext4: avoid reusing recently deleted
>> > inodes in no journal mode").
>> >
>> > I have used the ext4 tree from next-20130726 for today.
>>
>> Since this message ext4-tree was not updated.
>> The commit "ext4: avoid reusing recently deleted inodes in no journal
>> mode" was refreshed and has a different commit-id.
>> Did you test with this one? You still see the breakage?
>
> Today's linux-next does not have this build failure.

The refreshed patch is from 02-Aug-2013.
So why did next-20130805 and next-20130806 did not have it?
I was reading for these Linux-next releases the same: "I have used the
ext4 tree from next-20130726 for today.".
I am wondering what went wrong.

- Sedat -

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
