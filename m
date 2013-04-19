Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab3DSQQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:16:10 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:51525 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab3DSQQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:16:08 -0400
X-IronPort-AV: E=Sophos;i="4.87,510,1363132800"; 
   d="scan'208";a="3748829"
Message-ID: <1366388166.29403.2.camel@dagon.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH v6 1/4] arm: introduce psci_smp_ops
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 19 Apr 2013 17:16:06 +0100
In-Reply-To: <alpine.LFD.2.03.1304191146230.17375@syhkavp.arg>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com>
	 <1365167495-18508-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <20130418161341.GB14496@n2100.arm.linux.org.uk>
	 <alpine.DEB.2.02.1304181714560.7254@kaball.uk.xensource.com>
	 <alpine.LFD.2.03.1304181237480.17375@syhkavp.arg>
	 <alpine.DEB.2.02.1304181749260.7254@kaball.uk.xensource.com>
	 <alpine.LFD.2.03.1304181336280.17375@syhkavp.arg>
	 <alpine.DEB.2.02.1304191035360.7254@kaball.uk.xensource.com>
	 <alpine.LFD.2.03.1304191146230.17375@syhkavp.arg>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-19 at 16:47 +0100, Nicolas Pitre wrote:
> No one should be probing registers without making sure it is safe to do 
> so.  Even on non virtualized hardware this can be a dangerous thing to 
> do.

Won't people writing per machine code consider, not unreasonably, that
having been called through a mdesc machine specific hook constitutes
enough "making sure" that they think it is safe to touch registers which
are specific to that machine?

Ian.

