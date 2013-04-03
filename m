Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911Ab3DCIJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:09:07 -0400
Received: from 8bytes.org ([85.214.48.195]:55457 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758678Ab3DCIIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:08:39 -0400
Date: Wed, 3 Apr 2013 10:08:35 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Subject: Re: [PATCH 4/5 v11] iommu/fsl: Add additional iommu attributes
 required by the PAMU driver.
Message-ID: <20130403080835.GW30540@8bytes.org>
References: <1364500442-20927-1-git-send-email-Varun.Sethi@freescale.com>
 <1364500442-20927-5-git-send-email-Varun.Sethi@freescale.com>
 <20130402151011.GH15687@8bytes.org>
 <C5ECD7A89D1DC44195F34B25E172658D45047E@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D45047E@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Apr  3 10:08:37 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 515be38523677961815323
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 05:21:16AM +0000, Sethi Varun-B16395 wrote:
> > I would prefer these PAMU specific enum and struct to be in a pamu-
> > specific iommu-header.
> > 
> 
> [Sethi Varun-B16395] But, these would be used by the IOMMU API users
> (e.g. VFIO), they shouldn't depend on PAMU specific headers.

Drivers that use PAMU specifics (like the PAMU specific VFIO parts) can
also include the PAMU specific header.


	Joerg


