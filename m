Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaAGOmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:42:14 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:58256 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751743AbaAGOlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:41:49 -0500
Date: Tue, 7 Jan 2014 14:41:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, sahara <keun-o.park@windriver.com>,
        Keun-O Park <kpark3469@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 19/19] [INCOMPLETE] ARM: make return_address available
	for ARM_UNWIND
Message-ID: <20140107144130.GJ27432@n2100.arm.linux.org.uk>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <20130128125023.GA2027@linaro.org> <CA+KhAHYvbxANa84FMDVV96udwhif2P2_XirPhWVWTKy_8iK72A@mail.gmail.com> <201401071533.35309.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201401071533.35309.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 03:33:34PM +0100, Arnd Bergmann wrote:
> On Tuesday 29 January 2013, Keun-O Park wrote:
> > On Mon, Jan 28, 2013 at 9:50 PM, Dave Martin <dave.martin@linaro.org> wrote:
> > > On Mon, Jan 28, 2013 at 11:33:11AM +0900, Keun-O Park wrote:
> > >> Hello guys,
> > >>
> > >> Could you please review the patch of fixing bug first of returning
> > >> wrong address when using frame pointer?
> > >> I am wondering if the first patch is not delivered to the mailing.
> > >
> > > I posted a similar patch to alkml a couple of months ago, but I got
> > > no response and it looks like I forgot about it.
> > >
> > > http://lists.infradead.org/pipermail/linux-arm-kernel/2012-November/129381.html
> > 
> > Yes, same except initialization of data.addr. :)
> > This means there might be no one interested in using
> > ftrace-irqsoff/premptoff in ARM during a couple of months?
> 
> 
> It's been almost a year since we last discussed the patches that were
> posted by Dave and sahara, but nothing has changed in the mainline kernel.
> 
> Any chance that someone could be motivated to pick this work up again
> and finally fix return_address().

I thought that we had _actively_ decided that we would not use the
unwinder for these paths - that it was too expensive for these paths,
and you had to use frame pointers instead.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
