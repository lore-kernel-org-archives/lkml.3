Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3DYIzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:55:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60471 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753862Ab3DYIzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:55:11 -0400
Date: Thu, 25 Apr 2013 09:54:53 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH v4 7/7] mach-virt: support Xen hypercalls for shutdown
 and reboot
Message-ID: <20130425085452.GC12848@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.02.1304242012590.4180@kaball.uk.xensource.com>
 <1366831695-13214-7-git-send-email-stefano.stabellini@eu.citrix.com>
 <alpine.DEB.2.02.1304242301390.4180@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304242301390.4180@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 11:14:28PM +0100, Stefano Stabellini wrote:
> On Wed, 24 Apr 2013, Stefano Stabellini wrote:
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > CC: Marc Zyngier <marc.zyngier@arm.com>
> > CC: will.deacon@arm.com
> > CC: arnd@arndb.de
> > CC: rob.herring@calxeda.com
> 
> Thinking twice about this patch, a less intrusive alternative would be
> to set arm_pm_restart and pm_power_off to two xen specific functions
> later on from xen_guest_init.

Yes please. We'd like to remove mach-virt/* some day.

Will
