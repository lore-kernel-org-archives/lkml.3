Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab3FDOsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:48:20 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38758 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab3FDOsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:48:16 -0400
Date: Tue, 4 Jun 2013 10:47:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v2 5/5] arm64/xen: introduce CONFIG_XEN and hypercall.S
 on ARM64
Message-ID: <20130604144741.GF7110@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1306031157020.4589@kaball.uk.xensource.com>
 <1370273624-26976-5-git-send-email-stefano.stabellini@eu.citrix.com>
 <20130603162517.GC32295@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603162517.GC32295@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW, I think it's missing a MAINTAINERS file update.

I presume you mean that Stefano should have the MAINTAINERS file updated to include
him being the maintainer of arch/arm64/xen* ?

