Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbaGQMvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:51:43 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:26023 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754731AbaGQMvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:51:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18070lKMh8e/nv6m8bvLuAjl9hwaQRAriQ=
X-DKIM: OpenDKIM Filter v2.0.1 titan CFA615AE26C
Date: Thu, 17 Jul 2014 08:51:31 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: marc.zyngier@arm.com, mark.rutland@arm.com, pawel.moll@arm.com,
        Catalin.Marinas@arm.com, Will.Deacon@arm.com, tglx@linutronix.de,
        Harish.Kasiviswanathan@amd.com, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 0/4 V3] irqchip: gic: Introduce ARM GICv2m MSI(-X)
 support
Message-ID: <20140717125131.GJ13108@titan.lakedaemon.net>
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20140713231431.GM13108@titan.lakedaemon.net>
 <53C3FE7D.3090805@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C3FE7D.3090805@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 10:59:57AM -0500, Suravee Suthikulanit wrote:
> On 7/13/2014 6:14 PM, Jason Cooper wrote:
> >Suravee,
> >
> >On Wed, Jul 09, 2014 at 06:05:00PM -0500, suravee.suthikulpanit@amd.com wrote:
> >>From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> >>
> >>This patch set introduces support for MSI(-X) in GICv2m specification,
> >>which is implemented in some variation of GIC400.
> >>
> >>This depends on and has been tested with the V7 of"Add support for PCI in AArch64"
> >>(https://lkml.org/lkml/2014/3/14/320).
> >
> >Grrr.  I mis-spoke against your v1 of this series.  There are more
> >changes to irq-gic.c than I originally thought in this series.
> 
> I am not quite sure what your are referring to.
> 

No problem, it was an old comment.  If you weren't depending on it then it
doesn't matter. ;-)

> >Additionally, we have a lot of other significant changes to that driver
> >as well this cycle.  It would be really helpful if I could take patches
> >1-3 through irqchip/gic.  I can Ack #4 with the Subject change, and the
> >branch it lands in can depend on irqchip/gic, no problem there.
> 
> Patch 1-3 should be able to go through the irqchip/gic along with
> the gicv3 from Marc, which I have rebased this patch against.

Perfect!

> Patch 4 is arch64 architectural changes.  Therefore, it might need
> to be going through a different branch. Marc/Mark/Will/Catalin, do
> you have any suggestions on which branch this should go to?

Yep, I'll Ack it for arm64 to take, conflicts should be minimal.

thx,

Jason.
