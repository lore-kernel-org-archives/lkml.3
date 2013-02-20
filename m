Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202Ab3BTVR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:17:57 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40442 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab3BTVR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:17:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "Liu, Jinsong" <jinsong.liu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: linux-next: build failure after merge of the xen-two tree
Date: Wed, 20 Feb 2013 22:24:33 +0100
Message-ID: <1408464.udoD1aPUGq@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130220204941.GC4526@phenom.dumpdata.com>
References: <20130215154551.d11e9d376d30d32b9673e6cc@canb.auug.org.au> <4696812.SKkpQQd9iW@vostro.rjw.lan> <20130220204941.GC4526@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2013 03:49:41 PM Konrad Rzeszutek Wilk wrote:
> > > > commit 3757b94802fb65d8f696597a74053cf21738da0b
> > > > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > Date:   Wed Feb 13 14:36:47 2013 +0100
> > > > 
> > > >     ACPI / hotplug: Fix concurrency issues and memory leaks
> > > > 
> > > > after which acpi_bus_scan() and acpi_bus_trim() have to be run under
> > > > acpi_scan_lock (new in my tree as well).
> > > 
> > > Yes, we noticed that and only need minor updates at xen side, will send out
> > > 2 xen patches later accordingly, for cleanup and adding lock.
> > 
> > Thanks, but those new changes will only make sense after merging the Xen tree
> > with the PM tree.  Why don't we queue them up for merging later after both
> > the Xen and PM trees have been pulled from?
> 
> OK, I've created a branch (http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=shortlog;h=refs/heads/linux-next-resolved)
> that has your branch and my branch - along with the fix from Stephan and then
> the three updates from Jinsong. Jinsong, please check that I've got all the
> right patches. I will rebase it once Linus has merged both of the Xen and PM trees.

Thanks, this looks good.

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
