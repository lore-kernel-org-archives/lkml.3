Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab3LRPPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:15:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32736 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab3LRPPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:15:30 -0500
Date: Wed, 18 Dec 2013 10:14:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>, david.vrabel@citrix.com
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] allow xenfb initialization for hvm guests
Message-ID: <20131218151422.GF4934@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1312171738550.8667@kaball.uk.xensource.com>
 <1387367482.27441.123.camel@kazak.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387367482.27441.123.camel@kazak.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 11:51:22AM +0000, Ian Campbell wrote:
> On Tue, 2013-12-17 at 17:53 +0000, Stefano Stabellini wrote:
> > There is no reasons why an HVM guest shouldn't be allowed to use xenfb.
> > As a matter of fact ARM guests, HVM from Linux POV, can use xenfb.
> > Given that no Xen toolstacks configure a xenfb backend for x86 HVM
> > guests, they are not affected.
> 
> and if a toolstack did I think it would be reasonable to expect the
> kernel to at least try and drive it!
> 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Acked-by: Ian Campbell <ian.campbell@citrix.com>

I think David Vrabel is going to Nack it unless there is a test-case.

I am saying that because in his previous statement for Wei's multi-page
patches was that if there are no users (or at least no test-cases) then
it should not be part of the kernel.
