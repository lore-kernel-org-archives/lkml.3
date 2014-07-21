Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbaGUNM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:12:57 -0400
Received: from mailsec108.isp.belgacom.be ([195.238.20.104]:51080 "EHLO
	mailsec108.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932104AbaGUNM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:12:56 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=UGN7JNw3bPEHpwjh5ACRRBK85/3fvewMg9DN/Z6sboU= c=1 sm=2
 a=DKQk9pvXMeEA:10 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=IJv9LcIfAAAA:8
 a=hdRPAOJJrbiZFAsJ_4IA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10
 a=K6kUPx8HyhEA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At0GADERzVPD7hTT/2dsb2JhbABZgw5Sg0+rUQEBBpZqh00BgRUWdoQDAQEEASNWBQsFBhgCAhgOAgIhNgYBEhGIHQMJDKd1hn+ITw2HIxeBLIRPhAODIIItB4J4gU4FmSKDUIxGhhyDRjsv
Date: Mon, 21 Jul 2014 15:12:54 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Richard Weinberger <richard.weinberger@gmail.com>,
        Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <94507081.822839.1405948374414.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <CAFLxGvwGLjxPRV7XcJvREOkAcRT3ad2tG7kjzeo4yJKk5mJQHA@mail.gmail.com>
References: <1619290298.804838.1405876434000.open-xchange@webmail.nmp.skynet.be> <1405877791.5135.36.camel@joe-AO725> <CAFLxGvwGLjxPRV7XcJvREOkAcRT3ad2tG7kjzeo4yJKk5mJQHA@mail.gmail.com>
Subject: Re: Patch priority in subjects ?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 21 July 2014 at 13:33 Richard Weinberger <richard.weinberger@gmail.com>
> wrote:
>
>
> On Sun, Jul 20, 2014 at 7:36 PM, Joe Perches <joe@perches.com> wrote:
> > On Sun, 2014-07-20 at 19:13 +0200, Fabian Frederick wrote:
> >> I was reading all those "friendly" messages around checkpatch -f lately
> >> and the fact that code clean-up is too noisy (?)
> >>
> >> I guess I'm not the first to think about it but why don't we use something
> >> like a priority field in patch subject ?
>
> Code clean up is not bad per se.
> Actually cleaning up things is very much welcome.
>
> The thing is that pure white space or search&replace patches
> produced by checkpatch.pl are often not helpful at all.
> They pollute the git history, introduce merge conflicts, add
> maintenance overhead, etc..
>
> As somebody who regularly stares at code to find outhow the heck
> some line of code got introduced these patches become a major PITA.
> Running commands like are needed far too often:
> git blame ~1 foo/bar.c
>

I understand your point of view now.
Maybe Joe has an idea about this (get_maintainer ...) ?

> Btw: Don't even try to tell me about the -w switch...
>
> >> Of course it would be arbitrary but maybe better than nothing ?
> >>
> >> eg
> >>
> >> [PATCH 1/1 0] Urgent bug fix
> >> [PATCH 1/1 1] Bug fix
> >> [PATCH 1/1 2] ...
> >> [PATCH 1/1 7] kernel-doc fix
> >> [PATCH 1/1 8] Code clean-up
> >> [PATCH 1/1 9] Trivial fix
> >>
> >> Maybe this could help some people to sort/filter/delete
>
> No need to add more bureaucracy, such filtering can perfectly done
> by looking at the sender name. (Sadly...)
> We also have the trivial tree.

I've made a small RFC script so we'll be able to talk around something concrete.
I know it would add some rules to follow but having such a script related in
SubmittingPatches
could help in the following:

-Patch prefix could help making statistics.
-Having automatically -s flag (+others?) avoid thousand of replies "Please add
Signed-off-by".
-Avoid different formats like [PATCH 1 V3] , [PATCH 1/1 v3], [PATCH V3]
-Batch patch generation, checking, sending.
-...

Regards,
Fabian
>
> --
> Thanks,
> //richard
