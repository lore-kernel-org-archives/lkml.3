Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407Ab3GDCMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 22:12:03 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:57578 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab3GDCL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 22:11:59 -0400
Message-ID: <51D4D9A4.3020402@gmail.com>
Date: Thu, 04 Jul 2013 10:10:44 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Chen Gang <gang.chen@asianux.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        David Sharp <dhsharp@google.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] include/asm-generic/io.h: add dummy fuctions to support
 'COMPILE_TEST' in 'asm-generic'.
References: <51CA8AB8.7080504@asianux.com>  <CAMuHMdW58CZ0m-10ibs2Vyh8exqP1nSH+-ZOr5J58tx=uorM+Q@mail.gmail.com>  <51D375AA.5060300@asianux.com> <201307031014.12583.arnd@arndb.de>  <51D3E440.7090105@asianux.com> <51D4C87E.5070605@asianux.com>  <20130704011221.GA11230@kroah.com> <51D4D4A0.6080401@asianux.com> <1372903390.22688.139.camel@gandalf.local.home>
In-Reply-To: <1372903390.22688.139.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 10:03 AM, Steven Rostedt wrote:
> On Thu, 2013-07-04 at 09:49 +0800, Chen Gang wrote:
> 
>> > Hmm... at least, it is neither architectures issue nor modules issue.
>> > 
>> > So we have to look for who have duty for it, since it is a 'generic'
>> > issue for many architectures and modules, we have to find it in
>> > 'generic' area (e.g. "./include/*").
>> > 
>> > At least now, it seems only "asm-generic/*" can play the unlucky role !!
>> > 
>> > Or, do you think it is still the modules issue themselves ?
> What problem are you trying to solve? asm-generic has been around for a
> long time, and so has allmodconfig. I'm unaware of any issues with
> either of them.
> 

Select "COMPILE_TEST=y" with allmodconfig, but can not pass compiling in
many architectures, one of the most reasons is "HW does not support".

'asm-generic' is really existent for a long time, and make an important
role for both architectures and modules.

> But as my last email got blocked because your ISP thinks my ISP is a
> spambot (it's road runner, which I'm sure there are spammers), you wont
> get this anyway.

Oh, sorry for not reply the original mail, and did not see in my backup
mail, now, I can use my backup mail to continue.


Thanks.
-- 
Chen Gang
