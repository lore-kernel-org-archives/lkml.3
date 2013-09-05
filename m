Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab3IENlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:41:47 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:45578 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3IENlq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:41:46 -0400
Date: Thu, 05 Sep 2013 08:41:43 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Remove support for score architecture
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Lennox Wu <lennox.wu@gmail.com>,
        Chen Liqin <liqin.chen@sunplusct.com>
In-Reply-To: <1377914435-24206-1-git-send-email-linux@roeck-us.net> (from
	linux@roeck-us.net on Fri Aug 30 21:00:35 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1378388503.1985.7@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 09:00:35 PM, Guenter Roeck wrote:
> The web site associated with the score architecture in MAINTAINERS
> is non-functional and available for sale. The last Ack from one
> of the maintainers was in December 2012. The main maintainer's last
> commit was in 2011. The last maintainer pull request was early 2011.
> 
> Cc: Lennox Wu <lennox.wu@gmail.com>
> Cc: Chen Liqin <liqin.chen@sunplusct.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> More housekeeping.
> 
> Maybe this removal request is a bit early, but architecture support  
> seems
> to have vanished entirely. At the very least this puts interested  
> parties
> (if there are any) on notice.

I note that if qemu system emulation supports an obscurish platform,  
the rest of us can regression test it. If qemu doesn't support it, we  
can't.

(I'm looking at you, Hexagon.)

Rob