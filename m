Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3IXRjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 13:39:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17255 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3IXRjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 13:39:43 -0400
Date: Tue, 24 Sep 2013 13:39:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Rajiv Andrade <mail@srajiv.net>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [PATCH] tpm: xen-tpmfront: Remove the locality sysfs attribute
Message-ID: <20130924173907.GD14176@phenom.dumpdata.com>
References: <20130923205415.GC16345@obsidianresearch.com>
 <5240B022.70000@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5240B022.70000@tycho.nsa.gov>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 05:18:26PM -0400, Daniel De Graaf wrote:
> On 09/23/2013 04:54 PM, Jason Gunthorpe wrote:
> >Upon deeper review it was agreed to remove the driver-unique
> >'locality' sysfs attribute before it is present in a released
> >kernel.
> >
> >The attribute was introduced in e2683957fb268c6b29316fd9e7191e13239a30a5
> >during the 3.12 merge window, so this patch needs to go in before
> >3.12 is released.
> >
> >The hope is to have a well defined locality API that all the other
> >locality aware drivers can use, perhaps in 3.13.
> >
> >Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> >---
> >  drivers/char/tpm/xen-tpmfront.c | 29 -----------------------------
> >  1 file changed, 29 deletions(-)
> >
> >Daniel, if you can Ack this..
> 
> Acked-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
> 
> >Konrad: This driver was originally merged through you, can you
> >pick this up?

Sure thing. Thank you!
