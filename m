Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaELP3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:29:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41168 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758512AbaELP3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:29:21 -0400
Date: Mon, 12 May 2014 11:28:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 0/2] dma,x86,xen: fix dma_get_required_mask() when dma !=
 phys address
Message-ID: <20140512152858.GI2837@phenom.dumpdata.com>
References: <1399889742-26165-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399889742-26165-1-git-send-email-david.vrabel@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 11:15:40AM +0100, David Vrabel wrote:
> x86 uses the generic dma_get_required_mask() which assumes that DMA
> address == physical address.  For Xen PV guests this is not the case
> and certain drivers will cause excessive use of the SWIOTLB.
> 
> Patch #1 is a straight forward refactoring of a common function.
> 
> Patch #2 addes the required arch-specific implementation of
> dma_get_required_mask() to x86.

David,

Thank you for taking a look at that. If you would like, you can
tack on Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

And with the *SWIOTLB maintainer hat on - you can add that tag
as well.

Thanks!
> 
> David
> 
