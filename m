Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591Ab3HNJgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:36:17 -0400
Received: from 8bytes.org ([85.214.48.195]:50089 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972Ab3HNJgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:36:15 -0400
Date: Wed, 14 Aug 2013 11:36:12 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: WARNING: at drivers/iommu/dmar.c:484 warn_invalid_dmar with
 Intel Motherboard
Message-ID: <20130814093607.GB4491@8bytes.org>
References: <20130709202406.GA11867@roeck-us.net>
 <CAErSpo6Ma1TnBP-UGGhWFN1rj48y+yTS=VmVw_s30_FWgjfdpg@mail.gmail.com>
 <20130709223106.GA16429@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709223106.GA16429@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Aug 14 11:36:14 2013
X-DSPAM-Confidence: 0.9981
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 520b4f8e20861707060788
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 03:31:06PM -0700, Guenter Roeck wrote:
> On Tue, Jul 09, 2013 at 03:05:39PM -0600, Bjorn Helgaas wrote:
> > [+cc Joerg, David, iommu list]
> > 
> > On Tue, Jul 9, 2013 at 2:24 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > > I started seeing this problem after updating the BIOS trying fix another issue,
> > > though I may have missed it earlier.
> > >
> > > I understand this is a BIOS bug. Would be great if someone can pass this on
> > > to Intel BIOS engineers.
> > 
> > Maybe.  It'd be nice if Linux handled it better, though.
> > 
> If anyone has an idea how to do that, I'll be happy to write a patch.

I doubt that we can do anything meaningful here. The BIOS is broken in a
way so that we can't use the IOMMU in Linux. We can patch away the
WARN_ON and make it a sumple FW_BUG message, but the noise a WARN_ON
makes maybe help getting this issue fixed.

But I may be convinced otherwise, if people think this WARN_ON is not
worth it.


	Joerg


