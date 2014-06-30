Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaF3S1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:27:33 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:36433 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaF3S1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:27:32 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ER70N5tA6cp4POVJRbmfeQpBt5aVcKrs=
X-DKIM: OpenDKIM Filter v2.0.1 titan C288D59E87B
Date: Mon, 30 Jun 2014 14:27:25 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: marc.zyngier@arm.com, Catalin.Marinas@arm.com, Will.Deacon@arm.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Liviu.Dudau@arm.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] Introduce ARM GICv2m MSI(-X) support
Message-ID: <20140630182725.GZ23978@titan.lakedaemon.net>
References: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20140624122639.GL10202@titan.lakedaemon.net>
 <53AA158E.1040700@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AA158E.1040700@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 07:19:26PM -0500, Suravee Suthikulanit wrote:
> On 6/24/2014 7:26 AM, Jason Cooper wrote:
> >On Mon, Jun 23, 2014 at 07:32:58PM -0500, suravee.suthikulpanit@amd.com wrote:
> >>This patch set introduces support for MSI(-X) in GICv2m specification,
> >>which is implemented in some variation of GIC400.
> >>
> >>This depends on and has been tested with the V7 of "Add support for PCI in AArch64"
> >>(https://lkml.org/lkml/2014/3/14/320).
> >
> >Is this a build, boot, or runtime dependency?
> >
> 
> For all of the above.

Ok, the gic change in #1 should be a trivial conflict to resolve, so
it'll be easiest for you guys to merge this with the other code you have
going into arm-soc.

Just keep me in the Cc and I'll Ack it when it's ready.

thx,

Jason.
