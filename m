Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaKKLO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:14:26 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:57574 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaKKLOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:14:24 -0500
X-IronPort-AV: E=Sophos;i="5.07,360,1413244800"; 
   d="scan'208";a="191515218"
Date: Tue, 11 Nov 2014 11:14:10 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v8 04/13] arm64: introduce is_device_dma_coherent
In-Reply-To: <20141110184226.GI25609@e104818-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1411111110090.26318@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411101607130.22875@kaball.uk.xensource.com> <1415636045-24669-4-git-send-email-stefano.stabellini@eu.citrix.com> <20141110184226.GI25609@e104818-lin.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014, Catalin Marinas wrote:
> On Mon, Nov 10, 2014 at 04:13:56PM +0000, Stefano Stabellini wrote:
> > Introduce a boolean flag and an accessor function to check whether a
> > device is dma_coherent. Set the flag from set_arch_dma_coherent_ops.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> BTW, why do I sign off this patch? As long as it's you as author, I
> don't think you should add my sign-off.

IANAL but as you wrote most of the code in the patch, I think that your
Signed-off-by is required because the lines you wrote are under your
copyright, not mine. TBH for such a small patch, it probably doesn't
matter (there is a limit to what one can claim copyright on).
