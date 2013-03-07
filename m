Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab3CGKhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:37:48 -0500
Received: from 8bytes.org ([85.214.48.195]:48346 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382Ab3CGKhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:37:45 -0500
Date: Thu, 7 Mar 2013 11:37:41 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: Stuart Yoder <b08248@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 2/6] powerpc/fsl_pci: Store the platform device
 information corresponding to the pci controller.
Message-ID: <20130307103741.GB22602@8bytes.org>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
 <1361191939-21260-3-git-send-email-Varun.Sethi@freescale.com>
 <CALRxmdDc9TuxH7HgAF3_iLgatoaOUML6fUt8SU+sxHyz6ZVjfw@mail.gmail.com>
 <C5ECD7A89D1DC44195F34B25E172658D3BD338@039-SN2MPN1-013.039d.mgd.msft.net>
 <20130227104505.GE26252@8bytes.org>
 <C5ECD7A89D1DC44195F34B25E172658D3C24A9@039-SN2MPN1-013.039d.mgd.msft.net>
 <D109CC7C-09D2-41E6-82BF-376692C390CA@kernel.crashing.org>
 <C5ECD7A89D1DC44195F34B25E172658D3E74C7@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D3E74C7@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Mar  7 11:37:43 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51386df723671036012166
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, please base your patches on the latest upstream-tag. I will move my
tree to v3.9-rc1 soon, there are some fixes that need to go upstream.

On Thu, Mar 07, 2013 at 09:14:21AM +0000, Sethi Varun-B16395 wrote:
> Hi Joerg,
> I have to post the next version of my patchset, should I base it on top of 3.9-rc1?
> By when would you move the iommu git tree to 3.9-rc1?
> 
> Regards
> Varun
> 
> > -----Original Message-----
> > From: Kumar Gala [mailto:galak@kernel.crashing.org]
> > Sent: Thursday, February 28, 2013 9:15 PM
> > To: Sethi Varun-B16395
> > Cc: Joerg Roedel; Stuart Yoder; iommu@lists.linux-foundation.org;
> > linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Wood Scott-
> > B07421; Yoder Stuart-B08248
> > Subject: Re: [PATCH 2/6] powerpc/fsl_pci: Store the platform device
> > information corresponding to the pci controller.
> > 
> > 
> > On Feb 27, 2013, at 4:56 AM, Sethi Varun-B16395 wrote:
> > 
> > > This patch is present in the "next branch" of linux ppc tree maintained
> > by Kumar Gala.
> > > Following is the commit id:
> > > 52c5affc545053d37c0b05224bbf70f5336caa20
> > >
> > > I am not sure if this would be part of 3.9-rc1.
> > >
> > > Regards
> > > varun
> > 
> > This is now in Linus's tree so will be in 3.9-rc1
> > 
> > - k
> > 
> 
> 

