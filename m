Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab3JRQRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 12:17:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57772 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756164Ab3JRQRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 12:17:30 -0400
Date: Fri, 18 Oct 2013 13:17:44 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Kevin Hilman <khilman@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: kirkwood: remove lagacy clk workarounds
Message-ID: <20131018161743.GA29595@localhost>
References: <1382097253-15624-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20131018144741.GL22434@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131018144741.GL22434@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 10:47:41AM -0400, Jason Cooper wrote:
> On Fri, Oct 18, 2013 at 01:54:13PM +0200, Sebastian Hesselbarth wrote:
> > With legacy devices converted to DT and a proper ethernet MAC
> > workaround, we can now remove the clk workarounds for legacy
> > devices. While at it, also cleanup the list of includes.
> > 
> > Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> > ---
> > As a follow-up patch for latest mvebu PRs, this patch is based on
> >  git://git.infradead.org/linux-mvebu.git tags/soc-3.13-2
> > 
> > Cc: Jason Cooper <jason@lakedaemon.net>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: Kevin Hilman <khilman@linaro.org>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  arch/arm/mach-kirkwood/board-dt.c |   42 ++----------------------------------
> >  1 files changed, 3 insertions(+), 39 deletions(-)
> 
> Applied to mvebu/soc
> 

Weird: I've tried to do this clean-up myself and my usual tests with network
built as a module failed somehow. Maybe I missed something and did something
stupid?

Of course, I'll re-try and let you all know...
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
