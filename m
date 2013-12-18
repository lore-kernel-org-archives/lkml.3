Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab3LRP23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:28:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31918 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3LRP22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:28:28 -0500
Date: Wed, 18 Dec 2013 10:27:19 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>, david.vrabel@citrix.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] allow xenfb initialization for hvm guests
Message-ID: <20131218152719.GI4934@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1312171738550.8667@kaball.uk.xensource.com>
 <1387367482.27441.123.camel@kazak.uk.xensource.com>
 <20131218151422.GF4934@phenom.dumpdata.com>
 <alpine.DEB.2.02.1312181517400.8667@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312181517400.8667@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 03:18:45PM +0000, Stefano Stabellini wrote:
> On Wed, 18 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > On Wed, Dec 18, 2013 at 11:51:22AM +0000, Ian Campbell wrote:
> > > On Tue, 2013-12-17 at 17:53 +0000, Stefano Stabellini wrote:
> > > > There is no reasons why an HVM guest shouldn't be allowed to use xenfb.
> > > > As a matter of fact ARM guests, HVM from Linux POV, can use xenfb.
> > > > Given that no Xen toolstacks configure a xenfb backend for x86 HVM
> > > > guests, they are not affected.
> > > 
> > > and if a toolstack did I think it would be reasonable to expect the
> > > kernel to at least try and drive it!
> > > 
> > > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > 
> > > Acked-by: Ian Campbell <ian.campbell@citrix.com>
> > 
> > I think David Vrabel is going to Nack it unless there is a test-case.
> > 
> > I am saying that because in his previous statement for Wei's multi-page
> > patches was that if there are no users (or at least no test-cases) then
> > it should not be part of the kernel.
> 
> Well there is one: ARM. There isn't one on x86.
> 
> http://marc.info/?l=xen-devel&m=138730150806639&w=2

Ah I missed that. I think that this particular patch can wait till the
next merge window?

Would it make sense to have the XenFB also work on x86? Is it difficult
to make it work on it?
