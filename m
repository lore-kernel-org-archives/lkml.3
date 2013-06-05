Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3FENWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:22:07 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:47673 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754061Ab3FENWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:22:05 -0400
Date: Wed, 5 Jun 2013 14:21:17 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 5/5] arm64/xen: introduce CONFIG_XEN and hypercall.S
 on ARM64
Message-ID: <20130605132117.GK8758@arm.com>
References: <alpine.DEB.2.02.1306031157020.4589@kaball.uk.xensource.com>
 <1370273624-26976-5-git-send-email-stefano.stabellini@eu.citrix.com>
 <20130603162517.GC32295@arm.com>
 <alpine.DEB.2.02.1306031745460.4589@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306031745460.4589@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 05:51:53PM +0100, Stefano Stabellini wrote:
> On Mon, 3 Jun 2013, Catalin Marinas wrote:
> > Otherwise, the series looks good. How do you plan to upstream this?
> 
> Good question.
> Traditionally Xen stuff goes to Linus directly via one of the Xen trees
> (Konrad's or mine), but since this is the very first Xen patch series
> for arm64 if you prefer I can submit a pull request to you instead.
> Just let me know, I am happy either way.

I can take the first series and subsequent merges can go via the Xen
tree (KVM has a similar approach).

> In any case, are you OK with sending it upstream during the next merge
> window?

Yes, if I get a pull request in time ;)

-- 
Catalin
