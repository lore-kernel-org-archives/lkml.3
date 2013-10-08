Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab3JHRCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 13:02:36 -0400
Received: from 8bytes.org ([85.214.48.195]:36584 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab3JHRCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 13:02:33 -0400
Date: Tue, 8 Oct 2013 19:02:28 +0200
From: "joro@8bytes.org" <joro@8bytes.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Bhushan Bharat-R65777 <R65777@freescale.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH 1/7] powerpc: Add interface to get msi region information
Message-ID: <20131008170228.GD17455@8bytes.org>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
 <1379575763-2091-2-git-send-email-Bharat.Bhushan@freescale.com>
 <20130924235812.GD9302@google.com>
 <6A3DF150A5B70D4F9B66A25E3F7C888D0718FA58@039-SN2MPN1-011.039d.mgd.msft.net>
 <CAErSpo742BOxzxRaFQn+UnsNday4_8LM6+3G6=cfp9DHecPxDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo742BOxzxRaFQn+UnsNday4_8LM6+3G6=cfp9DHecPxDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Oct  8 19:02:31 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 52543aa720867814516481
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 10:47:49AM -0600, Bjorn Helgaas wrote:
> I still have no idea what an "aperture type IOMMU" is,
> other than that it is "different."

An aperture based IOMMU is basically any GART-like IOMMU which can only
remap a small window (the aperture) of the DMA address space. DMA
outside of that window is either blocked completly or passed through
untranslated.


	Joerg


