Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab3LMOby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:31:54 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47499 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab3LMObv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:31:51 -0500
Date: Fri, 13 Dec 2013 09:30:39 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, george.dunlap@eu.citrix.com,
        tim@xen.org, ian.jackson@eu.citrix.com, linux-kernel@vger.kernel.org,
        jbeulich@suse.com, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com
Subject: Re: [Xen-devel] [PATCH v10] Repost of PVH patches for Linux.
Message-ID: <20131213143039.GF2923@phenom.dumpdata.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
 <52AAF176.3020102@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AAF176.3020102@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 11:37:26AM +0000, David Vrabel wrote:
> On 13/12/13 02:10, Konrad Rzeszutek Wilk wrote:
> > Hey,
> > 
> > Mukesh had posted them quite a while ago - they got reviewed, acked, etc,
> > put in #linux-next, got patches to fix some things from folks.
> > 
> > Then everybody focused on the Xen patches .. and now that is mostly
> > baked this is what is needed on the Linux side to make it work
> > with PVH. I had them based on v3.6, then merged on v3.11, then..
> > 
> > Decided to rebase all of them on v3.13-rc3 to make it easier.
> 
> In general the series is a bit of mess, early patches doing things one
> way (using hypercalls that no longer exist for example) and later
> patches fixing things up.  I think this should be sorted out as it makes
> it too difficult to review carefully (I've only given the series a
> quick, initial review).

I need from Mukesh the follow on patches that "fix" this
so I can rebase, squash, etc them them up a bit to make it easier.


> 
> > Couple of things:
> > 
> > a) the patch:
> >  [PATCH V10 14/14] xen/pvh: vcpu info placement, load CS selector,
> > 
> > could be split in three - and I think Mukesh did have a version like that.
> > I can do it myself and will - it should be obvious of how it will be done.
> > 
> > b). Regression testing  - I ran this with a Linux kernel dom0 (32 and 64)
> >     on the latest Xen hypervisor without PVH enabled. It booted all the
> >     guests I had:
> >     RHEL5, SLES11, SLES12, F15, F16, F17, F18, F19, OEL5, OEL6, NetBSD PV,
> >     FreeBSD HVM; and also 32 and 64 PV and PVHVM combination of the same
> >     kernel (and save/restore on those). Nothing broke.
> 
> That's good to know.
> 
> David
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
