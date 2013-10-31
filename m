Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab3JaXyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 19:54:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53028 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753534Ab3JaXyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 19:54:44 -0400
Date: Thu, 31 Oct 2013 20:54:43 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Kevin Hilman <khilman@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: kirkwood: remove lagacy clk workarounds
Message-ID: <20131031235442.GA10593@localhost>
References: <1382097253-15624-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20131018144741.GL22434@titan.lakedaemon.net>
 <20131018161743.GA29595@localhost>
 <52616F81.8060504@gmail.com>
 <5261735A.1000504@gmail.com>
 <20131018174545.GN22434@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131018174545.GN22434@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 01:45:45PM -0400, Jason Cooper wrote:
> On Fri, Oct 18, 2013 at 07:43:54PM +0200, Sebastian Hesselbarth wrote:
> > On 10/18/2013 07:27 PM, Sebastian Hesselbarth wrote:
> > >On 10/18/2013 06:17 PM, Ezequiel Garcia wrote:
> > >>On Fri, Oct 18, 2013 at 10:47:41AM -0400, Jason Cooper wrote:
> > >>>On Fri, Oct 18, 2013 at 01:54:13PM +0200, Sebastian Hesselbarth wrote:
> > >>>>With legacy devices converted to DT and a proper ethernet MAC
> > >>>>workaround, we can now remove the clk workarounds for legacy
> > >>>>devices. While at it, also cleanup the list of includes.
> > >>>>
> > >>>>Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> > >>>>---
> > >>>>As a follow-up patch for latest mvebu PRs, this patch is based on
> > >>>>  git://git.infradead.org/linux-mvebu.git tags/soc-3.13-2
> > >>>>
> > >>>>Cc: Jason Cooper <jason@lakedaemon.net>
> > >>>>Cc: Andrew Lunn <andrew@lunn.ch>
> > >>>>Cc: Russell King <linux@arm.linux.org.uk>
> > >>>>Cc: Kevin Hilman <khilman@linaro.org>
> > >>>>Cc: linux-arm-kernel@lists.infradead.org
> > >>>>Cc: linux-kernel@vger.kernel.org
> > >>>>---
> > >>>>  arch/arm/mach-kirkwood/board-dt.c |   42
> > >>>>++----------------------------------
> > >>>>  1 files changed, 3 insertions(+), 39 deletions(-)
> > >>>
> > >>>Applied to mvebu/soc
> > >>>
> > >>
> > >>Weird: I've tried to do this clean-up myself and my usual tests with
> > >>network
> > >>built as a module failed somehow. Maybe I missed something and did
> > >>something
> > >>stupid?
> > >
> > >Ezequiel,
> > >
> > >you need commits
> > >b5d82db net: mv643xx_eth: fix missing device_node for port devices
> > >f564412 net: mv643xx_eth: fix orphaned statistics timer crash
> > >041b4dd net: mv643xx_eth: update statistics timer from timer context only
> > >
> > >from git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
> > >
> > >Those are the three net driver fixes and have not yet been pulled into
> > >mainline linux.
> > >
> > >Can you re-test with those three applied (or you can just merge in
> > >above master)? I am compiling right now and will report.
> > 
> > With mvebu/for-next and net/master merged in,
> > modular mvmdio and mv643xx_eth on Kirkwood Dockstar:
> > 
> > Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail>
> > 
> > IOW, works. I hope you can confirm this, too.

Hm... Sorry for the huge delay, I've only had time just now to test this:

Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Although I realise it's too late for v3.13.

Nice work Sebastian!
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
