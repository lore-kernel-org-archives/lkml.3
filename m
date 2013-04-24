Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab3DXKvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:51:23 -0400
Received: from 8bytes.org ([85.214.48.195]:55856 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758607Ab3DXKvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:51:22 -0400
Date: Wed, 24 Apr 2013 12:51:18 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>
Subject: Re: [PATCH 2/3 v14] iommu/fsl: Add additional iommu attributes
 required by the PAMU driver.
Message-ID: <20130424105117.GI17148@8bytes.org>
References: <1366691726-9023-1-git-send-email-Varun.Sethi@freescale.com>
 <1366691726-9023-2-git-send-email-Varun.Sethi@freescale.com>
 <20130423133837.GG17148@8bytes.org>
 <C5ECD7A89D1DC44195F34B25E172658D4B4D9A@039-SN2MPN1-011.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D4B4D9A@039-SN2MPN1-011.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Apr 24 12:51:20 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5177b92823671913340423
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 02:10:25PM +0000, Sethi Varun-B16395 wrote:
> I think it's fine to have the header under linux, actually I also the
> intel-iommu header under linux.

Yes, the difference is that VT-d runs on x86 and on ia64. So there is no
single arch where the header could be placed. The amd-iommu.h file on
the other hand is x86 only and should also be moved to asm/, as I just
found out :)

And as long as PAMU is only needed on a single architecture the header
should also be arch-specific. If that changes someday the header can be
moved to a generic place.


	Joerg


