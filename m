Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab3BORjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:39:19 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50920 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab3BORjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:39:18 -0500
Date: Fri, 15 Feb 2013 12:39:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>, Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: roger.pau@citrix.com, jinsong.liu@intel.com,
        xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Patches for v3.9 for the Linux kernel.
Message-ID: <20130215173904.GC10133@phenom.dumpdata.com>
References: <20130215163451.GD13775@phenom.dumpdata.com>
 <511E761402000078000BEDD8@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511E761402000078000BEDD8@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 04:53:24PM +0000, Jan Beulich wrote:
> >>> On 15.02.13 at 17:34, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > I know that the PVH patches are not in the Xen tree. I am hoping that
> > at least the hypercalls _are_ OK with everybody so we can continue on
> > with this.
> 
> Please don't commit to anything that isn't in the hypervisor tree
> yet. IOW I'd like you to not push the PVH bits that use
> uncommitted hypervisor interfaces (anything preparatory of
> course is okay).

Hm, I believe the only one that was of contention was the 'PHYSDEVOP_map_iomem'
which Mukesh reverted.

The other one is the XENMEM_add_to_physmap_range, which Ian has for ARM.
That is the git commit b6eafa71fa87f4c831e9c2eac736e8ac20b3ea1c
in stable/pvh.v7 tree.

Oh, there is one change in this git commit b8724d6bd1c09e34b6c76b57d07ea4d3fbd8ed4c
..and that gets reverted in 68c5bb99d8b8abbf70b3380bed8eca69648193f5 (by Ian).

So from a hypercall perspective - Ian, is the XENMEM_add_to_physmap_range fully
baked ?
