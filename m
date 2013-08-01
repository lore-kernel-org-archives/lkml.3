Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab3HAGbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 02:31:43 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:33583 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3HAGbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 02:31:41 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130801061928.GR7118@dastard>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
	<CA+icZUX7aFAPBo_nhBLQ7-F465_Bujg5Cr5+xL+hfcwn6BMo=Q@mail.gmail.com>
	<20130801061928.GR7118@dastard>
Date: Thu, 1 Aug 2013 08:31:39 +0200
Message-ID: <CA+icZUXEFMdRGUXHXu12JYVK7Qsumb2UH6GmrAL6zuQmabheaw@mail.gmail.com>
Subject: Re: [PATCH 00/11] Sync and VFS scalability improvements
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davej@redhat.com, viro@zeniv.linux.org.uk,
        jack@suse.cz, glommer@parallels.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 8:19 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Jul 31, 2013 at 08:48:40AM +0200, Sedat Dilek wrote:
>> On Wed, Jul 31, 2013 at 6:15 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > Hi folks,
>> >
>> > This series of patches is against the curent mmotm tree here:
>> >
>> > http://git.cmpxchg.org/cgit/linux-mmotm.git/
>> >
>>
>> "Current" is not precise enough... above tree has git-tags.
>
> It's most certainly precise.  "current" always means the master
> branch at the time the series was posted. I.e. same definition as
> "top of tree"....
>

Today, I see in my inbox "mmotm 2013-07-31-16-52 uploaded" which means
"master" will change (or has changed).
Think of all the people being on vacation and reading your email later.
People waste their time if they don't know on what a patchset is based on.

Pointing to the git-tag does not hurt.

>> As I am not a linux-fs expert I can try to test, preferably against a
>> Linux-next release.
>> Would you like to test against "vanilla" mmotm or is Linux-next
>> suitable in your eyes?
>
> mmotm is based on the linux-next tree at the time the tree was made.
>

No, linux-next includes patches from Andrew's mmotm marked in his series file.
So, your patches can fit or not, that's why I asked.

[1] http://ozlabs.org/~akpm/mmotm/series
[2] http://ozlabs.org/~akpm/mmotm/mmotm-readme.txt

>> I have seen some typos... are you interested in such feedback?
>
> feel free to point them out.
>

Cannot promise anything. Dealing with some embedded stuff.

- Sedat -

> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
