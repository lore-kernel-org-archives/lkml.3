Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab3BNJzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 04:55:51 -0500
Received: from gate.crashing.org ([63.228.1.57]:49940 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757109Ab3BNJzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 04:55:49 -0500
Message-ID: <1360835542.6646.5.camel@pasglop>
Subject: Re: [RFC][CFT] what's in signal.git queue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, Jonas Bonn <jonas@southpole.se>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Richard Kuo <rkuo@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Chris Zankel <chris@zankel.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Russell King <linux@arm.linux.org.uk>
Date: Thu, 14 Feb 2013 20:52:22 +1100
In-Reply-To: <20130214012539.GQ4503@ZenIV.linux.org.uk>
References: <20130214012539.GQ4503@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 01:25 +0000, Al Viro wrote:
> Mostly it's a unification of signal-related syscalls, both native and compat
> ones; by the end of it we shouldn't have syscalls left in normal
> arch/*/kernel/signal*.c - there are some exceptions due to genuine weirdness
> of arch-specific calling conventions, but that's rare.  Another (somewhat
> related) story in there is more compat_sys_something() getting switched to
> COMPAT_SYSCALL_DEFINE, giving us proper argument validation wrappers.  Not
> everything got switched, of course, but a lot of those guys has been.

FYI. I'm going to be off to some meeting & bringup work in the US for two weeks
so expect little responsiveness from me on this until after I'm back (March 1st).

Cheers,
Ben.


