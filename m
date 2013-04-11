Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab3DKIZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:25:24 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:49864 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab3DKIZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:25:21 -0400
Date: Thu, 11 Apr 2013 01:25:19 -0700
From: Olof Johansson <olof@lixom.net>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH 0/4 v6] arm: introduce psci_smp_ops and use them on Xen
Message-ID: <20130411082519.GD31465@quad.lixom.net>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1304081102500.5353@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304081102500.5353@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 12:05:17PM +0100, Stefano Stabellini wrote:
> Arnd, Olof,
> do you have any thoughts on this series?
> Would you be happy to carry it in the arm-soc tree?
> 
> The last patch, "xen/arm: introduce xen_early_init, use PSCI on xen" has
> a (small) dependency on this series:
> 
> http://marc.info/?l=linux-kernel&m=136430893610688&w=2
> 
> would you be OK with taking that one too, or should that go through the
> Xen tree?

I think it'd make sense to get Russell to ack the changes to the core ARM code.
We can merge the series through arm-soc, or he can take them, whatever is
easiest for everybody.

Given the dependencies on the second branch it might be easier to merge
through Russell's tree.


-Olof
