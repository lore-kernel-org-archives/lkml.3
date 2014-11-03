Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaKCK5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:57:23 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:52017 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaKCK5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:57:21 -0500
Date: Mon, 3 Nov 2014 10:57:16 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH v7 3/8] arm64: introduce is_device_dma_coherent
Message-ID: <20141103105716.GC23162@arm.com>
References: <alpine.DEB.2.02.1410261621200.22875@kaball.uk.xensource.com>
 <1414422568-19103-3-git-send-email-stefano.stabellini@eu.citrix.com>
 <alpine.DEB.2.02.1411031045340.22875@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1411031045340.22875@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 10:46:03AM +0000, Stefano Stabellini wrote:
> On Mon, 27 Oct 2014, Stefano Stabellini wrote:
> > Introduce a boolean flag and an accessor function to check whether a
> > device is dma_coherent. Set the flag from set_arch_dma_coherent_ops.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > CC: will.deacon@arm.com
> 
> Will, Catalin,
> are you OK with this patch?

It would be nicer if the dma_coherent flag didn't have to be duplicated by
each architecture in dev_archdata. Is there any reason not to put it in the
core code?

Will
