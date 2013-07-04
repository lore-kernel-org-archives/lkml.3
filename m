Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab3GDEv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 00:51:27 -0400
Received: from intranet.asianux.com ([58.214.24.6]:30022 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab3GDEvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 00:51:25 -0400
X-Spam-Score: -100.8
Message-ID: <51D4FF17.4040503@asianux.com>
Date: Thu, 04 Jul 2013 12:50:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Chen Gang F T <chen.gang.flying.transformer@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Arnd Bergmann <arnd@arndb.de>,
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
References: <51D3E440.7090105@asianux.com> <51D4C87E.5070605@asianux.com> <20130704011221.GA11230@kroah.com> <51D4D4A0.6080401@asianux.com> <1372903390.22688.139.camel@gandalf.local.home> <51D4D9A4.3020402@gmail.com> <1372904975.22688.142.camel@gandalf.local.home> <51D4E133.2010201@gmail.com> <1372907201.22688.147.camel@gandalf.local.home> <51D4EB7D.2020809@gmail.com> <20130704040859.GA2869@kroah.com>
In-Reply-To: <20130704040859.GA2869@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 12:08 PM, Greg KH wrote:
> On Thu, Jul 04, 2013 at 11:26:53AM +0800, Chen Gang F T wrote:
>> > Please see the related comment in "init/Kconfig" of next-* tree.
> This is now in Linus's tree for 3.11.
> 

OK, thanks (at least for me, it is a good news).

>> > config COMPILE_TEST
>> >        bool "Compile also drivers which will not load"
>> >        default n
> This has _nothing_ to do with asm-generic, sorry.  Please don't confuse
> the issue.

But when I choose allmodconfig, then "COMPILE_TEST=y". this may allow a
module to compile under the architectures which no related HW support.

When cause compiling issue (HW not support), it is not module's issue,
we can not 'fix' module by force, and it is not architecture's issue,
either.

So we have to look for who has duty for this issue. At least now, it
seems only 'asm-generic' can be qualified to play this unlucky role.


Thanks.
-- 
Chen Gang
