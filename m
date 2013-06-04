Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab3FDQ2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:28:47 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52718 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755205Ab3FDQ2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:28:45 -0400
Date: Tue, 4 Jun 2013 17:27:49 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v2 5/5] arm64/xen: introduce CONFIG_XEN and hypercall.S
 on ARM64
Message-ID: <20130604162749.GB25090@arm.com>
References: <alpine.DEB.2.02.1306031157020.4589@kaball.uk.xensource.com>
 <1370273624-26976-5-git-send-email-stefano.stabellini@eu.citrix.com>
 <20130603162517.GC32295@arm.com>
 <20130604144741.GF7110@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604144741.GF7110@phenom.dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 03:47:41PM +0100, Konrad Rzeszutek Wilk wrote:
> > BTW, I think it's missing a MAINTAINERS file update.
> 
> I presume you mean that Stefano should have the MAINTAINERS file updated to include
> him being the maintainer of arch/arm64/xen* ?

Yes (or whoever will maintain Xen for arm64).

-- 
Catalin
