Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaBRJu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 04:50:58 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:42596 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaBRJuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:50:55 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1402181001530.2216@localhost.localdomain>
References: <1391319874-3203-1-git-send-email-linkinjeon@gmail.com>
	<alpine.LFD.2.00.1402111209450.2225@localhost.localdomain>
	<CAKYAXd-bD6ZZgpc9E8V1kD9Dj2wrCkbi1i6drNBdUAwsMiv5gg@mail.gmail.com>
	<alpine.LFD.2.00.1402181001530.2216@localhost.localdomain>
Date: Tue, 18 Feb 2014 18:50:54 +0900
Message-ID: <CAKYAXd_xpWg-=T_1PghL_u9wDKTX_Ey5mJxbgVVKth8NoexQQg@mail.gmail.com>
Subject: Re: [PATCH RESEND 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE
 for fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Cc: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-18 18:05 GMT+09:00, Lukáš Czerner <lczerner@redhat.com>:
> On Wed, 12 Feb 2014, Namjae Jeon wrote:
>
>> Date: Wed, 12 Feb 2014 11:28:35 +0900
>> From: Namjae Jeon <linkinjeon@gmail.com>
>> To: Lukáš Czerner <lczerner@redhat.com>
>> Cc: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com,
>> tytso@mit.edu,
>>     adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
>>     linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
>>     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
>>     Namjae Jeon <namjae.jeon@samsung.com>,
>>     Ashish Sangwan <a.sangwan@samsung.com>
>> Subject: Re: [PATCH RESEND 3/10] ext4: Add support
>> FALLOC_FL_COLLAPSE_RANGE
>>     for fallocate
>>
>> 2014-02-11 20:59 GMT+09:00, Lukáš Czerner <lczerner@redhat.com>:
>> > On Sun, 2 Feb 2014, Namjae Jeon wrote:
>> >
>> >> Date: Sun,  2 Feb 2014 14:44:34 +0900
>> >> From: Namjae Jeon <linkinjeon@gmail.com>
>> >> To: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com,
>> >> tytso@mit.edu,
>> >>     adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com
>> >> Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
>> >>     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
>> >>     Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon
>> >> <namjae.jeon@samsung.com>,
>> >>     Ashish Sangwan <a.sangwan@samsung.com>
>> >> Subject: [PATCH RESEND 3/10] ext4: Add support
>> >> FALLOC_FL_COLLAPSE_RANGE
>> >> for
>> >>     fallocate
>> >>
>> >> From: Namjae Jeon <namjae.jeon@samsung.com>
>> >>
>> >> Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
>> Hi Lukas.
>> >
>> > Description is missing here, please provide FALLOC_FL_COLLAPSE_RANGE
>> > description so people know what it's supposed to be doing.
>> >
>> > more comments bellow.
>> Okay, I will udpate.
>> >
>> > Thanks!
>> > -Lukas
>
> Hi,
Hi Lukas.
>
> you may have noticed my patches for new FALLOC_FL_ZERO_RANGE
> fallocate flag. This changes things around the same area as your
> patches does so we should probably figure out which are going to
> land in first and then rebase the other on top of that.
Yes, I have seen your patches. I think that VFS + XFS patches for
FALLOC_FL_COLLAPSE_RANGE have got a fair amount of review from Dave.
So they are almost ready. I will post collapse range v5 patches after
fixing some minor comments tonight or tommorow.
If there will be no more comments for XFS patch, VFS + XFS patches can
go through to xfs tree by Dave.
I think that Ext4 collapse range could go at a later time.(Need your
reviewed-by tag)
If still there are comments for xfs patch, I will rebase on top of your patch.
>
> One concern I have is that I have not seen any tests provided to
> verify the feature. But I just may have missed it. Do you have any
> xfstests test or at least fsx and fsstress patches to provide
> support for testing FALLOC_FL_COLLAPSE_RANGE ? Patches for
> util_linux might also be handy.
Yes, There are 5 new xfstests cases in this patch-set. these will also
be posted with collapse range patch-set soon.

Thanks :)
>
> Thanks!
> -Lukas
