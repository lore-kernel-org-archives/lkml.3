Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbaLIPc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:32:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbaLIPc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:32:28 -0500
Date: Tue, 9 Dec 2014 10:32:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, xen-devel@lists.xenproject.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 1/4] dma: add dma_get_required_mask_from_max_pfn()
Message-ID: <20141209153226.GA29841@kroah.com>
References: <1417788483-662-1-git-send-email-david.vrabel@citrix.com>
 <1417788483-662-2-git-send-email-david.vrabel@citrix.com>
 <20141205213113.GB3012@kroah.com>
 <54857F1E.1010506@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54857F1E.1010506@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 10:36:14AM +0000, David Vrabel wrote:
> On 05/12/14 21:31, Greg Kroah-Hartman wrote:
> > On Fri, Dec 05, 2014 at 02:08:00PM +0000, David Vrabel wrote:
> >> A generic dma_get_required_mask() is useful even for architectures (such
> >> as ia64) that define ARCH_HAS_GET_REQUIRED_MASK.
> >>
> >> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> >> Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> >> ---
> >>  drivers/base/platform.c     |   10 ++++++++--
> > 
> > Is this why you sent this to me?  The x86 maintainers should handle this
> > patch set, not me for a tiny 8 lines in just one of the files, sorry.
> 
> This series will be merged via the Xen tree, but this patch still needs
> your review or ack.

How about waiting until after the merge window and resending it, asking
for that, instead of making me guess :)

greg k-h
