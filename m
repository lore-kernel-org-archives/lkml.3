Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761212Ab3EBRUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:20:41 -0400
Received: from smtp.citrix.com ([66.165.176.89]:17420 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761164Ab3EBRUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:20:38 -0400
X-IronPort-AV: E=Sophos;i="4.87,597,1363132800"; 
   d="scan'208";a="22965750"
Date: Thu, 2 May 2013 18:20:32 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Will Deacon <will.deacon@arm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v10 0/2] (arm-soc for v3.10) arm: introduce
 psci_smp_ops
In-Reply-To: <20130502171516.GA3040@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1305021816490.5398@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304301707290.5398@kaball.uk.xensource.com> <alpine.DEB.2.02.1305021811560.5398@kaball.uk.xensource.com> <20130502171516.GA3040@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Will Deacon wrote:
> Hi Stefano,
> 
> On Thu, May 02, 2013 at 06:12:12PM +0100, Stefano Stabellini wrote:
> > ping
> 
> Is this a ping to have this pulled into Russell's tree?

I thought that we agreed that the patches should go via the arm-soc
tree, after Russell acks them.

The ping is for Russell to ack them and Arnd to merge them.


> If so, might be
> worth sending a pull request to linux+pull@arm.linux.org.uk.
> 
> Has this been in -next?

Yes they have, because I temporarily added them to my branch in
linux-next.
In fact Stephen found and solved a merge conflict here:

http://marc.info/?l=linux-arm-kernel&m=136722292031420&w=2
