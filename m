Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3GHD6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 23:58:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:63738 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3GHD6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 23:58:09 -0400
Date: Sun, 7 Jul 2013 23:58:14 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Stage 1 of __cpuinit removal
Message-ID: <20130708035814.GN22702@windriver.com>
References: <20130702174402.GA21817@windriver.com>
 <CA+55aFzoMm=_VbJJknFC=cVzbq2Xq3kN9X-Xsr=rSoZVPHZNPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+55aFzoMm=_VbJJknFC=cVzbq2Xq3kN9X-Xsr=rSoZVPHZNPw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [GIT PULL] Stage 1 of __cpuinit removal] On 07/07/2013 (Sun 11:07) Linus Torvalds wrote:

> On Tue, Jul 2, 2013 at 10:44 AM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
> >
> >  include/asm-generic/vmlinux.lds.h | 12 ---------
> >  include/linux/init.h              | 19 +++++++-------
> >  scripts/mod/modpost.c             | 52 +++++++--------------------------------
> >  3 files changed, 19 insertions(+), 65 deletions(-)
> 
> Your diffstat is odd, and doesn't match mine. But I'm pretty sure
> yours is just plain wrong, because your numbers just don't add up.
> 
> You have:
>   12+19+52 = 83
>   19+65 = 84
> 
> how the heck did you manage that?

I must have fat fingered it in vim/mutt under screen with a stray
Ctrl-A (increase number), since I still have the raw output from
git request-pull that I pulled into mutt and it is sane and correct.

------
$ ls -l prq
-rw-rw-r-- 1 paul paul 845 Jul  2 13:11 prq
$ grep changed prq
 3 files changed, 18 insertions(+), 65 deletions(-)
------

Sorry about the confusion.

Paul.
--

> 
> The correct diffstat would seem to be
> 
>  include/asm-generic/vmlinux.lds.h | 12 ------------
>  include/linux/init.h              | 19 +++++++++---------
>  scripts/mod/modpost.c             | 52
> +++++++++----------------------------------------
>  3 files changed, 18 insertions(+), 65 deletions(-)
> 
> (where both set of numbers add up to 83).
> 
>                   Linus
