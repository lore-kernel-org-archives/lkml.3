Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3BOQrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:47:53 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:35766 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab3BOQrw convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 15 Feb 2013 11:47:52 -0500
Message-Id: <511E74C302000078000BEDB1@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Fri, 15 Feb 2013 16:47:47 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <gavin.bowe@oracle.com>,
        <kurt.hackel@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] What went in Linux 3.6, 3.7 and 3.8 from Xen
 standpoint.
References: <20130215162651.GB13775@phenom.dumpdata.com>
In-Reply-To: <20130215162651.GB13775@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 15.02.13 at 17:26, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> v3.7:
>  - Initial support for ARM working under Xen as both guest and initial 
> domain.
>  - Security fixes.
>  - Fix RCU warning, add fallback code for old hypervisors, fix memory leaks in
>    gntdev driver, fix some pvops calls failing, Fixes in
>    xen-[kbd|fb|blk|net|hvc]-backend to deal with CLOSED transition
>  - Allow xen/privcmd to use v2 of MMAPBATCH command (and fixes for it)
>  - Support Xen backends to work with paged out grants (meaning work with HVM
>    guests that have its memory paged out)
>  - Performance optimization in xen/privcmd for migrating guests.
>  - Performance improvements when doing kdump for PVonHVM guests.
>  - Xen DBGP driver added (USB EHCI debug driver)
>  - FLR support in xen-pciback.
>  - Support wildcards in xen-pciback.hide=(*) argument parsing.
>  - Xen EFI support,

Where?

> and keyboard shift status flag.
>  - Late usage of Xen-SWIOTLB allowing PV PCI passthrough guest to boot without
>    'iommu=soft' as an argument and late initialization of SWIOTLB.
>  - Support more than 128GB in a PV guest.
>  - Cleanups in the initial pagetable creation.

Jan

