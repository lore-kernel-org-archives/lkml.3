Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaACPSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 10:18:45 -0500
Received: from smtp.citrix.com ([66.165.176.89]:27047 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbaACPSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 10:18:44 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="89560727"
Date: Fri, 3 Jan 2014 15:17:55 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Mark Salter <msalter@redhat.com>, <catalin.marinas@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        Chen Baozi <baozich@gmail.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64/xen: redefine xen_remap on arm64
In-Reply-To: <20140103145917.GP7383@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1401031517070.8667@kaball.uk.xensource.com>
References: <1388386511-32276-1-git-send-email-baozich@gmail.com> <1388431259.2564.15.camel@deneb.redhat.com> <alpine.DEB.2.02.1401031310100.8667@kaball.uk.xensource.com> <20140103143104.GN7383@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1401031444550.8667@kaball.uk.xensource.com>
 <20140103145917.GP7383@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jan 2014, Russell King - ARM Linux wrote:
> On Fri, Jan 03, 2014 at 02:49:54PM +0000, Stefano Stabellini wrote:
> > OK. That would be Rob's patch below.
> 
> Looks fine to me.
> 
> > Are you going to take care of sending it to Linus?
> 
> If you want to stick it in the patch system, I'll throw it in my tree.
> I need to push out the next set of fixes soon anyway.
> 
> Thanks.

Done. My first time with the patch system, please be lenient :-)
