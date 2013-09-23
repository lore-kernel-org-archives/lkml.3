Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3IWJOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:14:33 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:33779 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab3IWJOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:14:32 -0400
Date: Mon, 23 Sep 2013 11:10:36 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/26] ARM: dove: remove custom .init_time hook
Message-ID: <20130923091036.GE4999@lunn.ch>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1379526839-14798-12-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130921122226.GB31180@lunn.ch>
 <523EE08C.60309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523EE08C.60309@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 02:20:28PM +0200, Sebastian Hesselbarth wrote:
> On 09/21/2013 02:22 PM, Andrew Lunn wrote:
> >On Wed, Sep 18, 2013 at 07:53:44PM +0200, Sebastian Hesselbarth wrote:
> >>With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> >>remove custom .init_time hooks. While at it, also remove some obsolete
> >>includes.
> >>
> >>Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> >>---
> >>Cc: Olof Johansson <olof@lixom.net>
> >>Cc: Arnd Bergmann <arnd@arndb.de>
> >>Cc: Jason Cooper <jason@lakedaemon.net>
> >>Cc: Andrew Lunn <andrew@lunn.ch>
> >>Cc: Russell King <linux@arm.linux.org.uk>
> >>Cc: linux-arm-kernel@lists.infradead.org
> >>Cc: linux-kernel@vger.kernel.org
> >>---
> >>  arch/arm/mach-dove/board-dt.c |   11 -----------
> >>  1 file changed, 11 deletions(-)
> [...]
> >Boot tested on cubox.
> >
> >Tested-by: Andrew Lunn <andrew@lunn.ch>
> 
> Thanks Andrew!
> 
> Aren't you giving any Acks for dove/kirkwood anymore?

Hi Sebastian

In my opinion, a Tested-by: has more weight than an Acked-by. I could
of given you an Acked-by in about 60 seconds, given the simplicity of
the patch. It took a lot more effort to get your tree, build it, fix
my binutils, since it was the first 3.12 tree i had tried and my
binutils was too old, and boot it.

	 Andrew
