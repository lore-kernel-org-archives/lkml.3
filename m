Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaJSJyp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 05:54:45 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:37706 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751580AbaJSJyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 05:54:43 -0400
Date: Sun, 19 Oct 2014 10:54:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Rik van Riel <riel@redhat.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "'Nathan Lynch'" <Nathan_Lynch@mentor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        Rabin Vincent <rabin@rab.in>, David Laight <David.Laight@ACULAB.COM>,
        Alan Stern <stern@rowland.harvard.edu>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RCU bug with v3.17-rc3 ?
Message-ID: <20141019095416.GT12379@n2100.arm.linux.org.uk>
References: <20141009204637.GE25729@saruman> <20141009210715.GH25729@saruman> <20141010135743.GB31348@saruman> <20141010162531.GL12379@n2100.arm.linux.org.uk> <54388B81.5020306@mentor.com> <063D6719AE5E284EB5DD2968C1650D6D174C996E@AcuExch.aculab.com> <20141013114307.GO12379@n2100.arm.linux.org.uk> <20141014020640.GB25433@kroah.com> <20141015212310.GP12379@n2100.arm.linux.org.uk> <20141015212513.GA3247@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015212513.GA3247@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 10:25:13PM +0100, Russell King - ARM Linux wrote:
> On Wed, Oct 15, 2014 at 10:23:10PM +0100, Russell King - ARM Linux wrote:
> > As I said, I have a patch in progress, but it seems that there needed
> > to be some discussion about exactly which compiler versions are affected.
> > It seems that it's not as trivial as looking at the GCC bug entry.
> 
> ... and in any case, it has been a known bug for well over a year now,
> and it seems that it doesn't affect _that_ many people.  So taking some
> extra time to get it properly correct is the _right_ thing to do.

Well, this is just great.  Pushing out the change which blacklists these
compilers takes out Olof's kernel build system...

Things are not as trivial as they seem.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
