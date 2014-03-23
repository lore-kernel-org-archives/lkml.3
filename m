Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaCWLJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 07:09:18 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:45240 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaCWLJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 07:09:17 -0400
MIME-Version: 1.0
In-Reply-To: <1395562999.5459.25.camel@marge.simpson.net>
References: <CAJiejCSDC2EEsxN4d6C=LfB+TbYQ+7pyrzWU2SeeRHrvwxVhQw@mail.gmail.com>
 <1395553958.5459.3.camel@marge.simpson.net> <CAJiejCTv0Vsq0zecEhKD9B7sNqEKsa+Do_LLiykvvfH1+=9jqQ@mail.gmail.com>
 <1395562999.5459.25.camel@marge.simpson.net>
From: Drunkard Zhang <gongfan193@gmail.com>
Date: Sun, 23 Mar 2014 19:08:56 +0800
Message-ID: <CAJiejCSxz4qz3H2-wrquVr6XaQBX2evujYfcL3skTt-0LaVLGA@mail.gmail.com>
Subject: Re: 3.14-rc7 compile failure
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-23 16:23 GMT+08:00 Mike Galbraith <umgwanakikbuti@gmail.com>:
> On Sun, 2014-03-23 at 14:58 +0800, Drunkard Zhang wrote:
>> 2014-03-23 13:52 GMT+08:00 Mike Galbraith <umgwanakikbuti@gmail.com>:
>> > On Sun, 2014-03-23 at 13:29 +0800, Drunkard Zhang wrote:
>> >
>> >> scripts/genksyms/genksyms.o: In function `main':
>> >> genksyms.c:(.text.startup+0x183): undefined reference to `yydebug'
>> >> genksyms.c:(.text.startup+0x18c): undefined reference to `yy_flex_debug'
>> >> genksyms.c:(.text.startup+0x1a5): undefined reference to `yyparse'
>> >> collect2: error: ld returned 1 exit status
>> >> make[2]: *** [scripts/genksyms/genksyms] Error 1
>> >> make[1]: *** [scripts/genksyms] Error 2
>> >> make[1]: *** Waiting for unfinished jobs....
>> >
>> > flex and bison installed?  rpm -q flex bison
>> >
>> I'm using Gentoo.
>> squid85 ~ # qlist -Iv flex bison
>> sys-devel/bison-2.4.3
>> sys-devel/flex-2.5.37
>> squid85 ~ # cat /etc/gentoo-release
>> Gentoo Base System release 2.2
>
> No idea.  I'd make mrproper, re-config and try again.  Given it builds
> fine for the rest of the planet (afaik), it's gotta be local breakage.
>
I cleaned and did it over, this time I succeeded! Still didn't know
why, thanks again :)
squid85 /usr/src/linux-3.14-rc7 # make -j12 mrproper
[reconfig]
squid85 /usr/src/linux-3.14-rc7 # make -j3 && make modules_install install
