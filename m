Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaA3R34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:29:56 -0500
Received: from smtp.citrix.com ([66.165.176.89]:45752 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbaA3R3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:29:45 -0500
X-IronPort-AV: E=Sophos;i="4.95,751,1384300800"; 
   d="scan'208";a="98191900"
Message-ID: <1391102981.9495.46.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH] arm: document "mach-virt" platform.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Marc Zyngier <marc.zyngier@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <Will.Deacon@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 30 Jan 2014 17:29:41 +0000
In-Reply-To: <52EA8AD3.8080904@arm.com>
References: <1391098262-15944-1-git-send-email-ian.campbell@citrix.com>
	  <52EA8853.8080709@arm.com>
	 <1391102475.9495.44.camel@kazak.uk.xensource.com>
	 <52EA8AD3.8080904@arm.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-30 at 17:24 +0000, Marc Zyngier wrote:
> >> I'm afraid I disagree with most of the above. The whole point of
> >> mach-virt is to provide a shell for DT platforms. None of this hardware
> >> is mandated. Instead, all the necessary information should be described
> >> in DT.
> > 
> > "Add support for the smallest, dumbest possible platform, to be
> >  used as a guest for KVM or other hypervisors.
> > 
> >  It only mandates a GIC and architected timers"
> > 
> > (your original commit message :-P)
> 
> Right. 1984, here we come. I'll disappear for a while, rewriting the
> history. More seriously, that was just me scheming to get it merged,
> hiding my cunning plan for mach-virt world domination!

:-)

> >> Actually, mach-virt doesn't really stand for Virtual Machine. It stands
> >> for virtual mach-* directory! Eventually, mach-virt should become the
> >> default platform, the one we use when we don't match anything else in
> >> the kernel
> > 
> > I can word it more like that for sure, along with the alternative
> > wording suggested by Christopher/Stefano to clarify the intent that
> > everything comes from DTB and removal of the specific requirements for
> > GIC/timer/PSCI I think that suit the (new) intention better?
> 
> Yes, please! :-)

OK, I'll come up with an updated version.

Cheers,
Ian.

