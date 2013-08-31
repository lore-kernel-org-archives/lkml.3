Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab3HaTk3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 15:40:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38405 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab3HaTk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 15:40:28 -0400
Date: Sat, 31 Aug 2013 20:40:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lennox Wu <lennox.wu@gmail.com>, Chen Liqin <liqin.chen@sunplusct.com>,
        Liqin Chen <liqin299@gmail.com>
Subject: Re: [PATCH] Remove support for score architecture
Message-ID: <20130831194018.GM13318@ZenIV.linux.org.uk>
References: <1377914435-24206-1-git-send-email-linux@roeck-us.net>
 <201308312055.17209.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201308312055.17209.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 08:55:16PM +0200, Arnd Bergmann wrote:

> > Maybe this removal request is a bit early, but architecture support seems
> > to have vanished entirely. At the very least this puts interested parties
> > (if there are any) on notice.
> 
> AFAICT, this is the least maintained architecture we have at the moment,
> and your analysis is correct.
> 
> I think it can be removed unless we the maintainers have plans to become
> more active in the future or someone else steps up to maintain the
> architecture.

AFAICS, the architecture is stillborn - they planned to use it in game
consoles and stuff like that, but recession has hit the fan just as they
were about to do that.  Maintainers are not employed there anymore, gcc
had a commit updating maintainer address, but the new address is of
form ...+gcc@... and no corresponding update of address in the kernel
tree has happened.  In such situation I would really hesitate to put
the new address into MAINTAINERS...

IOW, this is an ex-parrot.
