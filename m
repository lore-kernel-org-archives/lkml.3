Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3DYKOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 06:14:49 -0400
Received: from smtp.citrix.com ([66.165.176.89]:43036 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab3DYKOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:14:48 -0400
X-IronPort-AV: E=Sophos;i="4.87,548,1363132800"; 
   d="scan'208";a="21497930"
Date: Thu, 25 Apr 2013 11:14:43 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Will Deacon <will.deacon@arm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH v4 7/7] mach-virt: support Xen hypercalls for shutdown
 and reboot
In-Reply-To: <20130425085452.GC12848@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1304251114280.4180@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304242012590.4180@kaball.uk.xensource.com> <1366831695-13214-7-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1304242301390.4180@kaball.uk.xensource.com> <20130425085452.GC12848@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Will Deacon wrote:
> On Wed, Apr 24, 2013 at 11:14:28PM +0100, Stefano Stabellini wrote:
> > On Wed, 24 Apr 2013, Stefano Stabellini wrote:
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > CC: Marc Zyngier <marc.zyngier@arm.com>
> > > CC: will.deacon@arm.com
> > > CC: arnd@arndb.de
> > > CC: rob.herring@calxeda.com
> > 
> > Thinking twice about this patch, a less intrusive alternative would be
> > to set arm_pm_restart and pm_power_off to two xen specific functions
> > later on from xen_guest_init.
> 
> Yes please. We'd like to remove mach-virt/* some day.

I'll do
