Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3CDN43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 08:56:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19299 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab3CDN41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 08:56:27 -0500
Date: Mon, 4 Mar 2013 08:56:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: consider tidying up the xen-two tree
Message-ID: <20130304135621.GB13229@phenom.dumpdata.com>
References: <20130304104605.7878c0c7f3d0ba795c9e7384@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130304104605.7878c0c7f3d0ba795c9e7384@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 10:46:05AM +1100, Stephen Rothwell wrote:
> Hi Konrad,
> 
> We are at the end of the merge window and the xen-two tree still looks
> like this:
> 
>  arch/x86/include/asm/xen/interface.h |  11 ++-
>  arch/x86/include/asm/xen/page.h      |   3 +
>  arch/x86/pci/xen.c                   |   9 ++
>  arch/x86/xen/Kconfig                 |   8 ++
>  arch/x86/xen/enlighten.c             |  76 ++++++++++++-----
>  arch/x86/xen/irq.c                   |   5 +-
>  arch/x86/xen/mmu.c                   | 159 ++++++++++++++++++++++++++++++++---
>  arch/x86/xen/mmu.h                   |   2 +
>  arch/x86/xen/p2m.c                   |   2 +-
>  arch/x86/xen/setup.c                 |  59 ++++++++++---
>  arch/x86/xen/smp.c                   |  39 ++++++---
>  arch/x86/xen/xen-head.S              |  10 ++-
>  drivers/net/xen-netback/netback.c    |  11 ++-
>  drivers/xen/balloon.c                |  14 +--
>  drivers/xen/cpu_hotplug.c            |   4 +-
>  drivers/xen/events.c                 |   9 +-
>  drivers/xen/gntdev.c                 |   3 +-
>  drivers/xen/grant-table.c            | 115 +++++++++++++------------
>  drivers/xen/privcmd.c                |   2 +-
>  drivers/xen/xenbus/xenbus_client.c   |   9 +-
>  include/xen/grant_table.h            |  12 ---
>  21 files changed, 422 insertions(+), 140 deletions(-)
> 
> Some of this is from commits going back to December 2011.  And there
> are several duplicate commits (with reversions of old versions) as well
> as many merges.
> 
> I assume that what is left in there is now v3.10 material (or
> bug/regression fixes), so maybe you should take the opportunity and

Yup.

> rebase the whole lot onto v3.9-rc1 when that is released.

Will do. I didn't know that was an OK thing - thought I had to keep the
history behind (so no rebase).

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


