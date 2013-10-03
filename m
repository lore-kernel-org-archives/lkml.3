Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab3JCU03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:26:29 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39263 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab3JCU02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:26:28 -0400
Date: Thu, 3 Oct 2013 16:26:10 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH] iommu: Remove stack trace from broken irq remapping
 warning
Message-ID: <20131003202610.GB20660@hmsreliant.think-freely.org>
References: <1380300815-1864-1-git-send-email-nhorman@tuxdriver.com>
 <20131003172142.GA20660@hmsreliant.think-freely.org>
 <20131003200824.GA17455@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003200824.GA17455@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 10:08:24PM +0200, Joerg Roedel wrote:
> On Thu, Oct 03, 2013 at 01:21:42PM -0400, Neil Horman wrote:
> > On Fri, Sep 27, 2013 at 12:53:35PM -0400, Neil Horman wrote:
> > > The warning for the irq remapping broken check in intel_irq_remapping.c is
> > > pretty pointless.  We need the warning, but we know where its comming from, the
> > > stack trace will always be the same, and it needlessly triggers things like
> > > Abrt.  This changes the warning to just print a text warning about BIOS being
> > > broken, without the stack trace, then sets the appropriate taint bit.  Since we
> > > automatically disable irq remapping, theres no need to contiue making Abrt jump
> > > at this problem
> > > 
> > > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > > CC: Joerg Roedel <joro@8bytes.org>
> > > CC: Bjorn Helgaas <bhelgaas@google.com>
> > > CC: Andy Lutomirski <luto@amacapital.net>
> > > CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > CC: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> > 
> > Ping Bjorn, Jeorg, any thoughts here?
> 
> Yes, the patch is doing the right thing. I have it already on my list
> and will merge it soon.
> 
Awesome, thanks guys.  Regarding the taint, I'll propose something for that
early next week.

Regards
Neil

> 
> 	Joerg
> 
> 
> 
