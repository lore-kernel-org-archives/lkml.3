Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab3DYHsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 03:48:30 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:10855 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3DYHs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 03:48:29 -0400
X-IronPort-AV: E=Sophos;i="4.87,548,1363132800"; 
   d="scan'208";a="3914159"
Message-ID: <1366876106.20256.399.camel@zakaz.uk.xensource.com>
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
Date: Thu, 25 Apr 2013 08:48:26 +0100
In-Reply-To: <alpine.LFD.2.03.1304221151200.17375@syhkavp.arg>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com>
	 <1365167495-18508-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <20130418161341.GB14496@n2100.arm.linux.org.uk>
	 <alpine.DEB.2.02.1304181714560.7254@kaball.uk.xensource.com>
	 <alpine.LFD.2.03.1304181237480.17375@syhkavp.arg>
	 <alpine.DEB.2.02.1304181749260.7254@kaball.uk.xensource.com>
	 <alpine.LFD.2.03.1304181336280.17375@syhkavp.arg>
	 <alpine.DEB.2.02.1304191035360.7254@kaball.uk.xensource.com>
	 <alpine.LFD.2.03.1304191146230.17375@syhkavp.arg>
	 <1366388166.29403.2.camel@dagon.hellion.org.uk>
	 <alpine.LFD.2.03.1304191223280.17375@syhkavp.arg>
	 <alpine.DEB.2.02.1304191739120.7254@kaball.uk.xensource.com>
	 <1366644069.20256.8.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.03.1304221151200.17375@syhkavp.arg>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-22 at 17:07 +0100, Nicolas Pitre wrote:
> Sure there are ways to screw up Xen support from within this hook, but 
> that can be achieved in many other places.  Will Xen take over every 
> possible hooks in the kernel to prevent that from happening?

In the majority of the other cases we would consider it a bug in Xen for
not exposing these bits of the underlying hardware correctly to dom0,
however the SMP stuff is a bit of a special case for the reasons I
explained earlier which is why we are worrying about it more.

> So please let's not cry wolf needlessly.

Yes, perhaps those worries unfounded at this stage and we should just
run with it and reference this discussion if it turns out to not work
out well in practice.

Ian.

