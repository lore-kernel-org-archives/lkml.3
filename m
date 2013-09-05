Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3IEQNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 12:13:19 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:44242 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3IEQNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 12:13:17 -0400
Date: Thu, 5 Sep 2013 09:13:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lennox Wu <lennox.wu@gmail.com>, Chen Liqin <liqin.chen@sunplusct.com>
Subject: Re: [PATCH] Remove support for score architecture
Message-ID: <20130905161313.GA19415@roeck-us.net>
References: <1377914435-24206-1-git-send-email-linux@roeck-us.net>
 <1378388503.1985.7@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378388503.1985.7@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 08:41:43AM -0500, Rob Landley wrote:
> On 08/30/2013 09:00:35 PM, Guenter Roeck wrote:
> >The web site associated with the score architecture in MAINTAINERS
> >is non-functional and available for sale. The last Ack from one
> >of the maintainers was in December 2012. The main maintainer's last
> >commit was in 2011. The last maintainer pull request was early 2011.
> >
> >Cc: Lennox Wu <lennox.wu@gmail.com>
> >Cc: Chen Liqin <liqin.chen@sunplusct.com>
> >Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> >---
> >More housekeeping.
> >
> >Maybe this removal request is a bit early, but architecture
> >support seems
> >to have vanished entirely. At the very least this puts interested
> >parties
> >(if there are any) on notice.
> 
> I note that if qemu system emulation supports an obscurish platform,
> the rest of us can regression test it. If qemu doesn't support it,
> we can't.
> 
> (I'm looking at you, Hexagon.)
> 
At least they have a working compiler. It also helps if qemu runs with an
unpatched upstream kernel, which is unfortunately not always the case.

Guenter
