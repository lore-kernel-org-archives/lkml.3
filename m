Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406Ab3EBSnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:43:06 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:61141 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761170Ab3EBSnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:43:05 -0400
X-IronPort-AV: E=Sophos;i="4.87,597,1363132800"; 
   d="scan'208";a="21903748"
Date: Thu, 2 May 2013 19:42:58 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Will Deacon <will.deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v10 0/2] (arm-soc for v3.10) arm: introduce
 psci_smp_ops
In-Reply-To: <20130502182812.GD14496@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1305021938170.5398@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304301707290.5398@kaball.uk.xensource.com> <alpine.DEB.2.02.1305021811560.5398@kaball.uk.xensource.com> <20130502171516.GA3040@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1305021816490.5398@kaball.uk.xensource.com>
 <20130502182812.GD14496@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Russell King - ARM Linux wrote:
> On Thu, May 02, 2013 at 06:20:32PM +0100, Stefano Stabellini wrote:
> > On Thu, 2 May 2013, Will Deacon wrote:
> > > Hi Stefano,
> > > 
> > > On Thu, May 02, 2013 at 06:12:12PM +0100, Stefano Stabellini wrote:
> > > > ping
> > > 
> > > Is this a ping to have this pulled into Russell's tree?
> > 
> > I thought that we agreed that the patches should go via the arm-soc
> > tree, after Russell acks them.
> 
> Okay, well, is there a reason for them to go through arm-soc?  They
> look more like core code to me than SoC specific - they only minimally
> touch mach-virt.

The original reason is that some SoC specific code depends on this
series (Calxeda I believe).

But you are probably right, if you prefer that I issue a pull request
for your tree, I have no problems with that.
