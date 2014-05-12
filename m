Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbaELTFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 15:05:17 -0400
Received: from 8bytes.org ([85.214.48.195]:41929 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbaELTFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 15:05:15 -0400
Date: Mon, 12 May 2014 21:05:12 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/amd: Fix interrupt remapping for aliased devices
Message-ID: <20140512190511.GB10562@8bytes.org>
References: <20140422160802.11173.29725.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422160802.11173.29725.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon May 12 21:05:14 2014
X-DSPAM-Confidence: 0.9977
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53711b6a20861049022336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:08:40AM -0600, Alex Williamson wrote:
> An apparent cut and paste error prevents the correct flags from being
> set on the alias device resulting in MSI on conventional PCI devices
> failing to work.  This also produces error events from the IOMMU like:
> 
> AMD-Vi: Event logged [INVALID_DEVICE_REQUEST device=00:14.4 address=0x000000fdf8000000 flags=0x0a00]
> 
> Where 14.4 is a PCIe-to-PCI bridge with a device behind it trying to
> use MSI interrupts.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: stable@vger.kernel.org

Applied, thanks Alex.


