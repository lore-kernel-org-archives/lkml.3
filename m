Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab3BOQfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:35:03 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47547 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292Ab3BOQfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:35:02 -0500
Date: Fri, 15 Feb 2013 11:34:51 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Mukesh Rathor <mukesh.rathor@oracle.com>, roger.pau@citrix.com,
        jinsong.liu@intel.com
Subject: Patches for v3.9 for the Linux kernel.
Message-ID: <20130215163451.GD13775@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The v3.8 is going to be released soon. The patches that I have in
my tree that I was thinking to push for v3.9 are:

If I am missing anything pls tell me.


Alexander Duyck (1):
      x86/xen: Use __pa_symbol instead of __pa on C visible symbols

Dan Carpenter (1):
      xen/privcmd: fix condition in privcmd_close()

Ian Campbell (2):
      xen: x86 pvh: use XENMEM_add_to_physmap_range for foreign gmfn mappings
      xen: implement updated XENMEM_add_to_physmap_range ABI

Konrad Rzeszutek Wilk (5):
      xen/smp: Move the common CPU init code a bit to prep for PVH patch.
      Merge branch 'stable/pvh.v7' into stable/for-linus-3.9
      Revert "xen/pvh linux: Use ballooning to allocate grant table pages"
      Merge branch 'stable/pvh.v7' into stable/for-linus-3.9
      Merge branch 'stable/for-linus-3.9' into HEAD

Liu Jinsong (6):
      xen/stub: driver for memory hotplug
      xen/acpi: ACPI memory hotplug
      xen/stub: driver for CPU hotplug
      xen/acpi: Move xen_acpi_get_pxm to Xen's acpi.h
      xen/acpi: ACPI cpu hotplug
      xen/acpi: move xen_acpi_get_pxm under CONFIG_XEN_DOM0

Mukesh Rathor (9):
      xen/pvh: Support ParaVirtualized Hardware extensions.
      xen/pvh: Extend vcpu_guest_context, p2m, event, and XenBus.
      xen/pvh: Implement MMU changes for PVH.
      xen/pvh: bootup and setup (E820) related changes.
      xen/pvh: balloon and grant changes.
      xen/pvh: specify xen features strings cleanly for PVH
      xen/pvh: remove code to map iomem from guest
      xen/pvh linux: Use ballooning to allocate grant table pages
      xen/pvh: Use ballooning to allocate grant table pages [v2]

Wei Yongjun (1):
      xen/x86: remove duplicated include from enlighten.c


I know that the PVH patches are not in the Xen tree. I am hoping that
at least the hypercalls _are_ OK with everybody so we can continue on
with this.

There are some patches in the for-jens-3.8 tree that will be
part of the v3.9:

Jan Beulich (1):
      xen-blkback: do not leak mode property

Konrad Rzeszutek Wilk (3):
      xen/blkback: Don't trust the handle from the frontend.
      xen-blkfront: drop the use of llist_for_each_entry_safe
      Merge branch 'stable/for-jens-3.8' into HEAD

Roger Pau Monne (1):
      xen-blkback: use balloon pages for persistent grants

