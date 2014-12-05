Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaLEVbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:31:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaLEVbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:31:14 -0500
Date: Fri, 5 Dec 2014 13:31:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, xen-devel@lists.xenproject.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 1/4] dma: add dma_get_required_mask_from_max_pfn()
Message-ID: <20141205213113.GB3012@kroah.com>
References: <1417788483-662-1-git-send-email-david.vrabel@citrix.com>
 <1417788483-662-2-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417788483-662-2-git-send-email-david.vrabel@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 02:08:00PM +0000, David Vrabel wrote:
> A generic dma_get_required_mask() is useful even for architectures (such
> as ia64) that define ARCH_HAS_GET_REQUIRED_MASK.
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  drivers/base/platform.c     |   10 ++++++++--

Is this why you sent this to me?  The x86 maintainers should handle this
patch set, not me for a tiny 8 lines in just one of the files, sorry.

greg k-h
