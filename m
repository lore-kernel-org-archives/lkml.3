Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab3B0KpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:45:10 -0500
Received: from 8bytes.org ([85.214.48.195]:35808 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756721Ab3B0KpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 05:45:09 -0500
Date: Wed, 27 Feb 2013 11:45:05 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: Stuart Yoder <b08248@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Yoder Stuart-B08248 <B08248@freescale.com>
Subject: Re: [PATCH 2/6] powerpc/fsl_pci: Store the platform device
 information corresponding to the pci controller.
Message-ID: <20130227104505.GE26252@8bytes.org>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
 <1361191939-21260-3-git-send-email-Varun.Sethi@freescale.com>
 <CALRxmdDc9TuxH7HgAF3_iLgatoaOUML6fUt8SU+sxHyz6ZVjfw@mail.gmail.com>
 <C5ECD7A89D1DC44195F34B25E172658D3BD338@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D3BD338@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Feb 27 11:45:07 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 512de3b322972185743725
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 06:16:10AM +0000, Sethi Varun-B16395 wrote:
> This patch is not present in Joerg's tree and the add_device API in
> the PAMU driver requires this patch.

Will this patch be part of v3.9-rc1?


	Joerg


