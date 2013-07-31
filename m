Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511Ab3GaLUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:20:04 -0400
Received: from smtp.citrix.com ([66.165.176.89]:14636 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756267Ab3GaLUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:20:01 -0400
X-IronPort-AV: E=Sophos;i="4.89,786,1367971200"; 
   d="scan'208";a="40439376"
Date: Wed, 31 Jul 2013 12:19:49 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, <xen-devel@lists.xensource.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>
Subject: Re: Replace in linux-next the xen, xen-two, xen-arm with xen/tip.git
 tree instead.
In-Reply-To: <20130731172314.da8bcd6788eaa944a32fc268@canb.auug.org.au>
Message-ID: <alpine.DEB.2.02.1307311219140.4893@kaball.uk.xensource.com>
References: <20130730195316.GA12124@phenom.dumpdata.com> <20130731172314.da8bcd6788eaa944a32fc268@canb.auug.org.au>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jul 2013, Stephen Rothwell wrote:
> Hi Konrad,
> 
> On Tue, 30 Jul 2013 15:53:16 -0400 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> >
> > I was wondering if it would be possible to remove from linux-next
> > the three xen trees and instead use a combined tree, similar to the
> > x86 tip (so the various maintainers share it)?
> > 
> > The ones that would be removed are:
> > 
> > xen		git	git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git#upstream/xen
> > xen-two		git	git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git#linux-next
> > xen-arm		git	git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git#linux-next
> > 
> > And instead it would be pulled from:
> > 
> > xen-tip		git	git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git#linux-next
> > 
> > I presume you need Ack's from all of us (so Jeremy and Stefano) so CC-ing them here.
> 
> I have replaced the xen and xen-two trees with the xen-tip tree today.  I
> will remove the xen-arm tree when I hear from Stefano (as that tree has a
> commit that is not in xen-tip currently).
> 
> The contacts for xen-tip are the contact for both those trees above
> (Jeremy Fitzhardinge <jeremy@goop.org>, Xen Devel
> <Xen-devel@lists.xensource.com>, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com>).  And I will add Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> when I remove the xen-arm tree.
> 
> Let me know if you want changes.

Ack from me too
