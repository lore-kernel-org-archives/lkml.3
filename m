Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaJOVXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 17:23:41 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35093 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751821AbaJOVXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 17:23:39 -0400
Date: Wed, 15 Oct 2014 22:23:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg KH <greg@kroah.com>
Cc: David Laight <David.Laight@ACULAB.COM>,
        "'Nathan Lynch'" <Nathan_Lynch@mentor.com>,
        Felipe Balbi <balbi@ti.com>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tony Lindgren <tony@atomide.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        Rabin Vincent <rabin@rab.in>, Alan Stern <stern@rowland.harvard.edu>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RCU bug with v3.17-rc3 ?
Message-ID: <20141015212310.GP12379@n2100.arm.linux.org.uk>
References: <20141009162656.GE16002@saruman> <20141009204101.GA25955@debian> <20141009204637.GE25729@saruman> <20141009210715.GH25729@saruman> <20141010135743.GB31348@saruman> <20141010162531.GL12379@n2100.arm.linux.org.uk> <54388B81.5020306@mentor.com> <063D6719AE5E284EB5DD2968C1650D6D174C996E@AcuExch.aculab.com> <20141013114307.GO12379@n2100.arm.linux.org.uk> <20141014020640.GB25433@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141014020640.GB25433@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 04:06:40AM +0200, Greg KH wrote:
> On Mon, Oct 13, 2014 at 12:43:07PM +0100, Russell King - ARM Linux wrote:
> > I think the only viable solution here is that:
> > 
> > 1. We blacklist the bad compiler versions outright in the kernel.
> 
> Yes, please do this, it's what we have done for other buggy compiler
> versions, no need to do something different here.
> 
> > Remember, it's the distro's choice to fix these buggy compilers, so the
> > onus is on _them_ to deal with the mess they've created by doing so.
> 
> I totally agree.
> 
> Is someone going to send this patch, or do I have to write it myself?

As I said, I have a patch in progress, but it seems that there needed
to be some discussion about exactly which compiler versions are affected.
It seems that it's not as trivial as looking at the GCC bug entry.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
