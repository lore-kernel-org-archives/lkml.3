Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbaBMK4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:56:25 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:59248 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaBMK4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:56:21 -0500
MIME-Version: 1.0
In-Reply-To: <52FCA253.3030703@msgid.tls.msk.ru>
References: <20140212092935.GA14964@osiris>
	<52FCA253.3030703@msgid.tls.msk.ru>
Date: Thu, 13 Feb 2014 11:56:20 +0100
Message-ID: <CAFLxGvxvDLqFhDyKA8pkAQa+xHa9SqP7PMvvTSiG1BZGpfqS9A@mail.gmail.com>
Subject: Re: [ANNOUNCE] s390 31 bit kernel support removal
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-390@vm.marist.edu,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 11:45 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
> 12.02.2014 13:29, Heiko Carstens wrote:
>> We want to remove s390 31 bit kernel support with Linux kernel 3.16.
>
> Maybe you can send a patch for Documentation/feature-removal-schedule.txt
> about this now?

This file is gone.

commit 9c0ece069b32e8e122aea71aa47181c10eb85ba7
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Oct 1 15:21:43 2012 -0700

    Get rid of Documentation/feature-removal.txt

    This file has turned out to be a pure write-only file that causes merge
    conflicts and has no actual redeeming features.

    There is never any reason to add stuff to this idiotic file.  Either
    something isn't getting used, and you should just remove it, or there is
    no excuse for removing it in the first place.  Just stop the idiocy.

    It has also been the excuse for just plain bad behavior ("Hey, I don't
    like xyz, so let's mark it for removal" followed by "Hey, look, it been
    in feature-removal.txt for six months now, so we should remove it").

    The recent bogus setitimer() ABI change request was just the most recent
    example of pointless and incorrect mental masturbation involving this
    file, and I'm tired of the silly and pointless conflicts in the file.

    This removal was discussed during the recent kernel summit, and while
    Steven Rostedt suggested we should just enter the file itself in the
    feature-removal schedule (to see if anybody who edits the file actually
    looks at it), that's cute but non-productive.

    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

-- 
Thanks,
//richard
