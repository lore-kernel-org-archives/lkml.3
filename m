Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123Ab3KHTko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:40:44 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42538 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740Ab3KHTkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:40:42 -0500
Date: Fri, 8 Nov 2013 19:38:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
Subject: Re: swiotlb on arm status
Message-ID: <20131108193815.GU16735@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.02.1311061245580.26077@kaball.uk.xensource.com> <alpine.DEB.2.02.1311081854530.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311081854530.26077@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 06:56:43PM +0000, Stefano Stabellini wrote:
> Russell,
> sorry to harass you again, but I am starting to be worried about missing
> the merge window. Could you please take a last look at these patches?

Well, as far as this patch goes, yes it's fine.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

But I wonder what's happening with xgmac?  Will it get fixed?
