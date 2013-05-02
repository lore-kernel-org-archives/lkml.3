Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641Ab3EBS22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:28:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42816 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759291Ab3EBS21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:28:27 -0400
Date: Thu, 2 May 2013 19:28:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Will Deacon <will.deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v10 0/2] (arm-soc for v3.10) arm: introduce psci_smp_ops
Message-ID: <20130502182812.GD14496@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.02.1304301707290.5398@kaball.uk.xensource.com> <alpine.DEB.2.02.1305021811560.5398@kaball.uk.xensource.com> <20130502171516.GA3040@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1305021816490.5398@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305021816490.5398@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 06:20:32PM +0100, Stefano Stabellini wrote:
> On Thu, 2 May 2013, Will Deacon wrote:
> > Hi Stefano,
> > 
> > On Thu, May 02, 2013 at 06:12:12PM +0100, Stefano Stabellini wrote:
> > > ping
> > 
> > Is this a ping to have this pulled into Russell's tree?
> 
> I thought that we agreed that the patches should go via the arm-soc
> tree, after Russell acks them.

Okay, well, is there a reason for them to go through arm-soc?  They
look more like core code to me than SoC specific - they only minimally
touch mach-virt.
