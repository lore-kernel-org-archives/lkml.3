Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab3GDEIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 00:08:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab3GDEIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 00:08:10 -0400
Date: Wed, 3 Jul 2013 21:08:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Chen Gang <gang.chen@asianux.com>,
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
Message-ID: <20130704040859.GA2869@kroah.com>
References: <51D3E440.7090105@asianux.com>
 <51D4C87E.5070605@asianux.com>
 <20130704011221.GA11230@kroah.com>
 <51D4D4A0.6080401@asianux.com>
 <1372903390.22688.139.camel@gandalf.local.home>
 <51D4D9A4.3020402@gmail.com>
 <1372904975.22688.142.camel@gandalf.local.home>
 <51D4E133.2010201@gmail.com>
 <1372907201.22688.147.camel@gandalf.local.home>
 <51D4EB7D.2020809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D4EB7D.2020809@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 11:26:53AM +0800, Chen Gang F T wrote:
> Please see the related comment in "init/Kconfig" of next-* tree.

This is now in Linus's tree for 3.11.

> config COMPILE_TEST
>        bool "Compile also drivers which will not load"
>        default n

This has _nothing_ to do with asm-generic, sorry.  Please don't confuse
the issue.

greg k-h
