Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab3KHToF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:44:05 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:34083 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757537Ab3KHToD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:44:03 -0500
X-IronPort-AV: E=Sophos;i="4.93,661,1378857600"; 
   d="scan'208";a="69701934"
Date: Fri, 8 Nov 2013 19:42:42 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>
Subject: Re: swiotlb on arm status
In-Reply-To: <20131108193815.GU16735@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1311081942090.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1311061245580.26077@kaball.uk.xensource.com> <alpine.DEB.2.02.1311081854530.26077@kaball.uk.xensource.com> <20131108193815.GU16735@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Nov 2013, Russell King - ARM Linux wrote:
> On Fri, Nov 08, 2013 at 06:56:43PM +0000, Stefano Stabellini wrote:
> > Russell,
> > sorry to harass you again, but I am starting to be worried about missing
> > the merge window. Could you please take a last look at these patches?
> 
> Well, as far as this patch goes, yes it's fine.
> 
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
 
Thank you!!


> But I wonder what's happening with xgmac?  Will it get fixed?
> 

Rob sent a patch to fix it. I tested it and it works.
