Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab3BAImg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:42:36 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:63152 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3BAImc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:42:32 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CA+icZUW5tBotrZT9QtNPao-3rEccohBW8a4diS2nJ+ONgTWLaQ@mail.gmail.com>
References: <CA+icZUW5tBotrZT9QtNPao-3rEccohBW8a4diS2nJ+ONgTWLaQ@mail.gmail.com>
Date: Fri, 1 Feb 2013 09:42:30 +0100
Message-ID: <CAKMK7uEFCm5JPD9bg4uO9K_q-w0=9GWzRLoB9H-_=ZR7NxA9=A@mail.gmail.com>
Subject: Re: Revert "console: implement lockdep support for console_lock"
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: sedat.dilek@gmail.com
Cc: Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 9:21 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> people having the fbcon-locking-fixes [1] in their local GIT tree can
> revert this change?

Yeah, if you have all the fixes reverting this is fine and appreciated
to increase testing. Dave will probably push the revert himself to
drm-next soon.
-Daniel

>
> commit ff0d05bf73620eb7dc8aee7423e992ef87870bdf
> Refs: v3.8-rc5-194-gff0d05b
> Author:     Dave Airlie <airlied@gmail.com>
> AuthorDate: Thu Jan 31 14:27:03 2013 +1100
> Commit:     Dave Airlie <airlied@gmail.com>
> CommitDate: Thu Jan 31 15:46:56 2013 +1100
>
>     Revert "console: implement lockdep support for console_lock"
>
>     This reverts commit daee779718a319ff9f83e1ba3339334ac650bb22.
>
>     I'll requeue this after the console locking fixes, so lockdep
>     is useful again for people until fbcon is fixed.
>
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> Thanks!
>
> Regards,
> - Sedat
>
> [1] http://cgit.freedesktop.org/~airlied/linux/log/?h=fbcon-locking-fixes



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
