Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3DVOX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:23:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36313 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3DVOX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:23:27 -0400
Date: Mon, 22 Apr 2013 15:23:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 1/4] arm: introduce psci_smp_ops
Message-ID: <20130422142318.GL14496@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <1365167495-18508-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130418161341.GB14496@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1304181714560.7254@kaball.uk.xensource.com> <alpine.LFD.2.03.1304181233580.17375@syhkavp.arg> <alpine.DEB.2.02.1304181748010.7254@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304181748010.7254@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 05:49:21PM +0100, Stefano Stabellini wrote:
> On Thu, 18 Apr 2013, Nicolas Pitre wrote:
> > Please let's keep the order as we discussed.  Otherwise this is just too 
> > confusing (Russell's comment is a good example of that).
> 
> You are right, it is confusing.
> By "keep the order as we discussed", do you mean merge the second patch
> into the first one, correct?

Well, the solution to this kind of confusion is to ignore comments on the
older patches and post a new set of patches and ask for all relevant
comments to be against that set and that set only.
