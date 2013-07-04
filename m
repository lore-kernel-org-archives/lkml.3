Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797Ab3GDBLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 21:11:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab3GDBLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 21:11:32 -0400
Date: Wed, 3 Jul 2013 18:12:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        David Sharp <dhsharp@google.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] include/asm-generic/io.h: add dummy fuctions to support
 'COMPILE_TEST' in 'asm-generic'.
Message-ID: <20130704011221.GA11230@kroah.com>
References: <51CA8AB8.7080504@asianux.com>
 <CAMuHMdW58CZ0m-10ibs2Vyh8exqP1nSH+-ZOr5J58tx=uorM+Q@mail.gmail.com>
 <51D375AA.5060300@asianux.com>
 <201307031014.12583.arnd@arndb.de>
 <51D3E440.7090105@asianux.com>
 <51D4C87E.5070605@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D4C87E.5070605@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 08:57:34AM +0800, Chen Gang wrote:
> 'asm-generic' neither belongs to architectures nor belongs to modules,
> it provides public services to both modules and architectures.

That sentence does not make any sense to me.

> 'COMPILE_TEST=y' will let 'asm-generic' provide self checking sevices to
> both modules and architectures (especially with allmodconfig and
> "EXTRA_CFLAGS=-W")

No it doesn't.

> For modules (especially which will run under the specific architecture
> soon), the developer can find more compiling issues before they really
> support it.

Huh?

> For architectures, can let modules compile as much as possible (if
> "COMPILE_TEST=y"), it will give a better check for the architectures.
> 
> At present, most of architectures (include various machine/cpu in an
> architecture) can not pass compiling with 'allmodconfig'. One of the
> main reasons is the HW of the specific architecture does not support.
> 
> It is neither architectures issue nor modules issue, the root cause is:
> "now, 'asm-generic' doesn't provide the related necessary public
> services for it".

That's not what asm-generic is for at all.

confused,

greg k-h
