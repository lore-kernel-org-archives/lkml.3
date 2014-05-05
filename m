Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbaEEKqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 06:46:10 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:48887 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190AbaEEKqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 06:46:08 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140505202628.7f406c1b77e05d0ad56db54c@canb.auug.org.au>
References: <20140505171459.3ce28e8e0c4d6b107a66eb97@canb.auug.org.au>
 <CAHO5Pa0D8bxBV98feBt2qk_gb3XdTDcmaa6bD7eQv4UOdjcFrA@mail.gmail.com>
 <20140505195711.fcce1825483f7a1ce707c2c6@canb.auug.org.au>
 <CAKgNAkj4hsTBqfD72ZhoCrHdV4S_68tJEQ_AaE0KWO_cySqeHw@mail.gmail.com> <20140505202628.7f406c1b77e05d0ad56db54c@canb.auug.org.au>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 5 May 2014 12:45:46 +0200
Message-ID: <CAKgNAkg3X3osNCdWYs4abru9kWGakF2pFuN5jje5HdNV=pK2-g@mail.gmail.com>
Subject: Re: linux-next: Tree for May 5
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next <linux-next@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrey Vagin <avagin@openvz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 12:26 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Michael,
>
> On Mon, 5 May 2014 12:06:27 +0200 "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:
>>
>> Okay, must be my problem then. Sorry for the noise. Somehow, I'm not
>> syncing my linux-next correctly then. (Is the proper way of doing this
>> documented somewhere?)
>
> Yeah, in the stuff you quoted :-)

:-}
> "If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
> (see below)."
>
> then later
>
> "There is a wiki covering stuff to do with linux-next at
> http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel."
>
> Unfortunately, that site seems to have vanished :-(  Seems like I need to
> update my daily release note.

It was those instructions that I thought I'd been following (from
memory), and then when I went to google for the site I recalled
finding them on, I didn't get a match. Now I know why ;-).

> Since linux-next is rebased and remoerged every day, you need to "git
> fetch" the tree and then "git reset" to the new tree, not "git pull".
> The latter will try to merge the new linux-next into the previous one  -
> which should normally make a read mess :-)

Okay -- thanks.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
