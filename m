Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab3BEKr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:47:28 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:46599 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3BEKr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:47:26 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAKMK7uEFCm5JPD9bg4uO9K_q-w0=9GWzRLoB9H-_=ZR7NxA9=A@mail.gmail.com>
References: <CA+icZUW5tBotrZT9QtNPao-3rEccohBW8a4diS2nJ+ONgTWLaQ@mail.gmail.com>
	<CAKMK7uEFCm5JPD9bg4uO9K_q-w0=9GWzRLoB9H-_=ZR7NxA9=A@mail.gmail.com>
Date: Tue, 5 Feb 2013 11:47:25 +0100
Message-ID: <CA+icZUU4JMfws_jFpoCaXnSNJeigONSEik_oGSa_ZQ=uJ_GJOA@mail.gmail.com>
Subject: Re: Revert "console: implement lockdep support for console_lock"
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 9:42 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Fri, Feb 1, 2013 at 9:21 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> people having the fbcon-locking-fixes [1] in their local GIT tree can
>> revert this change?
>
> Yeah, if you have all the fixes reverting this is fine and appreciated
> to increase testing. Dave will probably push the revert himself to
> drm-next soon.

When will that happen: drm-next inclusion?

Just FYI:
Pulling fbcon-locking-fixes into Linux-Next (next-20130205) shows some
ugly UTF-8 mismatch, means "fb: rework locking to fix lock ordering on
takeover" is not the same patch as in -next.
Just wanna let you know.

It would be good to inform Andrew and Stephen when this happened, so
Andrew can drop the two fb-fixes from his mmotm-tree.

Thanks!

- Sedat -

> -Daniel
>
>>
>> commit ff0d05bf73620eb7dc8aee7423e992ef87870bdf
>> Refs: v3.8-rc5-194-gff0d05b
>> Author:     Dave Airlie <airlied@gmail.com>
>> AuthorDate: Thu Jan 31 14:27:03 2013 +1100
>> Commit:     Dave Airlie <airlied@gmail.com>
>> CommitDate: Thu Jan 31 15:46:56 2013 +1100
>>
>>     Revert "console: implement lockdep support for console_lock"
>>
>>     This reverts commit daee779718a319ff9f83e1ba3339334ac650bb22.
>>
>>     I'll requeue this after the console locking fixes, so lockdep
>>     is useful again for people until fbcon is fixed.
>>
>>     Signed-off-by: Dave Airlie <airlied@redhat.com>
>>
>> Thanks!
>>
>> Regards,
>> - Sedat
>>
>> [1] http://cgit.freedesktop.org/~airlied/linux/log/?h=fbcon-locking-fixes
>
>
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
