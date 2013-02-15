Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab3BORau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:30:50 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40277 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab3BORat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:30:49 -0500
Date: Fri, 15 Feb 2013 12:30:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: xen-devel <xen-devel@lists.xen.org>, gavin.bowe@oracle.com,
        kurt.hackel@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] What went in Linux 3.6, 3.7 and 3.8 from Xen
 standpoint.
Message-ID: <20130215173041.GB10133@phenom.dumpdata.com>
References: <20130215162651.GB13775@phenom.dumpdata.com>
 <511E74C302000078000BEDB1@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511E74C302000078000BEDB1@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 04:47:47PM +0000, Jan Beulich wrote:
> >>> On 15.02.13 at 17:26, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > v3.7:
> >  - Initial support for ARM working under Xen as both guest and initial 
> > domain.
> >  - Security fixes.
> >  - Fix RCU warning, add fallback code for old hypervisors, fix memory leaks in
> >    gntdev driver, fix some pvops calls failing, Fixes in
> >    xen-[kbd|fb|blk|net|hvc]-backend to deal with CLOSED transition
> >  - Allow xen/privcmd to use v2 of MMAPBATCH command (and fixes for it)
> >  - Support Xen backends to work with paged out grants (meaning work with HVM
> >    guests that have its memory paged out)
> >  - Performance optimization in xen/privcmd for migrating guests.
> >  - Performance improvements when doing kdump for PVonHVM guests.
> >  - Xen DBGP driver added (USB EHCI debug driver)
> >  - FLR support in xen-pciback.
> >  - Support wildcards in xen-pciback.hide=(*) argument parsing.
> >  - Xen EFI support,
> 
> Where?

That should have said Xen VESA EFI support. Thanks for spotting that.

> 
> > and keyboard shift status flag.
> >  - Late usage of Xen-SWIOTLB allowing PV PCI passthrough guest to boot without
> >    'iommu=soft' as an argument and late initialization of SWIOTLB.
> >  - Support more than 128GB in a PV guest.
> >  - Cleanups in the initial pagetable creation.
> 
> Jan
> 
