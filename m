Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab3FFJ3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:29:55 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:5216 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711Ab3FFJ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:29:52 -0400
X-IronPort-AV: E=Sophos;i="4.87,814,1363132800"; 
   d="scan'208";a="5385324"
Message-ID: <1370510990.24512.233.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v4 5/6] arm64/xen: introduce CONFIG_XEN on
 ARM64
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 6 Jun 2013 10:29:50 +0100
In-Reply-To: <20130606092723.GC28479@arm.com>
References: <alpine.DEB.2.02.1306051605030.4589@kaball.uk.xensource.com>
	 <1370451727-26826-5-git-send-email-stefano.stabellini@eu.citrix.com>
	 <1370509419.24512.224.camel@zakaz.uk.xensource.com>
	 <20130606092723.GC28479@arm.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-06 at 10:27 +0100, Catalin Marinas wrote:
> On Thu, Jun 06, 2013 at 10:03:39AM +0100, Ian Campbell wrote:
> > On Wed, 2013-06-05 at 18:02 +0100, Stefano Stabellini wrote:
> > > + * the second in r1/x1, the third in r2/x2 and the fourth in r3/x3.
> > > + * Considering that Xen hypercalls have 5 arguments at most, the fifth
> > > + * paramter is always passed in r4/x4, differently from the ARM
> > > + * procedure calling convention of using the stack for that case.
> > 
> > and "parameter" again.
> > 
> > Strictly speaking the fifth argument handling only differs from the
> > 32-bit PCS, not the 64-bit one. Splitting hairs a bit there.
> 
> I agree, just add "the fifth in x4" without "differently from ...", it's
> not relevant.

Works for me.

> You can also remove references to r? registers, they are only called x?.

This is documenting both the Aarch32 and AArch64 conventions.

Ian.

