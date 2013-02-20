Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935323Ab3BTUuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:50:08 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38432 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935134Ab3BTUuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:50:07 -0500
Date: Wed, 20 Feb 2013 15:49:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Liu, Jinsong" <jinsong.liu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: linux-next: build failure after merge of the xen-two tree
Message-ID: <20130220204941.GC4526@phenom.dumpdata.com>
References: <20130215154551.d11e9d376d30d32b9673e6cc@canb.auug.org.au>
 <11850955.SHqxVBsJqI@vostro.rjw.lan>
 <DE8DF0795D48FD4CA783C40EC82923353FCCAC@SHSMSX101.ccr.corp.intel.com>
 <4696812.SKkpQQd9iW@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4696812.SKkpQQd9iW@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > commit 3757b94802fb65d8f696597a74053cf21738da0b
> > > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > Date:   Wed Feb 13 14:36:47 2013 +0100
> > > 
> > >     ACPI / hotplug: Fix concurrency issues and memory leaks
> > > 
> > > after which acpi_bus_scan() and acpi_bus_trim() have to be run under
> > > acpi_scan_lock (new in my tree as well).
> > 
> > Yes, we noticed that and only need minor updates at xen side, will send out
> > 2 xen patches later accordingly, for cleanup and adding lock.
> 
> Thanks, but those new changes will only make sense after merging the Xen tree
> with the PM tree.  Why don't we queue them up for merging later after both
> the Xen and PM trees have been pulled from?

OK, I've created a branch (http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=shortlog;h=refs/heads/linux-next-resolved)
that has your branch and my branch - along with the fix from Stephan and then
the three updates from Jinsong. Jinsong, please check that I've got all the
right patches. I will rebase it once Linus has merged both of the Xen and PM trees.
