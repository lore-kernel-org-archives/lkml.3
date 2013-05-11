Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab3EKEQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 00:16:17 -0400
Received: from relay3.sgi.com ([192.48.152.1]:36555 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750768Ab3EKEQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 00:16:15 -0400
Date: Fri, 10 May 2013 23:16:10 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Robin Holt <holt@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Russ Anderson <rja@sgi.com>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH -v8 01/11] CPU hotplug: Provide a generic helper to
 disable/enable CPU hotplug
Message-ID: <20130511041610.GZ3672@sgi.com>
References: <1367937595-32241-1-git-send-email-holt@sgi.com>
 <1367937595-32241-2-git-send-email-holt@sgi.com>
 <20130509150121.8c3ef60b2fc748ce542a1a52@linux-foundation.org>
 <1651579.orCh9JNVz6@vostro.rjw.lan>
 <20130510100324.e1e066ab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510100324.e1e066ab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 10:03:24AM -0700, Andrew Morton wrote:
> On Fri, 10 May 2013 13:11:51 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > ...
> >
> > > cpu_hotplug_disable() doesn't get compiled unless we've defined
> > > CONFIG_PM_SLEEP_SMP.  I cannot begin to imagine what the logic is
> > > behind that!
> > 
> > I suppose it was only used by suspend/hibernate code paths when this was
> > introduced.
> 
> OK, well I suspect that what I have now is simply wrong for Robin's
> application.  Robin, can you please check this?  We probably want to
> make the does-something version of cpu_hotplug_disable/enable available
> if CONFIG_HOTPLUG_CPU.

This patch came from "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
I think I need to defer.

I spent all day trying to get an alpha cross compiler to build an
unmodified kernel and modules, only to find I didn't need to go that
far and could reproduce the failure with just building vmlinux.

Sorry for my slow response,
Robin
