Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbaGULd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:33:58 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:44536 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbaGULd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:33:57 -0400
MIME-Version: 1.0
In-Reply-To: <1405877791.5135.36.camel@joe-AO725>
References: <1619290298.804838.1405876434000.open-xchange@webmail.nmp.skynet.be>
	<1405877791.5135.36.camel@joe-AO725>
Date: Mon, 21 Jul 2014 13:33:56 +0200
Message-ID: <CAFLxGvwGLjxPRV7XcJvREOkAcRT3ad2tG7kjzeo4yJKk5mJQHA@mail.gmail.com>
Subject: Re: Patch priority in subjects ?
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 7:36 PM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2014-07-20 at 19:13 +0200, Fabian Frederick wrote:
>> I was reading all those "friendly" messages around checkpatch -f lately
>> and the fact that code clean-up is too noisy (?)
>>
>> I guess I'm not the first to think about it but why don't we use something
>> like a priority field in patch subject ?

Code clean up is not bad per se.
Actually cleaning up things is very much welcome.

The thing is that pure white space or search&replace patches
produced by checkpatch.pl are often not helpful at all.
They pollute the git history, introduce merge conflicts, add
maintenance overhead, etc..

As somebody who regularly stares at code to find outhow the heck
some line of code got introduced these patches become a major PITA.
Running commands like are needed far too often:
git blame <sha1-of-stupid-cleanup>~1 foo/bar.c

Btw: Don't even try to tell me about the -w switch...

>> Of course it would be arbitrary but maybe better than nothing ?
>>
>> eg
>>
>> [PATCH 1/1 0] Urgent bug fix
>> [PATCH 1/1 1] Bug fix
>> [PATCH 1/1 2] ...
>> [PATCH 1/1 7] kernel-doc fix
>> [PATCH 1/1 8] Code clean-up
>> [PATCH 1/1 9] Trivial fix
>>
>> Maybe this could help some people to sort/filter/delete

No need to add more bureaucracy, such filtering can perfectly done
by looking at the sender name. (Sadly...)
We also have the trivial tree.

-- 
Thanks,
//richard
