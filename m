Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaABTEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 14:04:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36542 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaABTEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 14:04:10 -0500
Date: Thu, 2 Jan 2014 14:02:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>, boris.ostrovsky@oracle.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        mukesh.rathor@oracle.com
Subject: Re: [PATCH v12] Linux Xen PVH support.
Message-ID: <20140102190256.GH3021@pegasus.dumpdata.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
 <52C598C6.7040902@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C598C6.7040902@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 04:50:14PM +0000, David Vrabel wrote:
> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> > The patches, also available at
> > git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/pvh.v12
> > 
> > implements the neccessary functionality to boot a PV guest in PVH mode.
> 
> In general this looks in much better shape now.  Some of the refactoring
> patches should be queued for 3.14.

<nods> Thank you for your review!
> 
> I'm not sure if when the rest wants to go in given that the PVH
> hypervisor ABI is not yet finalized and is missing support for a number
> of things with no visible plan for how/when/if this missing
> functionality will be implemented.

We could follow the same path that Xen ARM in Linux did.

They put a thick stick in the ground with the caveat that this is
experimental. And we can do the same thing and lift the stick when we
are sure (mostly?) that it all works.

In regards to 'missing how/when/if'. As you can see from the Xen's TODO
there are a quite of items left - AMD support, shadow, etc, so it isn't
just in the kernel.

And on the Linux side things need to be tested out and figured out.

I can't give you an 'when', but the 'how/if' will be addressed. We are
under-staffed so it will take time. I sincerly hope that anybody who is
interested in PVH will help as well.

I presume that the path is going to be similar to how dom0 was
added in Linux - it took a couple of releases before it was OK, and
things have always been added to add that extra 'Uh-oh we forgot that'.
There is still some misisng pieces.

Anyhow that said - I believe this decision should be yours and Boris's.

P.S.
Happy 2014!
