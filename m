Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab3GDBXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 21:23:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24132 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab3GDBX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 21:23:29 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=6tI4O6vlircA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=S9odRq4Da1AA:10 a=06uRaroS7CWvDZJWTCIA:9 a=QEXdDO2ut3YA:10 a=6TGYxpvbIyEA:10 a=6rbT038PrLMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372901004.22688.137.camel@gandalf.local.home>
Subject: Re: [PATCH] include/asm-generic/io.h: add dummy fuctions to support
 'COMPILE_TEST' in 'asm-generic'.
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Chen Gang <gang.chen@asianux.com>, Arnd Bergmann <arnd@arndb.de>,
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
Date: Wed, 03 Jul 2013 21:23:24 -0400
In-Reply-To: <20130704011221.GA11230@kroah.com>
References: <51CA8AB8.7080504@asianux.com>
	 <CAMuHMdW58CZ0m-10ibs2Vyh8exqP1nSH+-ZOr5J58tx=uorM+Q@mail.gmail.com>
	 <51D375AA.5060300@asianux.com> <201307031014.12583.arnd@arndb.de>
	 <51D3E440.7090105@asianux.com> <51D4C87E.5070605@asianux.com>
	 <20130704011221.GA11230@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 18:12 -0700, Greg KH wrote:

> confused,

Good. I thought I was the only one. Confusion loves company, that way we
can follow each other around in endless circles.

-- Steve


