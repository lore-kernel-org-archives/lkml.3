Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab3EJCs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 22:48:56 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:59097 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab3EJCsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 22:48:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130510102706.84061f044d3e59717638b731@canb.auug.org.au>
References: <1368098909-919-1-git-send-email-realmz6@gmail.com>
	<CA+55aFyQVZ622dH-e+V77B6LKuYeXS+QfnYYQK77=0T82-MkAA@mail.gmail.com>
	<20130510102706.84061f044d3e59717638b731@canb.auug.org.au>
Date: Fri, 10 May 2013 10:48:54 +0800
Message-ID: <CAMk6uBk2inVj8Hu8YZ3tQ86OMh-Ub86eJmx9csrmFO+H4zq0rQ@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [GIT PULL] Blackfin updates for 3.10
From: Steven Miao <realmz6@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bob Liu <lliubbo@gmail.com>, uclinux-dist-devel@blackfin.uclinux.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Yes, please update the current blackfin tree with:

  https://github.com/realmz/blackfin-linux.git  blackfin-linus

Thanks!

-steven

On Fri, May 10, 2013 at 8:27 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Thu, 9 May 2013 14:53:42 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>> Hmm. I'm used to pull blackfin updates from Bob Liu. I see that he has
>> signed your gpg key, so this all looks fine, but quite frankly, Id'
>> much rather be told ahead of time that "oh, expect pulls from another
>> person".
>>
>> I do *not* want to end up in some kind of fight over who maintains
>> what. Bob? Am I supposed to expect blackfin pulls to come from Steven
>> now? Or is this a one-off? Or what?
>
> And should this tree be included in linux-next for future work (as well,
> or instead of, the current blackfin tree)?
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
