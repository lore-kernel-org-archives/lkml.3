Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbaKTKtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:49:04 -0500
Received: from smtp.citrix.com ([66.165.176.89]:25228 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788AbaKTKtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:49:01 -0500
X-IronPort-AV: E=Sophos;i="5.07,423,1413244800"; 
   d="scan'208";a="193219942"
Date: Thu, 20 Nov 2014 10:39:32 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, <david.vrabel@citrix.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <catalin.marinas@arm.com>
Subject: Re: [PATCH v9 05/13] arm: introduce is_device_dma_coherent
In-Reply-To: <20141120000736.GN4042@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1411201036400.12596@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411121130020.26318@kaball.uk.xensource.com> <1415792454-23161-5-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1411141158560.26318@kaball.uk.xensource.com> <alpine.DEB.2.02.1411181649000.27247@kaball.uk.xensource.com>
 <20141120000736.GN4042@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014, Russell King - ARM Linux wrote:
> On Tue, Nov 18, 2014 at 04:49:21PM +0000, Stefano Stabellini wrote:
> > ping?
> 
> Sending something which wants my attention _To:_ me is always a good idea :)

I'll keep that in mind :-)


> The patch is fine in itself, but I have a niggle about the
> is_device_dma_coherent() - provided this is only used in architecture
> specific code, that should be fine.  It could probably do with a comment
> to that effect in an attempt to discourage drivers using it (thereby
> becoming less portable to other architectures.)

Can I take this as an Acked-by?
Good point regarding the comment. Maybe I can add:

/* do not use this function in a driver */
