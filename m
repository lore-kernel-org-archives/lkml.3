Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaCWG6h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 02:58:37 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:43635 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaCWG6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 02:58:36 -0400
MIME-Version: 1.0
In-Reply-To: <1395553958.5459.3.camel@marge.simpson.net>
References: <CAJiejCSDC2EEsxN4d6C=LfB+TbYQ+7pyrzWU2SeeRHrvwxVhQw@mail.gmail.com>
 <1395553958.5459.3.camel@marge.simpson.net>
From: Drunkard Zhang <gongfan193@gmail.com>
Date: Sun, 23 Mar 2014 14:58:16 +0800
Message-ID: <CAJiejCTv0Vsq0zecEhKD9B7sNqEKsa+Do_LLiykvvfH1+=9jqQ@mail.gmail.com>
Subject: Re: 3.14-rc7 compile failure
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-23 13:52 GMT+08:00 Mike Galbraith <umgwanakikbuti@gmail.com>:
> On Sun, 2014-03-23 at 13:29 +0800, Drunkard Zhang wrote:
>
>> scripts/genksyms/genksyms.o: In function `main':
>> genksyms.c:(.text.startup+0x183): undefined reference to `yydebug'
>> genksyms.c:(.text.startup+0x18c): undefined reference to `yy_flex_debug'
>> genksyms.c:(.text.startup+0x1a5): undefined reference to `yyparse'
>> collect2: error: ld returned 1 exit status
>> make[2]: *** [scripts/genksyms/genksyms] Error 1
>> make[1]: *** [scripts/genksyms] Error 2
>> make[1]: *** Waiting for unfinished jobs....
>
> flex and bison installed?  rpm -q flex bison
>
I'm using Gentoo.
squid85 ~ # qlist -Iv flex bison
sys-devel/bison-2.4.3
sys-devel/flex-2.5.37
squid85 ~ # cat /etc/gentoo-release
Gentoo Base System release 2.2
